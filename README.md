Cork Pharma MRO Reliability Platform – SAP PM Ready
SIMULATED PORTFOLIO PROJECT — no real pharmaceutical company, plant, employee, maintenance, inventory, supplier, production, or confidential GMP data is used.
Project Overview
The Cork Pharma MRO Reliability Platform – SAP PM Ready is a simulated maintenance, reliability, and spare-parts analytics project designed around a pharmaceutical manufacturing environment in Cork, Ireland.
The project combines engineering knowledge, MRO operations, inventory management, SQL data engineering, Python analytics, Power BI, security, and operational decision support.
The objective is not simply to create a dashboard. The project demonstrates a production-style analytics workflow including:
- Raw maintenance and inventory data
- Star-schema modelling
- Slowly Changing Dimension Type 2
- Data-quality controls
- Reliability analytics
- Spare-parts forecasting
- Inventory risk analysis
- Power BI dashboards
- Dynamic Row-Level Security
- Operational alert design
- Refresh and support runbook
Business Objectives
The platform was designed to answer practical MRO and maintenance-planning questions:
- Which spare parts are currently below minimum stock?
- Which critical assets are exposed to spare-parts shortages?
- Which suppliers have the longest lead times?
- Which machines generate the most downtime?
- Are electrical or mechanical faults driving maintenance losses?
- What are the MTBF and MTTR values for each asset?
- How is energy efficiency changing over time?
- What spare demand is expected over the next three months?
- Which spare parts should planners reorder first?
- How can managers and technicians securely access only the data relevant to them?
Dataset
The project uses a completely SIMULATED dataset created specifically for portfolio and learning purposes.
Main source files
- assets.csv
- spares_inventory.csv
- breakdowns.csv
Dataset size
- 10 assets
- 10 spare parts
- 120 maintenance work orders
- Breakdown period: September 2024 – August 2025
The simulated equipment includes:
- Motors
- VFD drives
- MCC breakers
- PLC cards
- Temperature sensors
- Flow sensors
The dataset includes realistic attributes such as:
- Equipment criticality
- Plant location
- Breakdown type
- Downtime
- Spare usage
- Spare stock
- Minimum stock
- Supplier
- Lead time
- Unit cost
- Energy consumption
- Units produced
Technology Stack
- MySQL 8
- SQL
- Python
- Pandas
- SQLAlchemy
- PyMySQL
- Power BI
- DAX
- Power BI Service
- Dimensional Modelling
- Star Schema
- Slowly Changing Dimension Type 2
- Row-Level Security
- Data Quality Testing
- Reliability Analytics
- Inventory Analytics
- MRO Analytics
Project Workflow
1. Data Preparation
Three simulated source datasets were created:
Assets
Contains equipment master information including:
- Asset ID
- Machine name
- Equipment type
- Location
- Criticality
- Installation year
Spare Parts
Contains spare-parts inventory information including:
- Spare ID
- Spare description
- Equipment type link
- Current stock
- Minimum stock
- Unit cost
- Supplier
- Supplier lead time
Breakdowns
Contains maintenance work-order information including:
- Work order ID
- Breakdown date
- Asset ID
- Fault type
- Downtime
- Spare usage
- Spare ID
- Energy consumption
- Units produced
2. Initial Data Validation
Before loading data into the database, quick validation checks were performed.
Checks included:
- Missing important fields
- Duplicate work-order IDs
- Invalid date ranges
- Negative stock
- Spare marked as used without a spare ID
The source data passed the initial validation.
3. MySQL Raw Data Layer
The datasets were loaded into MySQL using three source tables:
- assets
- spares_inventory
- breakdowns
The raw layer preserves the original simulated records before dimensional transformation.
4. Star Schema
The analytics model was redesigned as a star schema.
Dimension Tables
- dim_asset
- dim_spare
- dim_date
Fact Table
- fact_breakdown
This separates descriptive master data from maintenance-event transactions and creates a more scalable analytical model.
5. Slowly Changing Dimension Type 2
dim_asset implements Slowly Changing Dimension Type 2 (SCD2).
This allows historical changes to asset master data to be preserved rather than overwritten.
For example, if an asset changes location:
- The original asset record remains available for historical reporting.
- The old record receives an end date.
- A new current record is created.
- Historical breakdowns continue to reference the correct asset version.
The final dim_asset contains 11 rows for 10 physical assets because one asset has two historical versions.
6. Data Quality Framework
Six SQL data-quality controls were implemented.
DQ Test 1 — Duplicate Work Orders
Checks for duplicate work_order_id values.
DQ Test 2 — Orphan Assets
Checks whether maintenance facts reference an asset that does not exist in the asset dimension.
DQ Test 3 — Missing Spare Reference
Checks situations where:
spare_used = "Y"
but no valid spare key exists.
DQ Test 4 — Spare / Equipment Mismatch
Checks whether a spare has been assigned to an incompatible equipment type.
DQ Test 5 — Invalid Future Dates
Checks for breakdown dates outside the defined reporting period.
DQ Test 6 — Negative Inventory
Checks for spare-parts quantities below zero.
Validation Result
All six tests returned 0 bad rows.
The intended production control is:
DQ failure → stop ETL / investigate → correct data → rerun validation
7. Python Analytics
Python was used to generate additional engineering and planning outputs.
Four analytical datasets were created:
- spare_demand_forecast.csv
- asset_reliability.csv
- monthly_energy.csv
- stockout_risk.csv
Spare Demand Forecast
A three-month moving-average approach was used to generate simulated spare-demand forecasts for:
- September 2025
- October 2025
- November 2025
This supports maintenance-planning and purchasing decisions.
Asset Reliability
Reliability metrics were calculated for each asset.
MTBF
Mean Time Between Failures
Used to measure how long an asset operates between maintenance failures.
MTTR
Mean Time To Repair
Used to measure average repair duration.
The simulated reliability calculations use an assumed planned operating time of:
4,800 hours per asset
Energy Performance
Monthly energy consumption was compared with production output.
The KPI used is:
Energy per Unit = Total Energy / Total Units Produced
This provides an engineering efficiency indicator across the reporting period.
8. Stockout Risk Logic
A spare part is classified as being at risk when:
- Current stock is below minimum stock
- Supplier lead time is greater than 7 days
- The spare supports critical equipment
Current simulated result
- 6 spare parts at stockout risk
- 7 total units of shortage
- €4,940 simulated reorder exposure
The six identified risk items include:
- PLC Digital Input Card
- 5kW IE3 Motor
- 5.5kW VFD Drive
- Flow Sensor Module
- 3 Pole MCC Breaker
- 24V Inductive Sensor
9. Power BI Model
The Power BI model connects the dimensional tables to the maintenance fact table.
Core relationships include:
- dim_asset → fact_breakdown
- dim_spare → fact_breakdown
- dim_date → fact_breakdown
Additional forecast and stockout datasets are connected where appropriate.
10. Core DAX Measures
The report includes measures such as:
Total Downtime
Total Downtime =
SUM('cork_mro_project fact_breakdown'[downtime_hours])

