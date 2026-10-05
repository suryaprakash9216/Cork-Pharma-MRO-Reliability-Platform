# Cork Pharma MRO Reliability Platform – SAP PM Ready

> **SIMULATED PORTFOLIO PROJECT**  
> All equipment, maintenance, inventory, supplier, production, cost, and operational data in this project is simulated. No real pharmaceutical company or confidential GMP data is used.

## Project Overview

This project simulates an MRO reliability, maintenance, engineering, and spare-parts analytics platform for a pharmaceutical manufacturing environment in Cork, Ireland.

It combines MySQL data engineering, Python reliability analytics, Power BI dashboards, dimensional modelling, data-quality controls, Row-Level Security, and operational alert design.

The project was developed to demonstrate how engineering, maintenance, inventory, procurement, and analytics can work together in one decision-support platform.

The solution contains a star schema, SCD Type 2 asset history, six SQL data-quality checks, Python-generated reliability and inventory outputs, and a three-page Power BI report.

The Power BI model supports separate Manager and Technician access using dynamic Row-Level Security.

All project results and operational scenarios are based on **SIMULATED data**.

---

## Tools & Technologies

MySQL 8 | SQL | Python | Pandas | SQLAlchemy | PyMySQL | Power BI | DAX | Power BI Service | Star Schema | SCD Type 2 | Data Quality | Row-Level Security | MRO Analytics | Reliability Analytics | Supply Chain Analytics

---

## Project Workflow

### 1. Dataset Preparation

Created simulated asset, spare-parts, and maintenance-breakdown datasets.

### 2. Initial Data Validation

Checked missing values, duplicate work orders, invalid dates, negative stock, and missing spare references.

### 3. MySQL Raw Layer

Loaded the source datasets into MySQL tables while preserving the original simulated records.

### 4. Star Schema

Built a dimensional model containing asset, spare, and date dimensions linked to a maintenance breakdown fact table.

### 5. SCD Type 2

Implemented Slowly Changing Dimension Type 2 in the asset dimension to preserve historical asset master-data changes.

### 6. Data Quality Framework

Implemented six SQL data-quality tests with a fail-stop approach.

### 7. Python Analytics

Generated spare-demand forecasting, asset reliability, monthly energy, and stockout-risk outputs.

### 8. Power BI Model

Created relationships between the star-schema tables and analytical outputs.

### 9. DAX Measures

Created four primary measures for downtime, energy efficiency, stockout risk, and OTIF proxy performance.

### 10. Dashboard Development

Built three Power BI pages: Risk, Engineering, and Action.

### 11. Row-Level Security

Implemented Manager and Technician security roles using a UserAccess table and USERPRINCIPALNAME().

### 12. Deployment & Alert Design

Published the report to Power BI Service and designed a stockout alert workflow. Live alert activation was blocked by Power BI/Fabric licensing.

---

## Star Schema & SCD Type 2

The analytical model contains:

* dim_asset
* dim_spare
* dim_date
* fact_breakdown

The dim_asset table uses **Slowly Changing Dimension Type 2**.

When an asset attribute changes, such as location:

* The historical asset record remains available.
* The previous row receives an end date.
* A new current row is created.
* Historical maintenance events retain the correct asset version.

The model contains **11 asset-dimension rows representing 10 physical assets** because one simulated asset has two historical versions.

---

## Data Quality Framework

Six SQL data-quality checks were implemented:

* Duplicate work-order IDs
* Orphan asset references
* Spare marked as used without a spare reference
* Spare and equipment-type mismatch
* Invalid or future breakdown dates
* Negative spare inventory

**Validation Result: 0 bad rows across all six tests.**

Production-style control:

DQ failure → Stop processing → Investigate → Correct → Rerun validation

---

## Python Analytics Outputs

Python generates four analytical outputs:

* spare_demand_forecast.csv
* asset_reliability.csv
* monthly_energy.csv
* stockout_risk.csv

The Python analysis covers:

* Three-month spare-demand forecasting
* MTBF — Mean Time Between Failures
* MTTR — Mean Time To Repair
* Monthly energy performance
* Energy per unit
* Stockout-risk identification
* Reorder exposure

The reliability calculations use a simulated planned operating assumption of **4,800 hours per asset**.

---

## Core DAX Measures

* Total Downtime
* Energy per Unit
* Stockout Count
* OTIF Proxy %

---

## Dashboard Screenshots

### Risk Overview

The Risk page focuses on critical spare-parts availability, supplier lead time, inventory shortage, and reorder exposure.

Key KPIs:

* Stockout Count: **6**
* OTIF Proxy: **45.83%**
* Total Downtime: **716.60 hours**
* Critical A Assets: **6**
* Simulated Reorder Exposure: **€4,940**

![Risk](screenshots/page1_risk.png)

### Engineering Overview

The Engineering page focuses on asset reliability, failure type, machine downtime, MTBF, MTTR, and energy performance.

Key KPIs:

* Total Downtime: **716.60 hours**
* Average MTBF: **430.42 hours**
* Average MTTR: **6.01 hours**
* Energy per Unit: approximately **0.04**

