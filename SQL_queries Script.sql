-- Project: BlinkIT Grocery Data - SQL Cleaning & Analysis
-- Database: MYSQL

/* Basic Checks */
select * from blinkit;

-- DATA CLEANING
/* 1. Altering Table Contents */

ALTER TABLE blinkit 
CHANGE COLUMN `ï»¿Item Fat Content` item_fat_content VARCHAR(50),
CHANGE COLUMN `Item Identifier` item_identifier VARCHAR(50),
CHANGE COLUMN `Item Type` item_type VARCHAR(50),
CHANGE COLUMN `Outlet Establishment Year` outlet_establishment_year INT,
CHANGE COLUMN `Outlet Identifier` outlet_identifier VARCHAR(50),
CHANGE COLUMN `Outlet Location Type` outlet_location_type VARCHAR(50),
CHANGE COLUMN `Outlet Size` outlet_size VARCHAR(50),
CHANGE COLUMN `Outlet Type` outlet_type VARCHAR(50),
CHANGE COLUMN `Item Visibility` item_visibility FLOAT,
CHANGE COLUMN `Item Weight` item_weight FLOAT,
CHANGE COLUMN `Total Sales` total_sales FLOAT,
CHANGE COLUMN `Rating` rating FLOAT;

/* 2. Cleaning item_fat_content */

UPDATE blinkit
SET item_fat_content =
    CASE 
        WHEN item_fat_content IN ('LF', 'low fat', 'lowfat') THEN 'Low Fat'
        WHEN item_fat_content = 'reg' THEN 'Regular'
        ELSE item_fat_content
    END;
    
/* 3. Handle Null or Missing Total_Sales and Item_Weight */

-- Set blank/empty Total_Sales to NULL (if imported as empty string)
UPDATE blinkit_data
SET Total_Sales = NULL
WHERE TRIM(Total_Sales) = '';

-- Optionally, set zero or negative sales to NULL
UPDATE blinkit_data
SET Total_Sales = NULL
WHERE Total_Sales <= 0;

-- Handle missing Item_Weight
UPDATE blinkit_data
SET Item_Weight = NULL
WHERE TRIM(Item_Weight) = '';

-- ANALYZING DATA 
-- 1. Total Sales by Fat Content
SELECT Item_Fat_Content, ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content;

-- 2. Average sales
SELECT ROUND(AVG(Total_Sales), 2) AS Avg_Total_Sales
FROM blinkit_data;

-- 3. No. of items
SELECT COUNT(*) AS Number_of_Items
FROM blinkit_data;

-- 4. Average rating
SELECT ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_data;

-- 4. Total Sales by Item Type
SELECT Item_Type, ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 5. Total Sales by Outlet Establishment Year
SELECT Outlet_Establishment_Year, ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- 6. Percentage of Sales by Outlet Size
SELECT outlet_size,
	CAST(sum(total_sales) AS decimal (10,2)) AS total_sales,
    CAST((sum(total_sales)*100.0 / sum(sum(total_sales)) over()) AS decimal(10,2)) AS precentage_sales
FROM blinkit
GROUP BY outlet_size
ORDER BY total_sales DESC;

-- 7. Sales by Outlet Location
SELECT Outlet_Location_Type, ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- 8. Metrics by Outlet Type
SELECT Outlet_Type,
       ROUND(SUM(Total_Sales), 2) AS Total_Sales,
       ROUND(AVG(Total_Sales), 2) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       ROUND(AVG(Rating), 2) AS Avg_Rating,
       ROUND(AVG(Item_Visibility), 2) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

-- 9. Total Sales by Fat Content for each Outlet Location
SELECT 
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END), 2) AS Low_Fat_Sales,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales ELSE 0 END), 2) AS Regular_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- ADDITIONAL QUERIES OR ALTERNATIVE QUERIES

-- Try using concat functions 
SELECT concat(cast(sum(total_sales)/1000000 AS decimal (10,2)) ,'Millions') AS total_sales
FROM blinkit_data; 

-- ALTERNATIVE TO ROUND FUNCTION 
SELECT cast(sum(total_sales)/1000000 AS decimal (10,2)) AS total_sales
from blinkit_data; 
-- use cast function to control the number of decimal places. 









