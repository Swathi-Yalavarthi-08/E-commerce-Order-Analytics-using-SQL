-- =============================================================================
-- Script: 02_create_staging_tables.sql
-- Description: Creates 3 staging tables (raw_*) to match Kaggle CSV columns.
-- Methodology: All columns are defined as VARCHAR/TEXT to safely ingest raw data.
-- CSV Mapping:
--   1. List of Orders.csv -> stg_list_of_orders
--   2. Order Details.csv  -> stg_order_details
--   3. Sales target.csv   -> stg_sales_target
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Staging Table: List of Orders
-- Columns: Order ID, Order Date, CustomerName, State, City
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_list_of_orders;
CREATE TABLE stg_list_of_orders (
    Order_ID      VARCHAR(255),
    Order_Date    VARCHAR(255),
    CustomerName  VARCHAR(255),
    State         VARCHAR(255),
    City          VARCHAR(255)
);

-- -----------------------------------------------------------------------------
-- 2. Staging Table: Order Details
-- Columns: Order ID, Amount, Profit, Quantity, Category, Sub-Category
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_order_details;
CREATE TABLE stg_order_details (
    Order_ID      VARCHAR(255),
    Amount        VARCHAR(255),
    Profit        VARCHAR(255),
    Quantity      VARCHAR(255),
    Category      VARCHAR(255),
    Sub_Category  VARCHAR(255)
);

-- -----------------------------------------------------------------------------
-- 3. Staging Table: Sales Target
-- Columns: Month of Order Date, Category, Target
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_sales_target;
CREATE TABLE stg_sales_target (
    Month_of_Order_Date VARCHAR(255),
    Category            VARCHAR(255),
    Target              VARCHAR(255)
);

SELECT 'Staging tables created successfully' AS Status;