![Engineering](screenshots/page2_engineering.png)

### Action Overview

The Action page converts the analysis into maintenance-planning and spare-parts purchasing priorities.

Key KPIs:

* Stockout Count: **6**
* Total Downtime: **716.60 hours**
* OTIF Proxy: **45.83%**
* Forecast Demand — Next 3 Months: **14.68**
* Simulated Reorder Exposure: **€4,940**

![Action](screenshots/page3_action.png)

---

## Row-Level Security

Dynamic Row-Level Security was implemented in Power BI.

### Manager

* Can view all plant locations.

### Technician

* Can view only the plant location assigned to that user.

A UserAccess table maps users to authorised locations.

The Technician role uses USERPRINCIPALNAME() to identify the logged-in user and restrict the report accordingly.

---

## Operational Alert Design

A stockout-risk alert was designed using the following condition:

**Stockout Count > 0**

Intended action:

* Send an email or Teams notification.
* Notify the responsible maintenance or planning user.
* Highlight critical spare-parts risk.

Suggested subject:

**Critical A MRO Stockout Risk - Cork Pharma**

The report was successfully published to Power BI Service.

Live alert creation could not be completed because the Power BI/Fabric trial had expired and the account did not have permission to create the required Fabric alert item.

* Alert workflow: **Designed**
* Live deployment: **Licence-blocked**

---

## SAP PM / MM Mapping

| Project Capability | SAP PM / MM Relevance |
| --- | --- |
| Asset master data | SAP PM Equipment / Technical Object concepts |
| Breakdown records | SAP PM Breakdown Maintenance |
| Maintenance work orders | SAP PM Maintenance Order concepts |
| MTBF and MTTR | Maintenance and reliability analysis |
| Spare master data | SAP MM Material Master concepts |
| Stock quantity | SAP MM Inventory Management |
| Minimum stock | Reorder and inventory-planning concepts |
| Supplier lead time | SAP MM Purchasing / Vendor planning |
| Spare-demand forecast | Material planning / MRP-related concepts |
| Reorder priorities | Maintenance and procurement coordination |

The project is described as **SAP PM Ready** because it models relevant maintenance and materials-management concepts. It does not claim a live SAP integration.

---

## Key Results

* Processed **120 simulated maintenance work orders**.
* Modelled **10 physical assets** and **10 spare parts**.
* Built a MySQL star schema with SCD Type 2 history.
* Completed **6 SQL data-quality tests with 0 bad rows**.
* Generated four Python analytical outputs.
* Calculated MTBF and MTTR for simulated assets.
* Identified **6 stockout-risk spare parts**.
* Identified **7 units of total simulated shortage**.
* Calculated **€4,940 simulated reorder exposure**.
* Analysed **716.60 hours of simulated downtime**.
* Achieved an OTIF Proxy result of **45.83%**.
* Produced a three-month forecast value of **14.68**.
* Implemented Manager and Technician RLS.
* Published the report to Power BI Service.
* Designed an operational stockout alert workflow.

---

## Limitations

* All operational data is simulated.
* No real pharmaceutical company data is used.
* No confidential GMP information is included.
* Spare-demand forecasting uses a simple moving-average approach.
* MTBF calculations use an assumed operating-hours value.
* SAP is not directly integrated.
* Power BI alert deployment was blocked by licensing.
* The solution is a portfolio analytics project, not a validated GMP production system.

---

## Data Disclaimer

**All project data is SIMULATED.**

The project contains no real:

* Pharmaceutical production records
* GMP records
* Employee information
* Maintenance transactions
* Supplier transactions
* Commercially sensitive information
* Proprietary company data

All equipment scenarios, inventory levels, costs, breakdowns, production values, and operational results were created for learning, portfolio demonstration, and interview preparation.

---

## Runbook

### 1. Refresh Source Data

Update assets.csv, spares_inventory.csv, and breakdowns.csv and load the latest records into MySQL.

### 2. Run Data Quality Tests

Run all six SQL checks and continue only when every test returns **0 bad rows**.

### 3. Refresh Python Analytics

Run the Python analysis process and verify that all four analytical CSV outputs are created successfully.

### 4. Refresh Power BI

Open Cork_Pharma_MRO_Reliability_Platform.pbix, refresh the model, and validate the Risk, Engineering, and Action pages.

### 5. Validate Security & Actions

Test Manager and Technician RLS, review Stockout Count, and check the Priority Reorder Actions table when stockout risk is greater than zero.

---

## Repository Structure

### Data

* data/assets.csv
* data/spares_inventory.csv
* data/breakdowns.csv

### SQL

* sql/raw_tables.sql
* sql/star_schema.sql
* sql/dq_tests.sql

### Python

* python/mro_analysis.py

### Outputs

* outputs/spare_demand_forecast.csv
* outputs/asset_reliability.csv
* outputs/monthly_energy.csv
* outputs/stockout_risk.csv

### Power BI

* powerbi/Cork_Pharma_MRO_Reliability_Platform.pbix

### Screenshots

* screenshots/page1_risk.png
* screenshots/page2_engineering.png
* screenshots/page3_action.png
