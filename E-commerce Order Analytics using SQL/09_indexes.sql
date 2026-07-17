-- =============================================================================
-- Script: 09_indexes.sql
-- Description: Add Indexes for Performance Optimization
-- Targets: orders(order_date, customer_id), order_items(order_id), products(category)
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Index on Orders Date
-- Improves filtering by date range and grouping by month/year
-- -----------------------------------------------------------------------------
-- Check if index exists usually requires dynamic SQL in MySQL, 
-- but acceptable to run CREATE INDEX (it might warn if exists or duplicate).
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- -----------------------------------------------------------------------------
-- 2. Index on Orders Customer ID
-- Improves JOIN performance with customers table
-- (Note: MySQL automatically indexes FKs, but explicit indexing can be good practice or for specific sorting)
-- -----------------------------------------------------------------------------
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- -----------------------------------------------------------------------------
-- 3. Index on Order Items Order ID
-- Improves JOIN performance with orders table
-- -----------------------------------------------------------------------------
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- -----------------------------------------------------------------------------
-- 4. Index on Products Category
-- Improves filtering and grouping by category
-- -----------------------------------------------------------------------------
CREATE INDEX idx_products_category ON products(category);

SELECT 'Indexes Created Successfully' AS Status;
