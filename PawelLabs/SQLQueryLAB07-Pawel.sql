USE AdventureWorksLT2012
--LAB07

--Adventure Works sells many products that are variants of the same product model. 
--You must write queries that retrieve information about these products

--Challenge1 Task1
--Retrieve the product ID, product name, product model name, and product model summary for each product
--from the SalesLT.Product table and the SalesLT.vProductModelCatalogDescription view.
SELECT p.ProductID, p.Name, pm.Name, pm.Summary
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.vProductModelCatalogDescription AS pm
ON pm.ProductModelID = p.ProductModelID;
-- 295 rows

--Challenge1 Task2
--Create a table variable and populate it with a list of distinct colors from the SalesLT.Product table. 
--Then use the table variable to filter a query that returns the product ID, name, and color from the SalesLT.Product table
--so that only products with a color listed in the table variable are returned.
--Tip: Review the documentation for Variables in Transact-SQL Language Reference.
			--CREATE TABLE #temporaryTableColors (Color nvarchar(50))
			--INSERT INTO #temporarytableColors
			--SELECT DISTINCT Color FROM SalesLT.Product  

			--select * from #temporaryTableColors  -- still in scope

DECLARE @tableVariableColors AS TABLE (Colors nvarchar(50))
INSERT INTO @tableVariableColors
SELECT DISTINCT Color FROM SalesLT.Product
SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN(SELECT * FROM @tableVariableColors);
-- 245 rows
			--select * from @tableVariableColors -- out of scope, it has to run together DECLARE>INSERT>SELECT

--Challenge1 Task3
--The AdventureWorksLT database includes a table-valued function named dbo.ufnGetAllCategories, 
--which returns a table of product categories (for example ‘Road Bikes’) and parent categories (for example ‘Bikes’). 
--Write a query that uses this function to return a list of all products including their parent category and category.
SELECT p.Name, p.ProductNumber, c.ProductCategoryName, c.ParentProductCategoryName 
FROM SalesLT.Product AS p
LEFT JOIN dbo.ufnGetAllCategories() as c
ON c.ProductCategoryID = p.ProductCategoryID;
-- 295 rows

--Each Adventure Works customer is a retail company with a named contact. You must create queries that return the total revenue for each customer, 
--including the company and customer contact names. Tip: Review the documentation for the WITH common_table_expression syntax in the Transact-SQL language reference.

--Challenge2 Task1
--Retrieve a list of customers in the format Company (Contact Name) together with the total revenue for that customer. 
--Use a derived table or a common table expression to retrieve the details for each sales order, and then query the derived table or CTE to aggregate and group the data.
WITH SalesOrders(ContactDetails, TotalRevenue)
AS
	(SELECT CONCAT(customer.CompanyName,' (', customer.FirstName,' ',customer.LastName,')') AS ListOfCustomers, orderHeader.TotalDue
	FROM SalesLT.SalesOrderHeader AS orderHeader
	JOIN SalesLT.Customer AS customer
	ON customer.CustomerID = orderHeader.CustomerID)
SELECT ContactDetails, SUM(TotalRevenue) as TotalRevenue
FROM SalesOrders
GROUP BY ContactDetails 
ORDER BY TotalRevenue;
-- 32 rows
