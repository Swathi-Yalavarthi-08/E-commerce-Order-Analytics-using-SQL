-- =============================================================================
-- Script: 05_etl_transformation.sql
-- Description: ETL Process to populate Final Tables from Staging Tables.
-- Logic: Handles duplicates, generates PKs, transforms dates, and links FKs.
-- =============================================================================

USE ecommerce_analytics;

-- Disable strict mode temporarily if needed for date conversions issues
SET sql_mode = ''; 

-- -----------------------------------------------------------------------------
-- 1. Populate 'customers'
-- Logic: Extract unique Customer-Location combinations.
-- -----------------------------------------------------------------------------
INSERT INTO customers (customer_name, state, city)
SELECT DISTINCT 
    TRIM(CustomerName), 
    TRIM(State), 
    TRIM(City)
FROM stg_list_of_orders
WHERE CustomerName IS NOT NULL AND CustomerName != ''
-- integrity check: ignore duplicates if any constraint collision exists
ON DUPLICATE KEY UPDATE customer_name=customer_name; 

-- -----------------------------------------------------------------------------
-- 2. Populate 'products'
-- Logic: Extract unique Category-SubCategory combinations from Order Details.
-- -----------------------------------------------------------------------------
INSERT INTO products (category, sub_category)
SELECT DISTINCT 
    TRIM(Category), 
    TRIM(Sub_Category)
FROM stg_order_details
WHERE Category IS NOT NULL
ON DUPLICATE KEY UPDATE category=category;

-- -----------------------------------------------------------------------------
-- 3. Populate 'orders'
-- Logic: Transform Date (DD-MM-YYYY) and lookup Customer ID.
-- -----------------------------------------------------------------------------
INSERT INTO orders (order_id, order_date, customer_id)
SELECT DISTINCT
    TRIM(src.Order_ID),
    STR_TO_DATE(src.Order_Date, '%d-%m-%Y'),
    c.customer_id
FROM stg_list_of_orders src
LEFT JOIN customers c 
    ON TRIM(src.CustomerName) = c.customer_name 
    AND TRIM(src.State) = c.state 
    AND TRIM(src.City) = c.city
WHERE src.Order_ID IS NOT NULL
ON DUPLICATE KEY UPDATE order_date=VALUES(order_date);

-- -----------------------------------------------------------------------------
-- 4. Populate 'order_items'
-- Logic: Lookup Order ID and Product ID. Convert Amount/Profit to Decimal.
-- -----------------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, amount, profit)
SELECT 
    TRIM(src.Order_ID),
    p.product_id,
    CAST(src.Quantity AS UNSIGNED),
    CAST(src.Amount AS DECIMAL(10,2)),
    CAST(src.Profit AS DECIMAL(10,2))
FROM stg_order_details src
JOIN products p 
    ON TRIM(src.Category) = p.category 
    AND TRIM(src.Sub_Category) = p.sub_category
-- Ensure Order Integrity (only insert if order exists in 'orders' table)
JOIN orders o 
    ON TRIM(src.Order_ID) = o.order_id;

-- -----------------------------------------------------------------------------
-- 5. Populate 'sales_targets'
-- Logic: Transform 'Mon-YY' (e.g., Apr-18) to Date (2018-04-01).
-- -----------------------------------------------------------------------------
INSERT INTO sales_targets (target_month, category, target_amount)
SELECT 
    -- Convert 'Apr-18' -> '01-Apr-18' -> DATE
    STR_TO_DATE(CONCAT('01-', Month_of_Order_Date), '%d-%b-%y'),
    TRIM(Category),
    CAST(Target AS DECIMAL(10,2))
FROM stg_sales_target
WHERE Month_of_Order_Date IS NOT NULL;

SELECT 'ETL Data Load Completed Successfully' AS Status;
