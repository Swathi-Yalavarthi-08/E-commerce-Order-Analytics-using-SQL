-- =============================================================================
-- Script: 03_etl_transformation.sql
-- Description: Transformations and Loading into Final Normalized Tables
-- FINAL TABLES: orders, order_details, sales_targets
-- TASKS: Date handling, cleaning, type conversion
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Create Final Table: orders
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    Order_ID VARCHAR(50) PRIMARY KEY,
    Order_Date DATE,
    CustomerName VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- 2. Create Final Table: order_details
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_details;
CREATE TABLE order_details (
    Detail_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Amount DECIMAL(10,2),
    Profit DECIMAL(10,2),
    Quantity INT,
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- 3. Create Final Table: sales_targets
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS sales_targets;
CREATE TABLE sales_targets (
    Target_ID INT AUTO_INCREMENT PRIMARY KEY,
    Month_Order_Date DATE,
    Category VARCHAR(100),
    Target DECIMAL(10,2)
);

-- =============================================================================
-- TRANSFORMATION SECTION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Load Orders
-- Logic: Convert DD-MM-YYYY string to Date. Handle potential duplicates (IGNORE)
-- -----------------------------------------------------------------------------
INSERT INTO orders (Order_ID, Order_Date, CustomerName, State, City)
SELECT DISTINCT 
    TRIM(Order_ID), 
    STR_TO_DATE(Order_Date, '%d-%m-%Y'), 
    TRIM(CustomerName), 
    TRIM(State), 
    TRIM(City)
FROM stg_list_of_orders
WHERE Order_ID IS NOT NULL AND Order_ID != '';

-- -----------------------------------------------------------------------------
-- Load Order Details
-- Logic: Convert numbers. Ensure Order_ID exists in orders table first.
-- -----------------------------------------------------------------------------
INSERT INTO order_details (Order_ID, Amount, Profit, Quantity, Category, Sub_Category)
SELECT 
    TRIM(od.Order_ID), 
    CAST(od.Amount AS DECIMAL(10,2)), 
    CAST(od.Profit AS DECIMAL(10,2)), 
    CAST(od.Quantity AS SIGNED), 
    TRIM(od.Category), 
    TRIM(od.Sub_Category)
FROM stg_order_details od
JOIN orders o ON TRIM(od.Order_ID) = o.Order_ID; -- Inner join to ensure integrity

-- -----------------------------------------------------------------------------
-- Load Sales Targets
-- Logic: Convert 'Apr-18' -> '01-Apr-18' -> Date
-- -----------------------------------------------------------------------------
INSERT INTO sales_targets (Month_Order_Date, Category, Target)
SELECT 
    STR_TO_DATE(CONCAT('01-', Month_of_Order_Date), '%d-%b-%y'), 
    TRIM(Category), 
    CAST(Target AS DECIMAL(10,2))
FROM stg_sales_target
WHERE Month_of_Order_Date IS NOT NULL;

SELECT 'ETL Process Completed: Data loaded in final tables' AS Status;
