-- =============================================================================
-- Script: 01_create_database.sql
-- Description: Creates the ecommerce_analytics database and selects it for use.
-- Author: Data Engineer
-- =============================================================================

-- 1. Drop the database if it already exists to ensure a fresh start (Optional - use with caution)
-- DROP DATABASE IF EXISTS ecommerce_analytics;

-- 2. Create the Database
CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

-- 3. Use the Database
USE ecommerce_analytics;

-- Output confirmation
SELECT 'Database creation passed successfully' AS Status;
