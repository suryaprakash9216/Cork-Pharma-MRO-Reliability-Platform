Cork Pharma MRO Reliability Platform – SAP PM Ready
SIMULATED PORTFOLIO PROJECT
All equipment, maintenance, inventory, supplier, production, cost, and operational data in this project is simulated. No real pharmaceutical company or confidential GMP data is used.

Overview
This project simulates an MRO reliability and spare-parts analytics platform for a pharmaceutical manufacturing environment in Cork, Ireland.
It combines maintenance engineering, inventory management, SQL data engineering, Python analytics, and Power BI.
A MySQL star schema supports structured analysis of assets, spares, dates, and maintenance work orders.
SCD Type 2 preserves historical changes in asset master data instead of overwriting previous values.
Python produces reliability, energy, spare-demand, and stockout-risk analytical outputs.
Power BI converts the model into Risk, Engineering, and Action dashboards with security and operational controls.
Technology Stack
MySQL 8 | SQL | Python | Pandas | SQLAlchemy | PyMySQL | Power BI | DAX | Power BI Service | Star Schema | SCD Type 2 | Data Quality | RLS | MRO Analytics | Reliability Analytics | Supply Chain Analytics
Project Workflow
1. Create simulated asset, spare-parts, and breakdown datasets.
2. Validate source files using Excel checks.
3. Load raw data into MySQL.
4. Build the analytical star schema.
5. Implement SCD Type 2 for asset history.
6. Run six SQL data-quality tests.
7. Generate Python analytical outputs.
8. Build Power BI relationships.
9. Create four core DAX measures.
10. Develop Risk, Engineering, and Action pages.
11. Implement Manager and Technician RLS.
12. Publish to Power BI Service and design the operational alert workflow.
Star Schema and SCD Type 2
The analytical model contains:
- dim_asset
- dim_spare
- dim_date
- fact_breakdown
dim_asset implements Slowly Changing Dimension Type 2.
When an asset attribute changes, such as location:
- The historical record remains available.
- The previous record receives an end date.
- A new current record is created.
- Historical maintenance events retain the correct asset version.
The model contains 11 asset-dimension rows representing 10 physical assets because one asset has two historical versions.
Data Quality Framework
Six SQL data-quality checks were implemented:
- Duplicate work-order IDs
- Orphan asset references
- Spare marked as used without a spare reference
- Spare and equipment-type mismatch
- Invalid or future breakdown dates
- Negative spare inventory
All six tests returned 0 bad rows.
SELECT
    'DQ checks passed' AS validation_status,
    6 AS tests_completed,
    0 AS bad_rows;

The intended control is:
DQ failure → stop processing → investigate → correct → rerun validation
Python Analytics Outputs
Python generates four analytical outputs:
- spare_demand_forecast.csv
- asset_reliability.csv
- monthly_energy.csv
- stockout_risk.csv
The analysis covers:
- Three-month spare-demand forecasting
- MTBF
- MTTR
- Monthly energy performance
- Energy per unit
- Stockout-risk identification
- Reorder exposure
The reliability calculations use a simulated planned operating assumption of 4,800 hours per asset.
Core DAX Measures
Total Downtime
Energy per Unit
Stockout Count
OTIF Proxy %

Power BI Dashboard
The report contains three operational pages.
Risk Overview
Main KPIs:
- Stockout Count: 6
- OTIF Proxy: 45.83%
- Total Downtime: 716.60 hours
- Critical A Assets: 6
- Simulated Reorder Exposure: €4,940
Main visuals:
- Critical Spares at Risk
- Supplier Lead Time
- Stock vs Minimum Stock
- Critical Spare Risk Details
 
Engineering Overview
Main KPIs:
- Total Downtime: 716.60 hours
- Average MTBF: 430.42 hours
- Average MTTR: 6.01 hours
- Energy per Unit: approximately 0.04
Main visuals:
- Downtime by Fault Type
- Downtime by Machine
- MTBF vs MTTR by Machine
- Energy per Unit Trend
 
Action Overview
Main KPIs:
- Stockout Count: 6
- Total Downtime: 716.60 hours
- OTIF Proxy: 45.83%
- Forecast Demand for Next 3 Months: 14.68
- Simulated Reorder Exposure: €4,940
Main visuals:
- 3-Month Spare Demand Forecast
- Highest Downtime Assets
- Reorder Cost by Spare
- Priority Reorder Actions
 
