-- =========================================================
-- STEP 5 ONLY
-- DQ TESTS - STAR TABLES
-- MySQL 8.0
--
-- PASS CONDITION:
-- Every test must return bad_rows = 0
-- =========================================================

USE cork_mro_project;


-- =========================================================
-- TEST 1: Duplicate work_order_id in fact_breakdown
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM (
    SELECT work_order_id
    FROM fact_breakdown
    GROUP BY work_order_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- =========================================================
-- TEST 2: Orphan asset_key in fact_breakdown
-- Fact row must match dim_asset
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM fact_breakdown f
LEFT JOIN dim_asset a
    ON f.asset_key = a.asset_key
WHERE a.asset_key IS NULL;


-- =========================================================
-- TEST 3: spare_used = Y but spare_key is blank
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM fact_breakdown
WHERE spare_used = 'Y'
  AND spare_key IS NULL;


-- =========================================================
-- TEST 4: Spare type does not match asset equipment type
-- Example:
-- PLC spare should link to PLC card equipment
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM fact_breakdown f
JOIN dim_asset a
    ON f.asset_key = a.asset_key
JOIN dim_spare s
    ON f.spare_key = s.spare_key
WHERE f.spare_used = 'Y'
  AND a.equipment_type <> s.asset_type_link;


-- =========================================================
-- TEST 5: Date after project end date
-- Project end = 2025-08-31
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM fact_breakdown f
JOIN dim_date d
    ON f.date_key = d.date_key
WHERE d.full_date > '2025-08-31';


-- =========================================================
-- TEST 6: Negative stock quantity
-- Expected: 0
-- =========================================================

SELECT COUNT(*) AS bad_rows
FROM dim_spare
WHERE stock_qty < 0;