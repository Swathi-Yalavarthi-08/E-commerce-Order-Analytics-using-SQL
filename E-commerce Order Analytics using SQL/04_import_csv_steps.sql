-- =============================================================================
-- Script: 04_import_csv_steps.sql
-- Description: Instructions to load data into Staging tables.
-- Methods: 
--    A) MySQL Workbench Import Wizard (GUI Method) - EASIEST
--    B) LOAD DATA INFILE (SQL Command Method) - FASTEST
-- =============================================================================

USE ecommerce_analytics;

/*
=============================================================================
   METHOD A: MySQL Workbench Table Data Import Wizard (Recommended for Beginners)
=============================================================================
1. Open MySQL Workbench.
2. In 'Schemas' (left panel), expand 'ecommerce_analytics' -> 'Tables'.
3. Right-click 'stg_list_of_orders' -> Select "Table Data Import Wizard".
4. Browse to "List of Orders.csv". Click Next.
5. Select "Use existing table". Ensure 'stg_list_of_orders' is chosen. Click Next.
6. Click Next (Columns map automatically). Click Next to Finish.
7. Repeat for 'stg_order_details' and 'stg_sales_target'.
*/


/*
=============================================================================
   METHOD B: LOAD DATA INFILE (SQL Method)
=============================================================================
   IMPORTANT: This method requires 'local_infile' to be enabled.
   Run the command below (Line 29) to enable it on the server side.
   You may ALSO need to edit your connection (Advanced > Others > OPT_LOCAL_INFILE=1).
*/

-- 1. Enable Local Data Loading (Run this line first!)
SET GLOBAL local_infile = 1;

-- 2. Load List of Orders
-- REPLACE 'C:/path/to/...' with your actual file path (Forward slashes recommended)
LOAD DATA LOCAL INFILE 'p:/Projects/E-commerce Order Analytics using SQL/Data/List of Orders.csv'
INTO TABLE stg_list_of_orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Order_ID, Order_Date, CustomerName, State, City);

-- 3. Load Order Details
LOAD DATA LOCAL INFILE 'p:/Projects/E-commerce Order Analytics using SQL/Data/Order Details.csv'
INTO TABLE stg_order_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Order_ID, Amount, Profit, Quantity, Category, Sub_Category);

-- 4. Load Sales Target
LOAD DATA LOCAL INFILE 'p:/Projects/E-commerce Order Analytics using SQL/Data/Sales target.csv'
INTO TABLE stg_sales_target
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Month_of_Order_Date, Category, Target);

SELECT 'Data Load Instructions Completed' AS Status;