Energy per Unit
Energy per Unit =
DIVIDE(
    SUM('cork_mro_project fact_breakdown'[energy_kWh]),
    SUM('cork_mro_project fact_breakdown'[units_produced]),
    0
)

Stockout Count
Stockout Count =
COUNTROWS(stockout_risk)

OTIF Proxy %
A simplified operational proxy was created using spare availability and supplier lead-time logic.
Current simulated result:
45.83%
11. Power BI Dashboard
The finished report contains three pages:
1. Risk
2. Engineering
3. Action
Risk Overview
The Risk page focuses on spare-parts inventory exposure and supplier risk.
KPIs
- Stockout Count: 6
- OTIF Proxy: 45.83%
- Total Downtime: 716.60 hours
- Critical A Assets: 6
Visuals
- Critical Spares at Risk
- Supplier Lead Time
- Stock vs Minimum Stock
- Critical Spare Risk Details
Risk Overview Screenshot
 
Engineering Overview
The Engineering page focuses on machine reliability and engineering performance.
KPIs
- Total Downtime: 716.60 hours
- Energy per Unit: approximately 0.04
- Average MTBF: 430.42 hours
- Average MTTR: 6.01 hours
Visuals
- Downtime by Fault Type
- Downtime by Machine
- MTBF vs MTTR by Machine
- Energy per Unit Trend
Electrical faults account for substantially more simulated downtime than mechanical faults.
Engineering Overview Screenshot
 
