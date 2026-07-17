-- =============================================================================
-- Script: 06_analytics_queries.sql
-- Description: Final Analytics and KPI reporting using Normalized Tables.
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- KPI 1: Monthly Sales & Profit Trends
-- -----------------------------------------------------------------------------
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS YearMonth,
    SUM(oi.amount) AS Total_Sales,
    SUM(oi.profit) AS Total_Profit,
    ROUND((SUM(oi.profit) / SUM(oi.amount)) * 100, 2) AS Profit_Margin_Pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YearMonth
ORDER BY YearMonth;

-- -----------------------------------------------------------------------------
-- KPI 2: Top Performing Product Categories
-- -----------------------------------------------------------------------------
SELECT 
    p.category,
    p.sub_category,
    SUM(oi.quantity) AS Qty_Sold,
    SUM(oi.amount) AS Total_Revenue,
    SUM(oi.profit) AS Total_Profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY Total_Profit DESC;

-- -----------------------------------------------------------------------------
-- KPI 3: State-wise Sales Performance
-- -----------------------------------------------------------------------------
SELECT 
    c.state,
    COUNT(DISTINCT o.order_id) AS Order_Count,
    SUM(oi.amount) AS Total_Sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY Total_Sales DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- KPI 4: Target Achievement vs Actuals
-- -----------------------------------------------------------------------------
-- 1. Calculate Monthly Actuals per Category
WITH MonthlyActuals AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        p.category,
        SUM(oi.amount) AS actual_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01'), p.category
)
-- 2. Compare with Targets
SELECT 
    ma.sales_month,
    ma.category,
    ma.actual_sales,
    st.target_amount,
    CASE 
        WHEN ma.actual_sales >= st.target_amount THEN 'Met' 
        ELSE 'Missed' 
    END AS Status,
    ROUND((ma.actual_sales - st.target_amount), 2) AS Variance
FROM MonthlyActuals ma
JOIN sales_targets st 
    ON ma.sales_month = st.target_month 
    AND ma.category = st.category
ORDER BY ma.sales_month, ma.category;
