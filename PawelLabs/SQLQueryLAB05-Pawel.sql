USE AdventureWorksLT2012
--LAB05

--Your reports are returning the correct records, but you would like to modify how these records are displayed. 
--Tip: Review the documentation for Built-In Functions in the Transact-SQL Reference.

--Challenge1 Task1
--Write a query to return the product ID of each product, together with the product name formatted as upper case and 
--a column named ApproxWeight with the weight of each product rounded to the nearest whole unit.
SELECT p.ProductID, UPPER(p.Name) AS ProductName, ROUND(p.Weight, 0) AS ApproxWeight
FROM SalesLT.Product AS p;

--Challenge1 Task2
--Extend your query to include columns named SellStartYear and SellStartMonth containing the year and month in which 
--Adventure Works started selling each product. The month should be displayed as the month name (for example, ‘January’).
SELECT p.ProductID, 
	UPPER(p.Name) AS ProductName, 
	ROUND(p.Weight, 0) AS ApproxWeight, 
	YEAR(p.SellStartDate) AS SellStartYear, 
	DATENAME(mm, p.SellStartDate) AS SellStartMonth
FROM SalesLT.Product AS p;
-- 295 rows

--Challenge1 Task3
--Extend your query to include a column named ProductType that contains the leftmost two characters from the product number.
SELECT p.ProductID, 
	UPPER(p.Name) AS ProductName, 
	ROUND(p.Weight, 0) AS ApproxWeight, 
	YEAR(p.SellStartDate) AS SellStartYear, 
	DATENAME(mm, p.SellStartDate) AS SellStartMonth,
	LEFT(p.ProductNumber, 2) AS ProductType
FROM SalesLT.Product AS p;
-- 295 rows

--Challenge1 Task4
--Extend your query to filter the product returned so that only products with a numeric size are included.
SELECT p.ProductID, 
	UPPER(p.Name) AS ProductName, 
	ROUND(p.Weight, 0) AS ApproxWeight, 
	YEAR(p.SellStartDate) AS SellStartYear, 
	DATENAME(mm, p.SellStartDate) AS SellStartMonth,
	LEFT(p.ProductNumber, 2) AS ProductType
FROM SalesLT.Product AS p
WHERE ISNUMERIC(Size) = 1; -- 1=true 0=false
-- 177 rows

--Challenge2 Task1
--Write a query that returns a list of company names with a ranking of their place in a list of highest
--TotalDue values from the SalesOrderHeader table.
SELECT c.CompanyName, o.TotalDue,
	RANK()OVER(ORDER BY o.TotalDue DESC) AS Ranking
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS o
ON c.CustomerID = o.CustomerID
WHERE ISNUMERIC(o.TotalDue) = 1;
-- 32 rows

--Challenge3 Task1
--Write a query to retrieve a list of the product names and the total revenue calculated as the sum of the
--LineTotal from the SalesLT.SalesOrderDetail table, with the results sorted in descending order of total revenue.
SELECT p.Name AS ProductName, SUM(o.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS o
LEFT OUTER JOIN SalesLT.Product AS p
ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.LineTotal) DESC;
-- 142 rows

--Challenge3 Task2
--Modify the previous query to include sales totals for products that have a list price of more than $1000.
SELECT p.Name AS ProductName, SUM(o.LineTotal) AS TotalRevenue, SUM(p.ListPrice) AS SalesTotal
FROM SalesLT.SalesOrderDetail AS o
LEFT OUTER JOIN SalesLT.Product AS p
ON p.ProductID = o.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name
ORDER BY SUM(o.LineTotal) DESC;

--Challenge3 Task3
--Modify the previous query to only include only product groups with a total sales value greater than $20,000.
SELECT p.Name AS ProductName, SUM(o.LineTotal) AS TotalRevenue, SUM(p.ListPrice) AS SalesTotal
FROM SalesLT.SalesOrderDetail AS o
FULL OUTER JOIN SalesLT.Product AS p
ON p.ProductID = o.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name
HAVING SUM(o.LineTotal) > 20000
ORDER BY SUM(o.LineTotal) DESC;