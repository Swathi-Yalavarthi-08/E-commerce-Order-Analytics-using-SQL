-- =============================================================================
-- Script: 03_create_final_tables.sql
-- Description: Creates the final normalized tables for the E-commerce project.
-- Schema: Normalized into Customers, Orders, Products, Order Items, and Targets.
-- Constraints: Primary Keys, Foreign Keys, AUTO_INCREMENT, and NOT NULLs.
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Table: customers
-- Description: Stores unique customer information and location.
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    state VARCHAR(255),
    city VARCHAR(255),
    -- Constraint to avoid duplicate customers in the same location (Optional but recommended)
    UNIQUE KEY unique_customer (customer_name, state, city)
);

-- -----------------------------------------------------------------------------
-- 2. Table: products
-- Description: Stores unique product categories and sub-categories.
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(255) NOT NULL,
    sub_category VARCHAR(255) NOT NULL,
    UNIQUE KEY unique_product (category, sub_category)
);

-- -----------------------------------------------------------------------------
-- 3. Table: orders
-- Description: Stores order header information linked to customers.
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY, -- Using VARCHAR as Order IDs are alphanumeric (e.g., B-25601)
    order_date DATE NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- 4. Table: order_items
-- Description: Stores line-item details for each order, linked to products.
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    profit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- 5. Table: sales_targets
-- Description: Stores monthly sales targets by category.
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS sales_targets;
CREATE TABLE sales_targets (
    target_id INT AUTO_INCREMENT PRIMARY KEY,
    target_month DATE NOT NULL,
    category VARCHAR(255) NOT NULL,
    target_amount DECIMAL(10, 2) NOT NULL
);

SELECT 'Final normalized tables created successfully' AS Status;
