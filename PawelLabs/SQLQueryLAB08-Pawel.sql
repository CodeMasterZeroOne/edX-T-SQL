USE AdventureWorksLT2012
--LAB08

--Adventure Works sells products to customers in multiple country/regions around the world.

--Challenge1 Task1
--An existing report uses the following query to return total sales revenue grouped by country/region and state/province.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;

--You have been asked to modify this query so that the results include a grand total for all sales revenue and a subtotal
--for each country/region in addition to the state/province subtotals that are already returned.
--Tip: Review the documentation for GROUP BY in the Transact-SQL Language Reference.

--Challenge1 Task2
--Modify your query to include a column named Level that indicates at which level in the total,
--country/region, and state/province hierarchy the revenue figure in the row is aggregated. For example,
--the grand total row should contain the value ‘Total’, the row showing the subtotal for United States
--should contain the value ‘United States Subtotal’, and the row showing the subtotal for California should
--contain the value ‘California Subtotal’.
--Tip: Review the documentation for the GROUPING_ID function in the Transact-SQL Language Reference.

--Challenge1 Task3
--Extend your query to include a grouping for individual cities.

--Challenge2 Task1
--Retrieve a list of customer company names together with their total revenue for each parent category in
--Accessories, Bikes, Clothing, and Components.
--Tip: Review the documentation for the PIVOT operator in the FROM clause syntax in the Transact-SQL language reference.

--Challenge2 Task2


--Challenge2 Task3
