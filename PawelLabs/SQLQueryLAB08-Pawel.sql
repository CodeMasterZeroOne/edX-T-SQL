USE AdventureWorksLT2012
--LAB08

--Adventure Works sells products to customers in multiple country/regions around the world.
--An existing report uses the following query to return total sales revenue grouped by country/region and state/province.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a 
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;
-- 6 rows

--Challenge1 Task1
--You have been asked to modify this query so that the results include a grand total for all sales revenue and a subtotal
--for each country/region in addition to the state/province subtotals that are already returned.
--Tip: Review the documentation for GROUP BY in the Transact-SQL Language Reference.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
--GROUP BY GROUPING SETS(a.CountryRegion, a.StateProvince, ()) -- GROUPING SETS returns custom grouping
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince) -- ROLLUP also returns subtotal
--GROUP BY CUBE(a.CountryRegion, a.StateProvince) -- CUBE returns all possible groupings 
ORDER BY a.CountryRegion, a.StateProvince;
-- 9 rows

--Challenge1 Task2
--Modify your query to include a column named Level that indicates at which level in the total,
--country/region, and state/province hierarchy the revenue figure in the row is aggregated. For example,
--the grand total row should contain the value ‘Total’, the row showing the subtotal for United States
--should contain the value ‘United States Subtotal’, and the row showing the subtotal for California should
--contain the value ‘California Subtotal’.
--Tip: Review the documentation for the GROUPING_ID function in the Transact-SQL Language Reference.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue,
CASE 
	WHEN GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1 THEN 'Total'
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 1 THEN CONCAT(a.CountryRegion, ' Subtotal')
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 THEN CONCAT(a.StateProvince, ' Subtotal')
END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;
-- 9 rows

--Challenge1 Task3
--Extend your query to include a grouping for individual cities.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue,
CASE 
	WHEN GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.City) = 1 THEN 'Total'
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.City) = 1 THEN CONCAT(a.CountryRegion, ' Subtotal')
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 AND GROUPING_ID(a.City) = 1 THEN CONCAT(a.StateProvince, ' Subtotal')
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 AND GROUPING_ID(a.City) = 0 THEN CONCAT(a.City, ' Subtotal')
END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;
-- 38 rows

--Challenge2
--Adventure Works products are grouped into categories, which in turn have parent categories (defined in the SalesLT.vGetAllCategories view).
--Adventure Works customers are retail companies, and they may place orders for products of any category. The revenue for each product in an order
--is recorded as the LineTotal value in the SalesLT.SalesOrderDetail table. 

--Challenge2 Task1
--Retrieve a list of customer company names together with their total revenue for each parent category in
--Accessories, Bikes, Clothing, and Components.
--Tip: Review the documentation for the PIVOT operator in the FROM clause syntax in the Transact-SQL language reference.
SELECT * FROM
	(SELECT customer.CompanyName, allCategories.ParentProductCategoryName, orderDetail.LineTotal
	FROM SalesLT.SalesOrderDetail AS orderDetail
	JOIN SalesLT.SalesOrderHeader As orderHeader ON orderHeader.SalesOrderID = orderDetail.SalesOrderID
	JOIN SalesLT.Customer AS customer ON customer.CustomerID = orderHeader.CustomerID
	JOIN SalesLT.Product As product ON product.ProductID = orderDetail.ProductID
	JOIN SalesLT.vGetAllCategories AS allCategories ON allCategories.ProductCategoryID = product.ProductCategoryID) AS sales
PIVOT (SUM(LineTotal) FOR ParentProductCategoryName 
	IN ([Accessories], [Bikes], [Clothing], [Components])) AS pivotedSales
ORDER BY CompanyName;
-- 32 rows