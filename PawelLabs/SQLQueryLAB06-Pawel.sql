USE AdventureWorksLT2012
--LAB06

--Adventure Works products each have a standard cost price that indicates the cost of manufacturing the product, 
--and a list price that indicates the recommended selling price for the product. This data is stored in the SalesLT.
--Product table. Whenever a product is ordered, the actual unit price at which it was sold is also recorded in the SalesLT.SalesOrderDetail table. 
--You must use subqueries to compare the cost and list prices for each product with the unit prices charged in each sale. 
--Tip: Review the documentation for subqueries in Subquery Fundamentals.

--Challenge1 Task1
--Retrieve the product ID, name, and list price for each product where the list price is higher than the average unit price for all products that have been sold.
SELECT p.ProductID, p.Name, p.ListPrice
FROM SalesLT.Product AS p
WHERE p.ListPrice >
	(SELECT AVG(o.UnitPrice) FROM SalesLT.SalesOrderDetail AS o);
	-- 137 rows and AVG is 382.87

--Challenge1 Task2
--Retrieve the product ID, name, and list price for each product where the list price is $100 or more, and the product has been sold for less than $100.
SELECT p.ProductID, p.Name, p.ListPrice
FROM SalesLT.Product AS p
WHERE p.ListPrice > 100
AND p.ProductID IN
	(SELECT o.ProductID FROM SalesLT.SalesOrderDetail AS o
	WHERE o.UnitPrice < 100);
	-- 7 rows

--Challenge1 Task3
--Retrieve the product ID, name, cost, and list price for each product along with the average unit price for which that product has been sold.
SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
	(SELECT AVG(o.UnitPrice) 
	FROM SalesLT.SalesOrderDetail AS o
	WHERE o.ProductID = p.ProductID) AS AverageUnitPrice
FROM SalesLT.Product AS p;
-- 295 rows

--Challenge1 Task4
--Filter your previous query to include only products where the cost price is higher than the average selling price.
SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
	(SELECT AVG(o.UnitPrice) 
	FROM SalesLT.SalesOrderDetail AS o
	WHERE o.ProductID = p.ProductID) AS AverageUnitPrice
FROM SalesLT.Product AS p
WHERE p.StandardCost >
	(SELECT AVG(o.UnitPrice) FROM SalesLT.SalesOrderDetail AS o
	WHERE o.ProductID = p.ProductID);
	-- 60 rows

--The AdventureWorksLT database includes a table-valued user-defined function named dbo.ufnGetCustomerInformation. 
--You must use this function to retrieve details of customers based on customer ID values retrieved from tables in the database. 
--Tip: Review the documentation for the APPLY operator in Using APPLY.


--Challenge2 Task1
--Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders from the SalesLT.SalesOrderHeader table and the dbo.ufnGetCustomerInformation function.
SELECT s.SalesOrderID, s.CustomerID, c.FirstName, c.LastName, s.TotalDue
FROM SalesLT.SalesOrderHeader AS s
CROSS APPLY dbo.ufnGetCustomerInformation(s.CustomerID) AS c;
-- 32 rows

--Challenge2 Task2
--Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the SalesLT.Address and SalesLT.CustomerAddress tables, and the dbo.ufnGetCustomerInformation function.
SELECT c.CustomerID, c.FirstName, c.LastName, a.AddressLine1, a.City
FROM SalesLT.CustomerAddress AS ca
JOIN SalesLT.Address As a
ON a.AddressID = ca.AddressID
OUTER APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS c;
-- 417 rows