Row-Level Security
Dynamic Row-Level Security was implemented in Power BI.
- Manager: can view all plant locations.
- Technician: can view only the plant location assigned to that user.
A UserAccess table maps users to authorised locations.
The Technician role uses USERPRINCIPALNAME() so the same report can provide different data access depending on the logged-in user.
Operational Alert
An operational stockout alert was designed using the rule:
Stockout Count > 0
Intended action:
- Send an email or Teams notification.
- Notify the responsible maintenance or planning user.
- Highlight Critical A spare-parts risk.
Suggested subject:
Critical A MRO Stockout Risk - Cork Pharma
The report was successfully published to Power BI Service, but live alert creation was blocked because the Power BI/Fabric trial had expired and the account did not have permission to create the required Fabric item.
- Alert workflow: Designed
- Live deployment: Licence-blocked
SAP PM / MM Mapping
Project Capability	SAP PM / MM Relevance
Asset master data	SAP PM Equipment / Technical Object concepts
Breakdown records	SAP PM Breakdown Maintenance
Maintenance work orders	SAP PM Maintenance Order concepts
MTBF and MTTR	Maintenance and reliability analysis
Spare master data	SAP MM Material Master concepts
Stock quantity	SAP MM Inventory Management
Minimum stock	Reorder and inventory-planning concepts
Supplier lead time	SAP MM Purchasing / Vendor planning
Spare-demand forecast	Material planning / MRP-related concepts
Reorder priorities	Maintenance and procurement coordination


The project is described as SAP PM Ready because it models relevant maintenance and materials-management concepts. It does not claim a live SAP integration.
Key Results
- Processed 120 simulated maintenance work orders.
- Modelled 10 physical assets and 10 spare parts.
- Built a MySQL star schema with SCD Type 2 history.
- Completed 6 SQL data-quality tests with 0 bad rows.
- Generated four Python analytical outputs.
- Calculated MTBF and MTTR for simulated assets.
- Identified 6 stockout-risk spare parts.
- Identified 7 units of total simulated shortage.
- Calculated €4,940 simulated reorder exposure.
- Analysed 716.60 hours of simulated downtime.
- Achieved an OTIF Proxy result of 45.83%.
- Produced a three-month forecast value of 14.68.
- Implemented Manager and Technician RLS.
- Published the report to Power BI Service.
- Designed an operational stockout alert workflow.
Limitations
- All operational data is simulated.
- No real pharmaceutical company data is used.
- No confidential GMP information is included.
- Spare-demand forecasting uses a simple moving-average approach.
- MTBF calculations use an assumed operating-hours value.
- SAP is not directly integrated.
- The Power BI alert was designed but could not be activated because of licensing restrictions.
- The solution is a portfolio analytics project, not a validated GMP production system.
Disclaimer
This is a SIMULATED portfolio project.
The project contains no real:
- Pharmaceutical production records
- GMP records
- Employee information
- Maintenance transactions
- Supplier transactions
- Commercially sensitive information
- Proprietary company data
All names, equipment scenarios, inventory levels, costs, breakdowns, production values, and operational results were created for learning, portfolio demonstration, and interview preparation.
Runbook
1. Refresh source data
   Update assets.csv, spares_inventory.csv, and breakdowns.csv, then load the latest records into MySQL.
2. Run data-quality checks
   Execute all six SQL tests. Continue only when every test returns 0 bad rows.
3. Refresh Python analytics
   Run the Python analysis process and confirm all four analytical CSV outputs are regenerated successfully.
4. Refresh Power BI
   Open Cork_Pharma_MRO_Reliability_Platform.pbix, refresh the model, and validate the Risk, Engineering, and Action pages.
5. Validate security and actions
   Test Manager and Technician RLS, review Stockout Count, and check the Priority Reorder Actions table when stockout risk is greater than zero.
Repository Structure
Cork-Pharma-MRO-Reliability-Platform/
│
├── data/
│   ├── assets.csv
│   ├── spares_inventory.csv
│   └── breakdowns.csv
│
├── sql/
│   ├── raw_tables.sql
│   ├── star_schema.sql
│   └── dq_tests.sql
│
├── python/
│   └── mro_analysis.py
│
├── outputs/
│   ├── spare_demand_forecast.csv
│   ├── asset_reliability.csv
│   ├── monthly_energy.csv
│   └── stockout_risk.csv
│
├── powerbi/
│   └── Cork_Pharma_MRO_Reliability_Platform.pbix
│
├── screenshots/
│   ├── page1_risk.png
│   ├── page2_engineering.png
│   └── page3_action.png
│
├── RUNBOOK.md
└── README.md

CV
Cork Pharma MRO Reliability Platform – SAP PM Ready | MySQL, Python, Power BI
Built a simulated MRO analytics platform using star-schema/SCD2 modelling, six DQ tests with 0 bad rows, MTBF/MTTR and spare-demand analytics, dynamic Manager/Technician RLS, and Power BI; identified 6 stockout-risk spares representing €4,940 simulated reorder exposure.
