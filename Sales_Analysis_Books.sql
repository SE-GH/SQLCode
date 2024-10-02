-- Tables
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(100),
    Author NVARCHAR(100),
    Genre NVARCHAR(50),
    Price DECIMAL(10, 2),
    PublishedDate DATE
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(15)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);


-- 1. Retrieve all columns from the Books table.
SELECT * 
FROM Books

-- 2. List all distinct authors from the Books table.
SELECT 
	Distinct Author
FROM 
	Books

-- 3. Find all books with a price greater than $10.
SELECT 
	Title,
	Price
FROM 
	Books
WHERE 
	Price > 10.00

-- 4. Get all books ordered by the published date in descending order.
SELECT * 
FROM
	Books
ORDER BY 
	PublishedDate DESC

-- 5. Find all books where the genre is 'Fiction' and the price is less than $15.
SELECT * 
FROM
	books
WHERE 
	genre = 'Fiction' AND price < 15.00 

-- 6. Retrieve all books that are either in the 'Dystopian' genre or have a price under $10.
SELECT * 
FROM 
	Books
WHERE	
	Genre = 'Dystopian' OR Price < 10.00 

-- 7. Find all books that are not in the 'Romance' genre.
SELECT * 
FROM	
	Books
WHERE 
	Genre NOT IN ('Romance')

-- 8. Insert a new book into the Books table with the following details: 
--    - BookID: 5
--    - Title: 'Moby Dick'
--    - Author: 'Herman Melville'
--    - Genre: 'Adventure'
--    - Price: 11.99
--    - PublishedDate: '1851-10-18'

INSERT INTO Books 
    (BookID, Title, Author, Genre, Price, PublishedDate) 
VALUES
    (5, 'Moby Dick', 'Herman Melville', 'Adventure', 11.99, '1851-10-18');

-- 9. Retrieve all customers who do not have a phone number listed.
SELECT * 
FROM 
	Customers 
WHERE Phone IS NULL

-- 10. Update the price of '1984' to $15.99 in the Books table.
UPDATE Books
SET Price = 15.99
WHERE Title = '1984' 

-- 11. Delete the customer with the CustomerID of 3 from the Customers table.
DELETE FROM 
	Customers
WHERE 
	CustomerId = 3 

-- 12. Select the top 2 most expensive books from the Books table.
SELECT
	TOP 2 Title, Price 
FROM 
	Books
ORDER BY 
	Price DESC

-- 13. Find the total number of books in the Books table.
SELECT 
	COUNT(BookId) as TotalBooks
FROM 
	Books

-- 14. Determine the minimum and maximum prices of the books in the Books table.
SELECT 
	Min(Price) as MinPrice, 
	Max(Price) as MaxPrice 
FROM 
	Books

-- 15. Count the number of orders placed in the Orders table.
SELECT 
	COUNT(OrderId) as TotalOrders
FROM
	Orders

-- 16. Calculate the total sales from the OrderItems table.
SELECT 
	SUM(oi.quantity*b.price) as TotalSales
FROM 
	OrderItems oi
INNER JOIN 
	Books b
ON 
	oi.bookId = b.bookId 

-- 17. Find the average price of books in the Books table.
SELECT 
	AVG(Price) AS AvgPrice
FROM
	Books

-- 18. Retrieve all books whose titles contain the word 'the'.
SELECT * 
FROM Books
WHERE Title LIKE '%the%'

-- 19. Find all customers whose last name starts with 'S'.
SELECT * 
FROM 
	Customers
WHERE 
	LastName Like 'S%'

-- 20. Get all orders made by customers with IDs 1 or 2.
SELECT c.CustomerID, O.OrderID, o.OrderDate
FROM 
	Orders o 
JOIN 
	Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.customerId IN (1,2) 

-- 21. Find all books published between 1900 and 2000.
SELECT * 
FROM 
    Books
WHERE 
    PublishedDate BETWEEN '1900-01-01' AND '2000-12-31'

-- 22. Retrieve the titles of books and their prices, using aliases for better readability.
SELECT 
	b.title, 
	b.price 
FROM 
	books b 

-- 23. List all books along with the customer names who ordered them.
SELECT 
	b.title,
	c.firstname + ' ' + c.lastname as FullName
FROM 
	Customers c 
JOIN 
	Orders o ON c.customerId = o.customerId
JOIN 
	 OrderItems oi ON o.orderId = oi.orderId 
JOIN 
	 Books b ON oi.bookId = b.bookId 

-- 24. Select all order details for orders that have been made.
SELECT * 
FROM 
	Orders o 
JOIN 
	OrderItems oi ON o.orderId = oi.OrderID
JOIN 
	Books b on oi.bookId = b.bookId

-- 25. Retrieve all customers and any orders they have placed.
SELECT * 
FROM	
	Customers c 
LEFT JOIN 
	Orders o on c.CustomerID = o.CustomerID

-- 26. Get all orders and the corresponding customer details.
SELECT 
	c.customerId,
	c.firstname + ' ' + c.lastname as FullName, 
	c.Email, 
	c.Phone, 
	o.OrderId, 
	o.orderDate
FROM 
	Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID

-- 27. List all customers and orders, ensuring that all records from both tables are included.
SELECT * 
FROM 
    Customers c 
FULL OUTER JOIN 
    Orders o ON c.CustomerID = o.CustomerID;

-- 28. Find the total number of books sold by each book title.
SELECT 
    b.title, 
    COALESCE(SUM(oi.quantity), 0) AS TotalSold
FROM 
    Books b
LEFT JOIN 
    OrderItems oi ON b.BookID = oi.BookID 
GROUP BY 
    b.BookID, 
    b.title;

-- 29. Find customers who have made at least one order.
SELECT 
	c.customerId, 
	c.FirstName + ' ' + c.LastName AS FullName 
FROM 
	Customers c 
LEFT JOIN 
	Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
	c.CustomerID, 
	c.FirstName, 
	c.LastName
HAVING
	COUNT(o.CustomerID) >= 1 
