-- =========================================================
-- STEP 4 ONLY
-- Cork Pharma MRO Reliability Platform - SAP PM Ready
-- MySQL 8.0
-- STAR SCHEMA + SCD TYPE 2
-- =========================================================

USE cork_mro_project;


-- =========================================================
-- 1. DROP STAR TABLES IF REBUILDING
-- =========================================================

DROP TABLE IF EXISTS fact_breakdown;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_spare;
DROP TABLE IF EXISTS dim_asset;


-- =========================================================
-- 2. DIM_ASSET - SCD TYPE 2
-- =========================================================

CREATE TABLE dim_asset (
    asset_key INT AUTO_INCREMENT PRIMARY KEY,
    asset_id VARCHAR(10) NOT NULL,
    machine_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(30) NOT NULL,
    location VARCHAR(100) NOT NULL,
    criticality CHAR(1) NOT NULL,
    install_year INT NOT NULL,

    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    is_current TINYINT(1) NOT NULL,

    INDEX idx_dim_asset_id (asset_id),
    INDEX idx_dim_asset_current (asset_id, is_current)
);


-- =========================================================
-- 3. DIM_SPARE
-- =========================================================

CREATE TABLE dim_spare (
    spare_key INT AUTO_INCREMENT PRIMARY KEY,
    spare_id VARCHAR(10) NOT NULL UNIQUE,
    spare_name VARCHAR(100) NOT NULL,
    asset_type_link VARCHAR(30) NOT NULL,
    stock_qty INT NOT NULL,
    min_stock INT NOT NULL,
    unit_cost_euro DECIMAL(10,2) NOT NULL,
    supplier VARCHAR(100) NOT NULL,
    lead_time_days INT NOT NULL
);


-- =========================================================
-- 4. DIM_DATE
-- =========================================================

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year_num INT NOT NULL,
    quarter_num INT NOT NULL,
    month_num INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    year_month_label VARCHAR(7) NOT NULL,
    day_num INT NOT NULL,
    day_name VARCHAR(15) NOT NULL
);


-- =========================================================
-- 5. FACT_BREAKDOWN
-- =========================================================

CREATE TABLE fact_breakdown (
    breakdown_key INT AUTO_INCREMENT PRIMARY KEY,

    work_order_id VARCHAR(20) NOT NULL UNIQUE,

    date_key INT NOT NULL,
    asset_key INT NOT NULL,
    spare_key INT NULL,

    fault_type VARCHAR(20) NOT NULL,
    downtime_hours DECIMAL(6,2) NOT NULL,
    spare_used CHAR(1) NOT NULL,
    energy_kWh DECIMAL(10,2) NOT NULL,
    units_produced INT NOT NULL,

    CONSTRAINT fk_fact_date
        FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    CONSTRAINT fk_fact_asset
        FOREIGN KEY (asset_key)
        REFERENCES dim_asset(asset_key),

    CONSTRAINT fk_fact_spare
        FOREIGN KEY (spare_key)
        REFERENCES dim_spare(spare_key)
);


-- =========================================================
-- 6. LOAD DIM_ASSET FROM RAW ASSETS
-- Initial SCD2 version
-- =========================================================

INSERT INTO dim_asset (
    asset_id,
    machine_name,
    equipment_type,
    location,
    criticality,
    install_year,
    valid_from,
    valid_to,
    is_current
)
SELECT
    asset_id,
    machine_name,
    equipment_type,
    location,
    criticality,
    install_year,

    '2024-09-01' AS valid_from,
    '9999-12-31' AS valid_to,
    1 AS is_current

FROM assets;


-- =========================================================
-- 7. LOAD DIM_SPARE FROM RAW SPARES
-- =========================================================

INSERT INTO dim_spare (
    spare_id,
    spare_name,
    asset_type_link,
    stock_qty,
    min_stock,
    unit_cost_euro,
    supplier,
    lead_time_days
)
SELECT
    spare_id,
    spare_name,
    asset_type_link,
    stock_qty,
    min_stock,
    unit_cost_euro,
    supplier,
    lead_time_days

FROM spares_inventory;


-- =========================================================
-- 8. LOAD DIM_DATE
-- 2024-09-01 to 2025-08-31
-- =========================================================

INSERT INTO dim_date (
    date_key,
    full_date,
    year_num,
    quarter_num,
    month_num,
    month_name,
    year_month_label,
    day_num,
    day_name
)

