-- =============================================================================
-- Script: 07_advanced_queries.sql
-- Description: Advanced Analytics using CTEs and Window Functions
-- Techniques: ROW_NUMBER(), LAG(), Aggregations, Complex Joins
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Top Sub-Category per Category (Using ROW_NUMBER)
-- -----------------------------------------------------------------------------
WITH SubCategorySales AS (
    SELECT 
        p.category,
        p.sub_category,
        SUM(oi.amount) AS Total_Sales
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.sub_category
),
RankedSubCategories AS (
    SELECT 
        category,
        sub_category,
        Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY Total_Sales DESC) AS Rn
    FROM SubCategorySales
)
SELECT * 
FROM RankedSubCategories
WHERE Rn = 1;

-- -----------------------------------------------------------------------------
-- 2. Repeat Customers Rate
-- Logic: (Customers with >1 Order) / Total Customers
-- -----------------------------------------------------------------------------
WITH CustomerOrders AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS Order_Count
    FROM orders
    GROUP BY customer_id
)
SELECT 
    COUNT(CASE WHEN Order_Count > 1 THEN 1 END) AS Repeat_Customers,
    COUNT(*) AS Total_Customers,
    ROUND((COUNT(CASE WHEN Order_Count > 1 THEN 1 END) / COUNT(*)) * 100, 2) AS Repeat_Customer_Rate_Pct
FROM CustomerOrders;

-- -----------------------------------------------------------------------------
-- 3. Customer Lifetime Value (CLV)
-- Top 10 Customers by Total Lifetime Revenue
-- -----------------------------------------------------------------------------
WITH CustomerRevenue AS (
    SELECT 
        c.customer_name,
        SUM(oi.amount) AS Lifetime_Value,
        COUNT(DISTINCT o.order_id) AS Total_Orders,
        ROUND(SUM(oi.amount) / COUNT(DISTINCT o.order_id), 2) AS Avg_Ticket_Size
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_name
)
SELECT * 
FROM CustomerRevenue
ORDER BY Lifetime_Value DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 4. Target vs Actual Sales per Category per Month
-- -----------------------------------------------------------------------------
WITH Actuals AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        p.category,
        SUM(oi.amount) AS actual_amount
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01'), p.category
)
SELECT 
    a.sales_month,
    a.category,
    a.actual_amount,
    st.target_amount,
    (a.actual_amount - st.target_amount) AS variance,
    CASE 
        WHEN a.actual_amount >= st.target_amount THEN 'Met' 
        ELSE 'Missed' 
    END AS Status
FROM Actuals a
JOIN sales_targets st 
    ON a.sales_month = st.target_month 
    AND a.category = st.category
ORDER BY a.sales_month, a.category;

-- -----------------------------------------------------------------------------
-- 5. Monthly Growth % (MoM) using LAG()
-- -----------------------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS Sales_Month,
        SUM(oi.amount) AS Current_Month_Sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
GrowthCalc AS (
    SELECT 
        Sales_Month,
        Current_Month_Sales,
        LAG(Current_Month_Sales) OVER (ORDER BY Sales_Month) AS Previous_Month_Sales
    FROM MonthlySales
)
SELECT 
    Sales_Month,
    Current_Month_Sales,
    Previous_Month_Sales,
    ROUND(((Current_Month_Sales - Previous_Month_Sales) / Previous_Month_Sales) * 100, 2) AS MoM_Growth_Percentage
FROM GrowthCalc;

-- -----------------------------------------------------------------------------
-- 6. Profit Margin % per Category
-- -----------------------------------------------------------------------------
SELECT 
    p.category,
    SUM(oi.amount) AS Total_Revenue,
    SUM(oi.profit) AS Total_Profit,
    ROUND((SUM(oi.profit) / SUM(oi.amount)) * 100, 2) AS Profit_Margin_Pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY Profit_Margin_Pct DESC;
