-- =============================================================================
-- Script: 08_views.sql
-- Description: Create Database Views for simplified reporting.
-- Views: vw_monthly_revenue_profit, vw_category_performance, vw_target_vs_actual
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. View: vw_monthly_revenue_profit
-- Description: Aggregated Monthly Sales and Profit
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_monthly_revenue_profit;
CREATE VIEW vw_monthly_revenue_profit AS
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS YearMonth,
    YEAR(o.order_date) AS Order_Year,
    MONTH(o.order_date) AS Order_Month,
    SUM(oi.amount) AS Total_Revenue,
    SUM(oi.profit) AS Total_Profit,
    ROUND((SUM(oi.profit) / SUM(oi.amount)) * 100, 2) AS Profit_Margin_Pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YearMonth, Order_Year, Order_Month
ORDER BY YearMonth;

-- -----------------------------------------------------------------------------
-- 2. View: vw_category_performance
-- Description: Sales Performance by Category and Sub-Category
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_category_performance;
CREATE VIEW vw_category_performance AS
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.quantity) AS Qty_Sold,
    SUM(oi.amount) AS Total_Revenue,
    SUM(oi.profit) AS Total_Profit,
    ROUND((SUM(oi.profit) / SUM(oi.amount)) * 100, 2) AS Margin_Pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.sub_category
ORDER BY Total_Revenue DESC;

-- -----------------------------------------------------------------------------
-- 3. View: vw_target_vs_actual
-- Description: Comparison of Actual Sales vs Monthly Targets per Category
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_target_vs_actual;
CREATE VIEW vw_target_vs_actual AS
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS Month_Date,
    p.category,
    SUM(oi.amount) AS Actual_Sales,
    MAX(st.target_amount) AS Target_Amount, -- Using MAX as target is same for the month-category
    (SUM(oi.amount) - MAX(st.target_amount)) AS Variance,
    CASE 
        WHEN SUM(oi.amount) >= MAX(st.target_amount) THEN 'Met' 
        ELSE 'Missed' 
    END AS Status
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN sales_targets st 
    ON DATE_FORMAT(o.order_date, '%Y-%m-01') = st.target_month 
    AND p.category = st.category
GROUP BY Month_Date, p.category
ORDER BY Month_Date, p.category;


SELECT 'Views Created Successfully' AS Status;