WITH RECURSIVE date_series AS (

    SELECT DATE('2024-09-01') AS full_date

    UNION ALL

    SELECT DATE_ADD(full_date, INTERVAL 1 DAY)
    FROM date_series
    WHERE full_date < '2025-08-31'
)

SELECT
    CAST(DATE_FORMAT(full_date, '%Y%m%d') AS UNSIGNED) AS date_key,
    full_date,
    YEAR(full_date) AS year_num,
    QUARTER(full_date) AS quarter_num,
    MONTH(full_date) AS month_num,
    MONTHNAME(full_date) AS month_name,
    DATE_FORMAT(full_date, '%Y-%m') AS year_month_label,
    DAY(full_date) AS day_num,
    DAYNAME(full_date) AS day_name

FROM date_series;


-- =========================================================
-- 9. SCD2 EXAMPLE
-- A005 changes location
--
-- OLD:
-- Utility Plant
--
-- NEW:
-- Utilities Building
--
-- Effective date: 2025-06-01
-- =========================================================


-- STEP 9A:
-- Close the old A005 version

UPDATE dim_asset
SET
    valid_to = '2025-05-31',
    is_current = 0
WHERE asset_id = 'A005'
  AND is_current = 1;


-- STEP 9B:
-- Insert the new A005 version

INSERT INTO dim_asset (
    asset_id,
    machine_name,
    equipment_type,
    location,
    criticality,
    install_year,
    valid_from,
    valid_to,
    is_current
)
SELECT
    asset_id,
    machine_name,
    equipment_type,
    'Utilities Building' AS location,
    criticality,
    install_year,
    '2025-06-01' AS valid_from,
    '9999-12-31' AS valid_to,
    1 AS is_current

FROM assets

WHERE asset_id = 'A005';


-- =========================================================
-- 10. CHECK A005 SCD2 HISTORY
-- Expected: 2 rows
-- =========================================================

SELECT
    asset_key,
    asset_id,
    machine_name,
    location,
    valid_from,
    valid_to,
    is_current

FROM dim_asset

WHERE asset_id = 'A005'

ORDER BY valid_from;


-- =========================================================
-- 11. LOAD FACT_BREAKDOWN FROM RAW BREAKDOWNS
--
-- Important:
-- asset_key is selected using breakdown date
-- against the SCD2 effective dates.
-- =========================================================

INSERT INTO fact_breakdown (
    work_order_id,
    date_key,
    asset_key,
    spare_key,
    fault_type,
    downtime_hours,
    spare_used,
    energy_kWh,
    units_produced
)

SELECT
    b.work_order_id,

    CAST(
        DATE_FORMAT(b.date, '%Y%m%d')
        AS UNSIGNED
    ) AS date_key,

    a.asset_key,

    s.spare_key,

    b.fault_type,
    b.downtime_hours,
    b.spare_used,
    b.energy_kWh,
    b.units_produced

FROM breakdowns b

JOIN dim_asset a
    ON b.asset_id = a.asset_id
   AND b.date BETWEEN a.valid_from AND a.valid_to

LEFT JOIN dim_spare s
    ON b.spare_id_used = s.spare_id;


-- =========================================================
-- 12. FINAL ROW CHECKS
-- =========================================================

SELECT COUNT(*) AS dim_asset_rows
FROM dim_asset;
-- Expected: 11
-- 10 original assets + 1 new A005 SCD2 version


SELECT COUNT(*) AS dim_spare_rows
FROM dim_spare;
-- Expected: 10


SELECT COUNT(*) AS dim_date_rows
FROM dim_date;
-- Expected: 365


SELECT COUNT(*) AS fact_breakdown_rows
FROM fact_breakdown;
-- Expected: 120


-- =========================================================
-- 13. VERIFY CURRENT ASSETS
-- Expected: 10 current asset versions
-- =========================================================

SELECT COUNT(*) AS current_asset_rows
FROM dim_asset
WHERE is_current = 1;


-- =========================================================
-- 14. VERIFY A005 FACTS USE CORRECT SCD2 VERSION
-- =========================================================

SELECT
    f.work_order_id,
    d.full_date,
    a.asset_id,
    a.machine_name,
    a.location,
    a.valid_from,
    a.valid_to

FROM fact_breakdown f

JOIN dim_date d
    ON f.date_key = d.date_key

JOIN dim_asset a
    ON f.asset_key = a.asset_key

WHERE a.asset_id = 'A005'

ORDER BY d.full_date;