Action Overview
The Action page converts analytics into maintenance and purchasing priorities.
KPIs
- Stockout Count: 6
- Total Downtime: 716.60 hours
- OTIF Proxy: 45.83%
- Forecast Demand — Next 3 Months: 14.68
Visuals
- 3-Month Spare Demand Forecast
- Highest Downtime Assets
- Reorder Cost by Spare
- Priority Reorder Actions
The page allows a maintenance planner or supply-chain analyst to quickly identify which spare parts require purchasing attention.
Action Overview Screenshot
 
12. Row-Level Security
Dynamic Row-Level Security (RLS) was implemented in Power BI.
A UserAccess table maps users to their permitted plant location.
Example:
User	Access
Manager	All locations
Technician 1	Granulation Suite
Technician 2	Utility Plant


The technician role uses USERPRINCIPALNAME() to determine the logged-in user and restrict data accordingly.
Manager
Can view all plant data.
Technician
Can view only data associated with the technician's assigned location.
This demonstrates how the same Power BI report can securely serve multiple operational users.
13. Operational Alert Design
An automated stockout alert was designed.
Trigger
Stockout Count > 0
Intended Action
Send an email or Teams notification to the responsible maintenance / planning user.
Suggested Alert Subject
Critical A MRO Stockout Risk - Cork Pharma
Current Deployment Status
The report was successfully published to Power BI Service.
However, live alert creation was blocked because the Power BI/Fabric trial had expired and the account did not currently have permission to create the required Fabric alert item.
Therefore:
Alert workflow = designed
Live alert deployment = blocked by licensing
This limitation is documented rather than claiming functionality that was not deployed.
Key Results
The completed simulated platform achieved:
- 120 maintenance work orders processed
- 10 physical assets
- 10 spare parts
- Star-schema analytical model
- SCD Type 2 asset history
- 6 SQL data-quality tests
- 0 bad rows
- Python-based spare-demand forecasting
- MTBF and MTTR reliability analysis
- Energy-efficiency analytics
- 6 stockout-risk spares
- 7 units total shortage
- €4,940 simulated reorder exposure
- 716.60 simulated downtime hours
- Dynamic Manager / Technician RLS
- Three-page Power BI operational dashboard
- Power BI Service deployment
- Operational alert logic designed
What Changed From v1 to v2
The original project focused mainly on MRO dashboarding and basic spare-parts analytics.
Version 2 upgrades the solution into a more complete analytics platform.
Capability	v1	v2
MRO breakdown analysis	Yes	Yes
Spare inventory analysis	Yes	Yes
Python analytics	Yes	Yes
Power BI dashboards	Yes	Yes
Star schema	Basic	Enhanced
SCD Type 2	No	Yes
Automated DQ tests	Limited	6 tests
DQ result control	No	0 bad rows / fail-stop design
MTBF / MTTR	Yes	Enhanced
Spare forecast	Basic	3-month forecast
Dynamic RLS	Basic / planned	Manager + Technician implemented
Power BI Service	Limited	Published
Operational alert	Planned	Designed, licence-blocked
Runbook	No	Yes
Costed reorder exposure	Basic	€4,940 simulated risk


