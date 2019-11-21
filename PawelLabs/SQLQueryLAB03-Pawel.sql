USE AdventureWorksLT2012
--LAB03

--Adventure Works Cycles sells directly to retailers, who must be invoiced for their orders. 
--You have been tasked with writing a query to generate a list of invoices to be sent to customers. 
--Tip: Review the documentation for the FROM clause in the Transact-SQL Reference.

--Challenge1 Task1
--As an initial step towards generating the invoice report, write a query that returns the company name
--from the SalesLT.Customer table, and the sales order ID and total due from the SalesLT.SalesOrderHeader table.
SELECT b.CompanyName, a.SalesOrderID, a.TotalDue
FROM SalesLT.SalesOrderHeader AS a
LEFT OUTER JOIN SalesLT.Customer AS b
ON a.CustomerID = b.CustomerID

--Challenge1 Task2
--Extend your customer orders query to include the Main Office address for each customer, 
--including the full street address, city, state or province, postal code, and country or region 
--Tip: Note that each customer can have multiple addressees in the SalesLT.Address table, so the 
--database developer has created the SalesLT.CustomerAddress table to enable a many-to-many relationship 
--between customers and addresses. Your query will need to include both of these tables, and should filter 
--the join to SalesLT.CustomerAddress so that only Main Office addresses are included.
SELECT b.CompanyName, a.SalesOrderID, a.TotalDue, c.AddressType, d.AddressLine1, d.AddressLine2, d.City, d.StateProvince, d.PostalCode, d.CountryRegion
FROM SalesLT.SalesOrderHeader AS a
LEFT OUTER JOIN SalesLT.Customer AS b
ON a.CustomerID = b.CustomerID
LEFT OUTER JOIN SalesLT.CustomerAddress AS c
ON b.CustomerID = c.CustomerID
LEFT OUTER JOIN SalesLT.Address AS d
ON c.AddressID = d.AddressID
WHERE c.AddressType = 'Main Office'

--Challenge2 Task1
--The sales manager wants a list of all customer companies and their contacts (first name and last name),
--showing the sales order ID and total due for each order they have placed. Customers who have not
--placed any orders should be included at the bottom of the list with NULL values for the order ID and
--total due.
SELECT a.CompanyName, a.FirstName, a.LastName, b.SalesOrderID, b.TotalDue
FROM SalesLT.Customer As a
FULL OUTER JOIN SalesLT.SalesOrderHeader AS b
ON a.CustomerID = b.CustomerID
ORDER BY b.TotalDue DESC

--Challenge2 Task2
--A sales employee has noticed that Adventure Works does not have address information for all
--customers. You must write a query that returns a list of customer IDs, company names, contact names
--(first name and last name), and phone numbers for customers with no address stored in the database.
SELECT b.CustomerID, b.CompanyName, b.FirstName, b.LastName, b.Phone, c.AddressLine1, c.AddressLine2
FROM SalesLT.CustomerAddress AS a
LEFT OUTER JOIN SalesLT.Customer AS b
ON a.CustomerID = b.CustomerID
LEFT OUTER JOIN SalesLT.Address AS c
ON  a.AddressID = c.AddressID
WHERE c.AddressLine2 IS NULL

SELECT b.CustomerID, b.CompanyName, b.FirstName, b.LastName, b.Phone, c.AddressLine1, c.AddressLine2
FROM SalesLT.Customer AS b
LEFT OUTER JOIN SalesLT.CustomerAddress AS a
ON a.CustomerID = b.CustomerID
LEFT OUTER JOIN SalesLT.Address AS c
ON  a.AddressID = c.AddressID
WHERE c.AddressID IS NULL

--Challenge2 Task3
--Some customers have never placed orders, and some products have never been ordered. Create a query
--that returns a column of customer IDs for customers who have never placed an order, and a column of
--product IDs for products that have never been ordered. Each row with a customer ID should have a
--NULL product ID (because the customer has never ordered a product) and each row with a product ID
--should have a NULL customer ID (because the product has never been ordered by a customer).
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL OUTER JOIN SalesLT.SalesOrderHeader AS h
ON h.CustomerID =  c.CustomerID --joined SalesOrderHeader with Customer ON customerID
FULL OUTER JOIN SalesLT.SalesOrderDetail AS o
ON o.SalesOrderID = h.SalesOrderID --joined SalesOrderDatail with SalesOrderHeader ON SalesOrderID
FULL OUTER JOIN SalesLT.Product AS p
ON p.ProductID = o.ProductID --joined Product with SalesOrderDatail ON ProductID
WHERE o.SalesOrderID IS NULL
--968 rows

SELECT a.CustomerID
FROM SalesLT.Customer AS a
left outer join SalesLT.SalesOrderHeader AS b
ON b.CustomerID = a.CustomerID
WHERE b.CustomerID is null
--815 rows

SELECT p.ProductID
FROM SalesLT.Product AS p
left outer join SalesLT.SalesOrderDetail AS s
ON s.ProductID = p.ProductID
WHERE s.ProductID is null
--153 rows