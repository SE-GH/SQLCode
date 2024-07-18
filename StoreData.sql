--What are the total number of customers?
SELECT 
	COUNT(Distinct Id) as TotalCustomers
From storedata

--What is the customer distribution by Education?
SELECT 
	Education, 
	COUNT(DISTINCT Id) as TotalCustomers 
FROM 
	storedata
GROUP BY 
	Education
ORDER BY 
	TotalCustomers desc

--What is the customer distribution by the birth year?
SELECT 
	Year_Birth,
	COUNT(Id) AS TotalCustomers
FROM 
    storedata
GROUP BY 
    Year_Birth
ORDER BY 
   Year_Birth

--Find the age distribution of the customers and use age ranges to best present this information. (As we don't have the exact birth date of the customers, we can only provide an estimation of the ages. The dataset was created in 2014.)
SELECT 
    Age_Range,
    COUNT(DISTINCT Id) AS TotalCustomers
FROM (
    SELECT 
        Id,
        CASE    
			WHEN (2014 - Year_Birth) BETWEEN 10 AND 19 THEN '19 or Under'
            WHEN (2014 - Year_Birth) BETWEEN 20 AND 29 THEN '20-29'
            WHEN (2014 - Year_Birth) BETWEEN 30 AND 39 THEN '30-39'
            WHEN (2014 - Year_Birth) BETWEEN 40 AND 49 THEN '40-49'
            WHEN (2014 - Year_Birth) BETWEEN 50 AND 59 THEN '50-59'
            WHEN (2014 - Year_Birth) BETWEEN 60 AND 69 THEN '60-69'
            WHEN (2014 - Year_Birth) BETWEEN 70 AND 79 THEN '70-79'
            ELSE 'None'
        END AS Age_Range
    FROM 
        storedata
) AS Age_Ranges
GROUP BY 
    Age_Range
ORDER BY 
    Age_Range asc;

--Number of customers that live with a partner or and without a partner. (We need to group the married and together columns together and the same for the single, divorced and widows)
SELECT 
    (SELECT COUNT(*) FROM storedata WHERE Marital_Status IN ('Married', 'Together')) AS WithPartner,
    (SELECT COUNT(*) FROM storedata WHERE Marital_Status IN ('Single', 'Divorced', 'Widow')) AS WithoutPartner;

--If customers live with a partner, find the percentage of customers that have a child
SELECT 
	(SUM(CASE WHEN Marital_Status IN ('Married', 'Together') THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(*), 0) AS CustomerswithChildren
FROM 
    storedata
WHERE
    Kidhome > 0 OR Teenhome > 0;

--What is the average income for each category in Education? 
SELECT 
	Education, 
	ROUND(AVG(Income),0) as AverageIncome 
FROM 
	storedata
GROUP BY 
	Education
ORDER BY 
	AverageIncome desc

--Product Analysis

--Revenue of each product category
SELECT 
	SUM(MntWines) as Wine, 
	SUM(MntFishProducts) as Fish, 
	SUM(MntMeatProducts) as Meat, 
	SUM(MntFruits) as Fruits, 
	SUM(MntSweetProducts) as Sweets, 
	SUM(MntGoldProds) as GoldProducts
FROM storedata

--Total spent by each marital category
SELECT
    [Marital_Status],
    SUM([MntWines] + [MntFruits] + [MntMeatProducts] + [MntFishProducts] + [MntSweetProducts]) AS TotalSpent
FROM 
    storedata
GROUP BY
    Marital_Status
Order by TotalSpent desc

--Total spent on each product category
SELECT 
    ROUND(AVG(MntWines), 2) AS AvgWineSpending,
    ROUND(AVG(MntFishProducts), 2) AS AvgFishSpending,
    ROUND(AVG(MntMeatProducts), 2) AS AvgMeatSpending,
    ROUND(AVG(MntFruits), 2) AS AvgFruitSpending,
    ROUND(AVG(MntSweetProducts), 2) AS AvgSweetSpending,
    ROUND(AVG(MntGoldProds), 2) AS AvgGoldSpending
FROM 
    storedata;

--What is the distribution of purchases by store, web and catalog?
SELECT 
	SUM(NumStorePurchases) as Store,
	SUM(NumWebPurchases) as Web,
	SUM(NumCatalogPurchases) as [Catalog]
FROM storedata

--What is the average number of purchases by store, web and catalog?
SELECT 
    ROUND(AVG(NumStorePurchases), 2) AS AvgStorePurchases,
    ROUND(AVG(NumWebPurchases), 2) AS AvgWebPurchases,
    ROUND(AVG(NumCatalogPurchases), 2) AS AvgCatalogPurchases
FROM 
    storedata;

--What is the total number of customers who signed up for the GoldMembership last year
SELECT 
	COUNT(Id) as GoldMembership
FROM 
	storedata
WHERE 
	Response = 1 

--What is the distribution of marital status in the customers that have a gold membership?
WITH store_CTE AS (
	SELECT * 
	FROM storedata
	WHERE Response = 1 
)
SELECT Education, COUNT(Id) as NoofCustomers
FROM store_CTE
GROUP BY Education
ORDER BY NoofCustomers desc


--What is the distribution of recency each customers has last purchased from the store?
SELECT 
    Recency,
    COUNT(*) AS NumCustomers
FROM 
    storedata
GROUP BY 
    Recency
ORDER BY 
    Recency;

--Other queries

--Find all customer records who have a PhD or Masters
SELECT *
FROM 
	storedata
WHERE 
	Education IN ('PhD','Master')

--Find all customers who have an Id number beginning with 45 and are born between 1960 and 1990
SELECT * 
FROM 
	storedata
WHERE 
	Id like '45%' 
	AND Year_Birth BETWEEN 1960 and 1990









