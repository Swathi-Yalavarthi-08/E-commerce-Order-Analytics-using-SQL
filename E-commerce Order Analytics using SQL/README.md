# E-commerce Order Analytics using SQL - Project Documentation

## 1. Problem Statement
The e-commerce business faces challenges in consolidating raw order data from multiple sources to gain actionable insights. The current data storage is unstructured (CSV files) and requires significant cleaning to address date formatting inconsistencies and unnormalized structures. The business needs a robust SQL-based analytics solution to track sales performance, profitability, and target achievement across different categories and regions.

## 2. Project Objectives
- **Data Standardization**: Convert raw CSV data into a structured MySQL database with proper data types and normalized schema.
- **ETL Process**: Implement an Extract-Transform-Load pipeline to clean data, handle date formats (e.g., `DD-MM-YYYY` and `Mon-YY`), and resolve inconsistencies.
- **Performance Analysis**: Analyze sales and profit metrics across time periods, geographies (State/City), and product categories.
- **Target Comparison**: Evaluate actual sales against monthly targets to measure performance efficiency.

## 3. Dataset Explanation
The project uses three distinct datasets:
1.  **List of Orders.csv**: Contains transaction-level metadata.
    *   *Columns*: `Order ID` (Unique Identifier), `Order Date` (Date of transaction), `CustomerName`, `State`, `City`.
2.  **Order Details.csv**: Contains line-item details for each order.
    *   *Columns*: `Order ID` (Foreign Key), `Amount` (Sales Value), `Profit`, `Quantity`, `Category`, `Sub-Category`.
3.  **Sales Target.csv**: Contains monthly sales goals.
    *   *Columns*: `Month of Order Date` (e.g., 'Apr-18'), `Category`, `Target` (Monetary goal).

## 4. Schema Explanation
The project utilizes a **Star Schema** approach for optimal query performance:

### Staging Layer
Raw tables (`stg_*`) where data is loaded exactly as it appears in CSVs (using `TEXT`/`VARCHAR` types) to prevent load failures.
- `stg_list_of_orders`
- `stg_order_details`
- `stg_sales_target`

### Core Data Layer (Final Tables)
Transformed and cleaned tables with correct data types.
- **`orders`**: Dimension table for Order info.
    - `Order_ID` (PK, VARCHAR)
    - `Order_Date` (DATE)
    - `CustomerName`, `State`, `City` (VARCHAR)
- **`order_details`**: Fact table for transactions.
    - `Order_ID` (FK)
    - `Amount`, `Profit` (DECIMAL)
    - `Quantity` (INT)
    - `Category`, `Sub_Category` (VARCHAR)
- **`sales_targets`**: Fact table for goals.
    - `Month_Order_Date` (DATE - transformed to first day of month)
    - `Category` (VARCHAR)
    - `Target` (DECIMAL)

## 5. KPI List
1.  **Total Sales Revenue**: Sum of `Amount`.
2.  **Total Profit**: Sum of `Profit`.
3.  **Profit Margin %**: `(Total Profit / Total Sales) * 100`.
4.  **Total Quantity Sold**: Sum of `Quantity`.
5.  **Target Achievement Rate**: `(Actual Sales / Target Sales) * 100` per month/category.
6.  **Average Order Value (AOV)**: `Total Sales / Count of Distinct Orders`.
7.  **Top Performing State/City**: By Sales and Profit.

## 6. How to Run Steps
1.  **Database Setup**: Run `01_create_database.sql` to initialize the `ecommerce_analytics` database.
2.  **Data Loading**: Execute the subsequent scripts (provided in the project) to load data into Staging tables.
3.  **Transformation**: Execute the ETL script to clean and populate the Final tables.
4.  **Analysis**: Run the Analytics Queries script to generate reports.
