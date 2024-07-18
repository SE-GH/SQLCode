
-- Total Revenue
SELECT 
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales;

-- Total Number of Pizzas Baked
SELECT 
    SUM(quantity) AS Total_Pizzas_Baked
FROM 
	pizza_sales;

-- Total Number of Orders
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM 
	pizza_sales;

-- Total Number of Orders and Revenue by Month
SELECT 
    DATENAME(month, order_date) AS Month,
    COUNT(DISTINCT order_id) AS Number_of_Orders,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM 
	pizza_sales
GROUP BY 
	DATENAME(month, order_date), MONTH(order_date)
ORDER BY 
	MONTH(order_date);

-- Revenue Percentage by Pizza Size
SELECT 
    pizza_size,
    ROUND(SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales) * 100, 2) AS Revenue_Percentage
FROM 
	pizza_sales
GROUP BY 
	pizza_size
ORDER BY 
	Revenue_Percentage DESC;

-- Top 10 Most Ordered Pizzas
SELECT 
    TOP 10 pizza_name, 
    COUNT(pizza_id) AS No_of_Pizzas_Sold
FROM 
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY 
	No_of_Pizzas_Sold DESC;

-- Top 10 Least Ordered Pizzas
SELECT TOP 10 
    pizza_name, 
    COUNT(pizza_id) AS No_of_Pizzas_Sold
FROM 
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY 
	No_of_Pizzas_Sold ASC;

-- Total Pizzas Ordered by Pizza Size
SELECT 
    pizza_size, 
    COUNT(pizza_id) AS Total_Pizzas
FROM 
	pizza_sales
GROUP BY 
	pizza_size;

-- Total Revenue by Each Weekday
SELECT 
    DATENAME(WEEKDAY, order_date) AS Day_of_Week,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date),
         DATEPART(WEEKDAY, order_date)
ORDER BY DATEPART(WEEKDAY, order_date);

-- Average Number of Pizzas Ordered per Order ID
SELECT 
    AVG(Number_of_Pizzas) AS Average_Pizzas_Per_Order
FROM (
    SELECT 
        order_id, 
        SUM(quantity) AS Number_of_Pizzas
    FROM pizza_sales
    GROUP BY order_id
) AS OrderSummary;

-- Revenue Contribution by Each Pizza Category
SELECT 
    pizza_category,
    ROUND(SUM(total_price), 2) AS Total_Revenue,
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS Revenue_Percentage
FROM 
	pizza_sales
GROUP BY 
	pizza_category
ORDER BY 
	Total_Revenue DESC;

-- Peak Order Hours 
SELECT 
    DATEPART(hour, order_time) AS Hour,
    COUNT(order_id) AS Number_of_Orders
FROM 
	pizza_sales
GROUP BY 
	DATEPART(hour, order_time)
ORDER BY 
	Number_of_Orders DESC;

-- Total Revenue for Each Quarter of the Year
SELECT 
    DATEPART(YEAR, order_date) AS Year,
    CASE 
        WHEN DATEPART(QUARTER, order_date) = 1 THEN 'Q1'
        WHEN DATEPART(QUARTER, order_date) = 2 THEN 'Q2'
        WHEN DATEPART(QUARTER, order_date) = 3 THEN 'Q3'
        WHEN DATEPART(QUARTER, order_date) = 4 THEN 'Q4'
    END AS Quarter,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM
	pizza_sales
GROUP BY 
	DATEPART(YEAR, order_date), DATEPART(QUARTER, order_date)
ORDER BY 
	Year, Quarter;

