-- =============================================================================
-- Script: 06_kpi_queries.sql
-- Description: Detailed KPI Analysis and Reporting
-- metrics: Revenue, Profit, AOV, State/City stats, Top Customers/Products
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Total Revenue and Total Profit
-- -----------------------------------------------------------------------------
SELECT 
    SUM(amount) AS Total_Revenue,
    SUM(profit) AS Total_Profit,
    ROUND((SUM(profit) / SUM(amount)) * 100, 2) AS Overall_Profit_Margin_Pct
FROM order_items;

-- -----------------------------------------------------------------------------
-- 2. Monthly Revenue & Monthly Profit
-- -----------------------------------------------------------------------------
SELECT 
    DATE_FORMAT(o.order_date, '%M-%Y') AS Month_Year,
    YEAR(o.order_date) AS Order_Year,
    MONTH(o.order_date) AS Order_Month,
    SUM(oi.amount) AS Monthly_Revenue,
    SUM(oi.profit) AS Monthly_Profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY Month_Year, Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

-- -----------------------------------------------------------------------------
-- 3. Average Order Value (AOV)
-- Formula: Total Revenue / Total Number of Orders
-- -----------------------------------------------------------------------------
SELECT 
    SUM(oi.amount) / COUNT(DISTINCT o.order_id) AS Avg_Order_Value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- -----------------------------------------------------------------------------
-- 4. Revenue by State
-- -----------------------------------------------------------------------------
SELECT 
    c.state,
    SUM(oi.amount) AS Total_Revenue,
    COUNT(DISTINCT o.order_id) AS Order_Count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY Total_Revenue DESC;

-- -----------------------------------------------------------------------------
-- 5. Revenue by City
-- -----------------------------------------------------------------------------
SELECT 
    c.city,
    c.state,
    SUM(oi.amount) AS Total_Revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.city, c.state
ORDER BY Total_Revenue DESC
LIMIT 20;

-- -----------------------------------------------------------------------------
-- 6. Category and Sub-category Performance
-- -----------------------------------------------------------------------------
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.quantity) AS Total_Qty_Sold,
    SUM(oi.amount) AS Total_Revenue,
    SUM(oi.profit) AS Total_Profit
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.sub_category
ORDER BY Total_Revenue DESC;

-- -----------------------------------------------------------------------------
-- 7. Top 10 Customers by Revenue
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_name,
    SUM(oi.amount) AS Total_Spent,
    COUNT(DISTINCT o.order_id) AS Orders_Placed
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY Total_Spent DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 8. Top 10 Products (Category-Subcategory) by Revenue
-- Note: 'Products' here refers to the unique Category/SubCategory combo
-- -----------------------------------------------------------------------------
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.amount) AS Revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.sub_category
ORDER BY Revenue DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 9. Most Loss-Making Categories (Profit < 0)
-- -----------------------------------------------------------------------------
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.profit) AS Net_Profit,
    SUM(oi.amount) AS Revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.sub_category
HAVING Net_Profit < 0
ORDER BY Net_Profit ASC;
