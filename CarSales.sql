
--Find out the total number of dealers
SELECT 
	COUNT(DISTINCT dealer_name) as Total
FROM  
	CarSalesData

--What are the number of cars sold by each dealer?
SELECT Dealer_Name, 
	COUNT(car_id) as TotalCarsSold
FROM  
	CarSalesData
GROUP BY 
	Dealer_Name

--Find out the top 10 companies which have the most cars sold 
SELECT 
	TOP (10) Company, 
	COUNT(Car_id) as Total
From 
	CarSalesData
GROUP BY 
	Company
ORDER BY 
	Total desc

--What are the top selling car models and which company does it belong to?
SELECT 
	Model, 
	Company, 
	COUNT(*) AS TotalCarsSold
FROM 
	CarSalesData
GROUP BY 
	Model, Company
ORDER BY 
	TotalCarsSold DESC;

--Following from the above query, what is the total count of popular models by each company?
SELECT 
    Company,
    COUNT(DISTINCT Model) AS PopularModelsCount
FROM 
    CarSalesData
GROUP BY 
    Company
ORDER BY 
    PopularModelsCount DESC;

--Find out how many cars have been sold in each color category? 
SELECT 
	DISTINCT Color, 
	COUNT(car_id)as TotalCarsSold
FROM 
	CarSalesData
GROUP BY
	Color 
ORDER BY  
	TotalCarsSold desc;

--What's the average income of customers by company?
SELECT 
	Company, 
	Avg([Annual Income]) as AvgSalary
FROM  
	carSalesData
GROUP BY 
	Company
ORDER BY 
	AvgSalary

--What is the total sales for each dealer region?
SELECT 
	Dealer_Region, 
	COUNT(*) AS TotalCarsSold
FROM 
	CarSalesData
GROUP BY 
	Dealer_Region
ORDER BY 
	TotalCarsSold DESC;

--List the number of cars sold by each month of the year
SELECT 
	DATENAME(MONTH, PurchaseDate) AS Sales_Month, 
	COUNT(Car_id) AS TotalCars
FROM 
	CarSalesData
GROUP BY 
	DATENAME(MONTH, PurchaseDate), 
	MONTH(PurchaseDate)
ORDER BY 
	MONTH(PurchaseDate);

--What is the gender distribution of cars sold in percentages?
SELECT 
    Gender,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CarSalesData) AS Percentage
FROM 
    CarSalesData
GROUP BY 
    Gender;

--How many automatic and manual cars are owned by each gender? Include the tranmission type in the query
SELECT 
    Gender,
    Transmission,
    COUNT(*) AS TotalCarsOwned
FROM 
    CarSalesData
GROUP BY 
    Gender,
    Transmission
ORDER BY 
    Gender,
    Transmission;

--What is the total revenue brought in by each dealer? 
SELECT 
	Dealer_Name, 
	SUM([Price ($)]) TotalRevenue
FROM
	CarSalesData
GROUP BY 
	Dealer_Name

--Wat are the top 15 best performing companies by revenue?
SELECT TOP (15)
	Company, 
	SUM([Price ($)]) TotalRevenue
FROM
	CarSalesData
GROUP BY 
	Company
ORDER BY 
	TotalRevenue desc

--What is the average price of each car by company? 
SELECT 
	Company, 
	AVG([Price ($)]) AveragePrice
FROM 
	CarSalesData
GROUP BY 
	Company
ORDER BY 
	AveragePrice

--What is the average price of the cars sold?
SELECT
	AVG([Price ($)]) AvgPrice
FROM 
	
--Total number of cars sold within each price range
WITH PriceBrackets AS (
    SELECT 
        CASE 
            WHEN [Price ($)] BETWEEN 0 AND 9999 THEN '0-9999'
            WHEN [Price ($)] BETWEEN 10000 AND 19999 THEN '10000-19999'
            WHEN [Price ($)] BETWEEN 20000 AND 29999 THEN '20000-29999'
            WHEN [Price ($)] BETWEEN 30000 AND 39999 THEN '30000-39999'
            WHEN [Price ($)] BETWEEN 40000 AND 49999 THEN '40000-49999'
            WHEN [Price ($)] BETWEEN 50000 AND 59999 THEN '50000-59999'
            WHEN [Price ($)] BETWEEN 60000 AND 69999 THEN '60000-69999'
            WHEN [Price ($)] BETWEEN 70000 AND 79999 THEN '70000-79999'
            WHEN [Price ($)] BETWEEN 80000 AND 89999 THEN '80000-89999'
            WHEN [Price ($)] BETWEEN 90000 AND 99999 THEN '90000-99999'
            ELSE '100000 and above'
        END AS PriceBracket
    FROM 
        CarSalesData
)
SELECT 
    PriceBracket,
    COUNT(*) AS TotalCarsSold
FROM 
    PriceBrackets
GROUP BY 
    PriceBracket
ORDER BY 
    PriceBracket;

