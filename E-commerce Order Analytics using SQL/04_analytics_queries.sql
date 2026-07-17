-- =============================================================================
-- Script: 04_analytics_queries.sql
-- Description: KPI Analysis and Reporting
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- KPI 1: Total Sales and Profit Analysis
-- -----------------------------------------------------------------------------
SELECT 
    DATE_FORMAT(o.Order_Date, '%M-%Y') AS Month_Year,
    SUM(od.Amount) AS Total_Sales,
    SUM(od.Profit) AS Total_Profit,
    ROUND((SUM(od.Profit) / SUM(od.Amount)) * 100, 2) AS Profit_Margin_Percentage
FROM orders o
JOIN order_details od ON o.Order_ID = od.Order_ID
GROUP BY DATE_FORMAT(o.Order_Date, '%M-%Y'), YEAR(o.Order_Date), MONTH(o.Order_Date)
ORDER BY YEAR(o.Order_Date), MONTH(o.Order_Date);

-- -----------------------------------------------------------------------------
-- KPI 2: Category and Sub-Category Performance
-- -----------------------------------------------------------------------------
SELECT 
    Category,
    Sub_Category,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(Amount) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM order_details
GROUP BY Category, Sub_Category
ORDER BY Total_Profit DESC;

-- -----------------------------------------------------------------------------
-- KPI 3: State-wise Sales Distribution
-- -----------------------------------------------------------------------------
SELECT 
    State,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    SUM(od.Amount) AS Total_Sales
FROM orders o
JOIN order_details od ON o.Order_ID = od.Order_ID
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- KPI 4: Target Achievement Analysis (Target vs Actual)
-- -----------------------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(o.Order_Date, '%Y-%m-01') AS Sales_Month,
        od.Category,
        SUM(od.Amount) AS Actual_Sales
    FROM orders o
    JOIN order_details od ON o.Order_ID = od.Order_ID
    GROUP BY DATE_FORMAT(o.Order_Date, '%Y-%m-01'), od.Category
)
SELECT 
    ms.Sales_Month,
    ms.Category,
    ms.Actual_Sales,
    st.Target,
    CASE 
        WHEN ms.Actual_Sales >= st.Target THEN 'Target Met'
        ELSE 'Target Not Met'
    END AS Status,
    ROUND((ms.Actual_Sales - st.Target), 2) AS Variance
FROM MonthlySales ms
JOIN sales_targets st ON ms.Sales_Month = st.Month_Order_Date AND ms.Category = st.Category
ORDER BY ms.Sales_Month, ms.Category;
