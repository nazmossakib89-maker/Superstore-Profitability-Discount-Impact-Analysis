-- ============================================================
-- Superstore Profitability & Discount Impact Analysis
-- SQL Analysis (MySQL)
-- ============================================================
-- This file recreates the analysis performed in MySQL Workbench:
-- 1. Database and table setup
-- 2. Data import from CSV
-- 3. Queries answering each business question, cross-validated
--    against the Excel PivotTable analysis
-- ============================================================


-- ============================================================
-- SECTION 1: Database and Table Setup
-- ============================================================

CREATE DATABASE IF NOT EXISTS superstore;
USE superstore;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    RowID INT,
    OrderID VARCHAR(20),
    OrderDate DATE,
    ShipDate DATE,
    ShipMode VARCHAR(30),
    CustomerID VARCHAR(20),
    CustomerName VARCHAR(50),
    Segment VARCHAR(30),
    Country VARCHAR(30),
    City VARCHAR(50),
    State VARCHAR(30),
    PostalCode VARCHAR(10),
    Region VARCHAR(20),
    ProductID VARCHAR(30),
    Category VARCHAR(30),
    SubCategory VARCHAR(30),
    ProductName VARCHAR(150),
    Sales DECIMAL(10,4),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,4)
);


-- ============================================================
-- SECTION 2: Data Import
-- ============================================================
-- Note: CSV file must be placed in the MySQL server's secure
-- file-privilege directory (find it via SHOW VARIABLES LIKE
-- 'secure_file_priv';). Dates are converted from the source
-- MM/DD/YYYY format to MySQL's DATE type. CHARACTER SET latin1
-- is used to handle special characters in some product names.

LOAD DATA INFILE 'Sample - Superstore.csv'
INTO TABLE orders
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(RowID, OrderID, @OrderDate, @ShipDate, ShipMode, CustomerID, CustomerName,
 Segment, Country, City, State, PostalCode, Region, ProductID, Category,
 SubCategory, ProductName, Sales, Quantity, Discount, Profit)
SET
    OrderDate = STR_TO_DATE(@OrderDate, '%m/%d/%Y'),
    ShipDate  = STR_TO_DATE(@ShipDate, '%m/%d/%Y');

-- Sanity check: should return 9994
SELECT COUNT(*) FROM orders;


-- ============================================================
-- SECTION 3: Business Question 1
-- Category & Sub-Category Profitability
-- ============================================================

-- Category-level summary
SELECT
    Category,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Category
ORDER BY Profit_Margin_Pct ASC;

-- Sub-category drill-down (reveals losses hidden at category level)
SELECT
    Category,
    SubCategory,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Category, SubCategory
ORDER BY Total_Profit ASC;


-- ============================================================
-- SECTION 4: Business Question 2
-- Region & State Profitability
-- ============================================================

SELECT
    Region,
    State,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Region, State
ORDER BY Total_Profit ASC;


-- ============================================================
-- SECTION 5: Business Question 3
-- Discount Impact on Profitability (the key finding)
-- ============================================================

SELECT
    CASE
        WHEN Discount = 0        THEN 'No Discount'
        WHEN Discount <= 0.20    THEN 'Low (1-20%)'
        WHEN Discount <= 0.40    THEN 'Medium (21-40%)'
        WHEN Discount <= 0.60    THEN 'High (41-60%)'
        ELSE 'Very High (60%+)'
    END AS Discount_Bucket,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Discount_Bucket
ORDER BY Profit_Margin_Pct DESC;


-- ============================================================
-- SECTION 6: Business Question 4
-- Customer Segment Profitability
-- ============================================================

SELECT
    Segment,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Segment
ORDER BY Profit_Margin_Pct DESC;


-- ============================================================
-- SECTION 7: Business Question 5
-- Ship Mode Profitability
-- ============================================================

SELECT
    ShipMode,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY ShipMode
ORDER BY Profit_Margin_Pct DESC;


-- ============================================================
-- SECTION 8: Business Question 6
-- Top 10 Loss-Making Products
-- ============================================================

SELECT
    ProductName,
    Category,
    COUNT(*) AS Times_Ordered,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders
GROUP BY ProductName, Category
ORDER BY Total_Profit ASC
LIMIT 10;