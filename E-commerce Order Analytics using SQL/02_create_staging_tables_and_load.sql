-- =============================================================================
-- Script: 02_create_staging_tables_and_load.sql
-- Description: Creates staging tables and loads raw data.
-- STAGING TABLES: stg_list_of_orders, stg_order_details, stg_sales_target
-- Note: All columns are VARCHAR/TEXT to handle raw data safely before cleaning.
-- =============================================================================

USE ecommerce_analytics;

-- -----------------------------------------------------------------------------
-- 1. Create Staging Table: stg_list_of_orders
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_list_of_orders;
CREATE TABLE stg_list_of_orders (
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),
    CustomerName VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- 2. Create Staging Table: stg_order_details
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_order_details;
CREATE TABLE stg_order_details (
    Order_ID VARCHAR(50),
    Amount VARCHAR(50),
    Profit VARCHAR(50),
    Quantity VARCHAR(50),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- 3. Create Staging Table: stg_sales_target
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS stg_sales_target;
CREATE TABLE stg_sales_target (
    Month_of_Order_Date VARCHAR(50),
    Category VARCHAR(100),
    Target VARCHAR(50)
);

-- =============================================================================
-- DATA LOADING SECTION
-- =============================================================================

-- Loading stg_list_of_orders (Sample - Full data load would be here)
-- Note: Due to file size limits, I am generating the first 50 rows as a demo. 
-- In a real scenario, you would insert all rows or use LOAD DATA INFILE.
INSERT INTO stg_list_of_orders (Order_ID, Order_Date, CustomerName, State, City) VALUES
('B-25601','01-04-2018','Bharat','Gujarat','Ahmedabad'),
('B-25602','01-04-2018','Pearl','Maharashtra','Pune'),
('B-25603','03-04-2018','Jahan','Madhya Pradesh','Bhopal'),
('B-25604','03-04-2018','Divsha','Rajasthan','Jaipur'),
('B-25605','05-04-2018','Kasheen','West Bengal','Kolkata'),
('B-25606','06-04-2018','Hazel','Karnataka','Bangalore'),
('B-25607','06-04-2018','Sonakshi','Jammu and Kashmir','Kashmir'),
('B-25608','08-04-2018','Aarushi','Tamil Nadu','Chennai'),
('B-25609','09-04-2018','Jitesh','Uttar Pradesh','Lucknow'),
('B-25610','09-04-2018','Yogesh','Bihar','Patna'),
('B-25611','11-04-2018','Anita','Kerala ','Thiruvananthapuram'),
('B-25612','12-04-2018','Shrichand','Punjab','Chandigarh'),
('B-25613','12-04-2018','Mukesh','Haryana','Chandigarh'),
('B-25614','13-04-2018','Vandana','Himachal Pradesh','Simla'),
('B-25615','15-04-2018','Bhavna','Sikkim','Gangtok'),
('B-25616','15-04-2018','Kanak','Goa','Goa'),
('B-25617','17-04-2018','Sagar','Nagaland','Kohima'),
('B-25618','18-04-2018','Manju','Andhra Pradesh','Hyderabad'),
('B-25619','18-04-2018','Ramesh','Gujarat','Ahmedabad'),
('B-25620','20-04-2018','Sarita','Maharashtra','Pune'),
('B-25621','20-04-2018','Deepak','Madhya Pradesh','Bhopal'),
('B-25622','22-04-2018','Monisha','Rajasthan','Jaipur'),
('B-25623','22-04-2018','Atharv','West Bengal','Kolkata'),
('B-25624','22-04-2018','Vini','Karnataka','Bangalore'),
('B-25625','23-04-2018','Pinky','Jammu and Kashmir','Kashmir'),
('B-25626','23-04-2018','Bhishm','Maharashtra','Mumbai'),
('B-25627','23-04-2018','Hitika','Madhya Pradesh','Indore'),
('B-25628','24-04-2018','Pooja','Bihar','Patna'),
('B-25629','24-04-2018','Hemant','Kerala ','Thiruvananthapuram'),
('B-25630','24-04-2018','Sahil','Punjab','Chandigarh'),
('B-25631','24-04-2018','Ritu','Haryana','Chandigarh'),
('B-25632','25-04-2018','Manish','Himachal Pradesh','Simla'),
('B-25633','26-04-2018','Amit','Sikkim','Gangtok'),
('B-25634','26-04-2018','Sanjay','Goa','Goa'),
('B-25635','26-04-2018','Nidhi','Nagaland','Kohima'),
('B-25636','26-04-2018','Nishi','Maharashtra','Mumbai'),
('B-25637','26-04-2018','Ashmi','Madhya Pradesh','Indore'),
('B-25638','26-04-2018','Parth','Maharashtra','Pune'),
('B-25639','27-04-2018','Lisha','Madhya Pradesh','Bhopal'),
('B-25640','27-04-2018','Paridhi','Rajasthan','Jaipur'),
('B-25641','27-04-2018','Parishi','West Bengal','Kolkata'),
('B-25642','28-04-2018','Ajay','Karnataka','Bangalore'),
('B-25643','29-04-2018','Kirti','Jammu and Kashmir','Kashmir'),
('B-25644','30-04-2018','Mayank','Maharashtra','Mumbai'),
('B-25645','01-05-2018','Yaanvi','Madhya Pradesh','Indore'),
('B-25646','01-05-2018','Sonal','Bihar','Patna'),
('B-25647','03-05-2018','Sharda','Kerala ','Thiruvananthapuram'),
('B-25648','04-05-2018','Aditya','Punjab','Chandigarh'),
('B-25649','05-05-2018','Rachna','Haryana','Chandigarh'),
('B-25650','06-05-2018','Chirag','Maharashtra','Mumbai');
-- ... [User should load full data here if not using complete inserts] ...


-- Loading stg_order_details (Sample)
INSERT INTO stg_order_details (Order_ID, Amount, Profit, Quantity, Category, Sub_Category) VALUES
('B-25601','1275.00','-1148.00','7','Furniture','Bookcases'),
('B-25601','66.00','-12.00','5','Clothing','Stole'),
('B-25601','8.00','-2.00','3','Clothing','Hankerchief'),
('B-25601','80.00','-56.00','4','Electronics','Electronic Games'),
('B-25602','168.00','-111.00','2','Electronics','Phones'),
('B-25602','424.00','-272.00','5','Electronics','Phones'),
('B-25602','2617.00','1151.00','4','Electronics','Phones'),
('B-25602','561.00','212.00','3','Clothing','Saree'),
('B-25602','119.00','-5.00','8','Clothing','Saree'),
('B-25603','1355.00','-60.00','5','Clothing','Trousers'),
('B-25603','24.00','-30.00','1','Furniture','Chairs'),
('B-25603','193.00','-166.00','3','Clothing','Saree'),
('B-25603','180.00','5.00','3','Clothing','Trousers'),
('B-25603','116.00','16.00','4','Clothing','Stole'),
('B-25603','107.00','36.00','6','Clothing','Stole'),
('B-25603','12.00','1.00','2','Clothing','Hankerchief'),
('B-25603','38.00','18.00','1','Clothing','Kurti'),
('B-25604','65.00','17.00','2','Clothing','T-shirt'),
('B-25604','157.00','5.00','9','Clothing','Saree'),
('B-25605','75.00','0.00','7','Clothing','Saree');


-- Loading stg_sales_target (Sample)
INSERT INTO stg_sales_target (Month_of_Order_Date, Category, Target) VALUES
('Apr-18','Furniture','10400.00'),
('May-18','Furniture','10500.00'),
('Jun-18','Furniture','10600.00'),
('Jul-18','Furniture','10800.00'),
('Aug-18','Furniture','10900.00'),
('Sep-18','Furniture','11000.00'),
('Oct-18','Furniture','11100.00'),
('Nov-18','Furniture','11300.00'),
('Dec-18','Furniture','11400.00'),
('Jan-19','Furniture','11500.00'),
('Feb-19','Furniture','11600.00'),
('Mar-19','Furniture','11800.00'),
('Apr-18','Clothing','12000.00'),
('May-18','Clothing','12000.00'),
('Jun-18','Clothing','12000.00'),
('Jul-18','Clothing','14000.00'),
('Aug-18','Clothing','14000.00'),
('Sep-18','Clothing','14000.00'),
('Oct-18','Clothing','16000.00'),
('Nov-18','Clothing','16000.00'),
('Dec-18','Clothing','16000.00'),
('Jan-19','Clothing','16000.00'),
('Feb-19','Clothing','16000.00'),
('Mar-19','Clothing','16000.00'),
('Apr-18','Electronics','9000.00'),
('May-18','Electronics','9000.00'),
('Jun-18','Electronics','9000.00'),
('Jul-18','Electronics','9000.00'),
('Aug-18','Electronics','9000.00'),
('Sep-18','Electronics','9000.00'),
('Oct-18','Electronics','9000.00'),
('Nov-18','Electronics','9000.00'),
('Dec-18','Electronics','9000.00'),
('Jan-19','Electronics','16000.00'),
('Feb-19','Electronics','16000.00'),
('Mar-19','Electronics','16000.00');

SELECT 'Staging tables created and sample data loaded' AS Status;
