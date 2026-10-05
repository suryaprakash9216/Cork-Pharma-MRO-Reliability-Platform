CREATE DATABASE IF NOT EXISTS cork_mro_project;
USE cork_mro_project;

CREATE TABLE assets (
    asset_id VARCHAR(10) PRIMARY KEY,
    machine_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(30) NOT NULL,
    location VARCHAR(100) NOT NULL,
    criticality CHAR(1) NOT NULL,
    install_year INT NOT NULL
);

CREATE TABLE spares_inventory (
    spare_id VARCHAR(10) PRIMARY KEY,
    spare_name VARCHAR(100) NOT NULL,
    asset_type_link VARCHAR(30) NOT NULL,
    stock_qty INT NOT NULL,
    min_stock INT NOT NULL,
    unit_cost_euro DECIMAL(10,2) NOT NULL,
    supplier VARCHAR(100) NOT NULL,
    lead_time_days INT NOT NULL
);

CREATE TABLE breakdowns (
    work_order_id VARCHAR(20) PRIMARY KEY,
    date DATE NOT NULL,
    asset_id VARCHAR(10) NOT NULL,
    fault_type VARCHAR(20) NOT NULL,
    downtime_hours DECIMAL(6,2) NOT NULL,
    spare_used CHAR(1) NOT NULL,
    spare_id_used VARCHAR(10) NULL,
    energy_kWh DECIMAL(10,2) NOT NULL,
    units_produced INT NOT NULL,

    FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
);

SELECT COUNT(*) AS asset_rows
FROM assets;

SELECT COUNT(*) AS spare_rows
FROM spares_inventory;

SELECT COUNT(*) AS breakdown_rows
FROM breakdowns;