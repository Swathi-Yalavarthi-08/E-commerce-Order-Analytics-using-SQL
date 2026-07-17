-- =============================================================================
-- Script: 05_transform_insert.sql
-- Description: ETL Process - Transform Staging data and Insert into Final Tables.
-- Flow: Customers -> Products -> Orders -> Order Items -> Targets
-- =============================================================================

USE ecommerce_analytics;

-- Allow date conversions and non-strict group by if needed during import
SET sql_mode = ''; 

-- -----------------------------------------------------------------------------
-- 1. Insert distinct customers
-- -----------------------------------------------------------------------------
INSERT INTO customers (customer_name, state, city)
SELECT DISTINCT 
    TRIM(CustomerName), 
    TRIM(State), 
    TRIM(City)
FROM stg_list_of_orders
WHERE CustomerName IS NOT NULL AND CustomerName != ''
ON DUPLICATE KEY UPDATE customer_name=customer_name;
-- (The ON DUPLICATE KEY UPDATE is a no-op to handle POTENTIAL re-runs gracefully)

-- -----------------------------------------------------------------------------
-- 2. Insert distinct products from category/subcategory
-- -----------------------------------------------------------------------------
INSERT INTO products (category, sub_category)
SELECT DISTINCT 
    TRIM(Category), 
    TRIM(Sub_Category)
FROM stg_order_details
WHERE Category IS NOT NULL AND Category != ''
ON DUPLICATE KEY UPDATE category=category;

-- -----------------------------------------------------------------------------
-- 3. Insert orders with correct customer_id
-- Logic: Join with 'customers' table to look up customer_id based on Name/State/City.
-- -----------------------------------------------------------------------------
INSERT INTO orders (order_id, order_date, customer_id)
SELECT DISTINCT
    TRIM(s.Order_ID),
    STR_TO_DATE(s.Order_Date, '%d-%m-%Y'), -- Convert 'DD-MM-YYYY' to DATE
    c.customer_id
FROM stg_list_of_orders s
JOIN customers c 
    ON TRIM(s.CustomerName) = c.customer_name 
    AND TRIM(s.State) = c.state 
    AND TRIM(s.City) = c.city
WHERE s.Order_ID IS NOT NULL
ON DUPLICATE KEY UPDATE order_date=VALUES(order_date);

-- -----------------------------------------------------------------------------
-- 4. Insert order_items using join with products
-- Logic: Link Order Items to 'orders' (Order_ID) and 'products' (Product_ID).
-- -----------------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, amount, profit)
SELECT 
    TRIM(od.Order_ID),
    p.product_id,
    CAST(od.Quantity AS SIGNED),
    CAST(od.Amount AS DECIMAL(10,2)),
    CAST(od.Profit AS DECIMAL(10,2))
FROM stg_order_details od
JOIN products p 
    ON TRIM(od.Category) = p.category 
    AND TRIM(od.Sub_Category) = p.sub_category
-- Only insert items if the parent Order exists to maintain Referral Integrity
JOIN orders o 
    ON TRIM(od.Order_ID) = o.order_id;

-- -----------------------------------------------------------------------------
-- 5. Insert sales_targets with correct month conversion
-- Logic: Convert 'Month-YY' (e.g. 'Apr-18') into 'YYYY-MM-01'.
-- -----------------------------------------------------------------------------
INSERT INTO sales_targets (target_month, category, target_amount)
SELECT 
    STR_TO_DATE(CONCAT('01-', Month_of_Order_Date), '%d-%b-%y'),
    TRIM(Category),
    CAST(Target AS DECIMAL(10,2))
FROM stg_sales_target
WHERE Month_of_Order_Date IS NOT NULL;

SELECT 'ETL Transformation and Insertion Completed Successfully' AS Status;