The main improvement is that v2 moves from dashboard creation toward data-platform ownership and operational governance.
SAP PM / MM Relevance
Although the project does not directly connect to a live SAP system, the business structure aligns with concepts commonly found in SAP PM and MM environments.
Relevant concepts include:
SAP PM-style concepts
- Equipment / asset master data
- Breakdown maintenance
- Maintenance work orders
- Machine reliability
- MTBF
- MTTR
- Failure analysis
SAP MM-style concepts
- Material / spare master
- Inventory quantity
- Minimum stock
- Supplier
- Lead time
- Reorder requirement
- Spare-parts planning
The project is therefore described as:
SAP PM Ready
rather than falsely claiming that SAP was directly integrated.
Business Value
The project demonstrates how engineering, maintenance, procurement, and analytics can be combined into one decision-support system.
Potential operational benefits include:
- Earlier identification of critical spare shortages
- Better maintenance planning
- Reduced risk of extended equipment downtime
- Improved supplier visibility
- Prioritised purchasing decisions
- Historical tracking of asset master-data changes
- Improved reporting data quality
- Controlled dashboard access
- Better communication between engineering and supply-chain teams
Limitations
This is a portfolio simulation and therefore has several deliberate limitations.
- All data is simulated.
- No real pharmaceutical company data is used.
- Spare-demand forecasts are based on a simple moving-average method.
- Downtime costs are not taken from a real organisation.
- SAP is not directly integrated.
- The Power BI alert was designed but could not be activated because of licence restrictions.
- The project is designed to demonstrate technical and analytical capability rather than represent a validated GMP production system.
Data Disclaimer
All project data, company scenarios, maintenance events, equipment details, supplier information, production values, costs, downtime, and inventory quantities are SIMULATED.
The project contains:
- No confidential pharmaceutical information
- No real GMP records
- No real employee information
- No real maintenance records
- No real supplier transactions
- No proprietary company data
The project was created solely for education, portfolio demonstration, and interview preparation.
RUNBOOK
Step 1 — Refresh Source Data
Update the simulated source files:
- assets.csv
- spares_inventory.csv
- breakdowns.csv
Load the latest data into the MySQL raw tables.
Check expected row counts before continuing.
Step 2 — Run Data Quality Tests
Run all six SQL data-quality controls.
Required result:
bad_rows = 0

for every test.
If any test returns bad records:
Stop → investigate → correct data → rerun DQ tests
Do not continue with the analytics refresh until the issue is resolved.
Step 3 — Refresh Python Analytics
Run the Python analysis process.
Confirm creation of:
spare_demand_forecast.csv
asset_reliability.csv
monthly_energy.csv
stockout_risk.csv

Verify that the script connects successfully to MySQL and completes without errors.
Step 4 — Refresh Power BI
Open:
Cork_Pharma_MRO_Reliability_Platform.pbix
Select:
Home → Refresh
Validate:
- Risk page
- Engineering page
- Action page
- KPI totals
- Forecast output
- Stockout-risk table
Step 5 — Validate Security and Actions
Test Power BI RLS.
Manager
Confirm access to all locations.
Technician
Confirm access only to the assigned plant location.
Review:
Stockout Count
If the value is greater than zero, review the Priority Reorder Actions table and escalate the affected critical spares.
The automatic notification workflow is designed but currently cannot be activated because of Power BI/Fabric licensing restrictions.
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
│   ├── Risk Overview
│   ├── Engineering Overview
│   └── Action Overview
│
├── RUNBOOK.md
└── README.md

Skills Demonstrated
MySQL | SQL | Python | Pandas | Power BI | DAX | Power BI Service | Star Schema | SCD Type 2 | Data Quality | ETL | Row-Level Security | MRO Analytics | Inventory Analytics | Reliability Engineering | MTBF | MTTR | Spare Forecasting | Supplier Lead-Time Analysis | KPI Design | Engineering Analytics | Supply Chain Analytics
