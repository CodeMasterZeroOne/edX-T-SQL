USE AdventureWorksLT2012
--LAB04

--Customers can have two kinds of address: a main office address and a shipping address. 
--The accounts department want to ensure that the main office address is always used for billing, 
--and have asked you to write a query that clearly identifies the different types of address for each customer. 
--Tip: Review the documentation for the UNION operator in the Transact-SQL Reference.

--Challenge1 Task1
--Write a query that retrieves the company name, first line of the street address, city, 
--and a column named AddressType with the value ‘Billing’ for customers where the address type in the 
--SalesLT.CustomerAddress table is ‘Main Office’.
SELECT customer.CompanyName, address.AddressLine1, address.City, 'Billing' AS AddressType 
FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS addressSpareTable 
ON customer.CustomerID = addressSpareTable.CustomerID
JOIN SalesLT.Address AS address
ON addressSpareTable.AddressID = address.AddressID
WHERE addressSpareTable.AddressType = 'Main Office';
-- 407 rows

--Challenge1 Task2
--Write a similar query that retrieves the company name, first line of the street address, city, and a 
--column named AddressType with the value ‘Shipping’ for customers where the address type in the 
--SalesLT.CustomerAddress table is ‘Shipping’.
SELECT customer.CompanyName, address.AddressLine1, address.City, 'Shipping' AS AddressType 
FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS addressSpareTable
ON customer.CustomerID = addressSpareTable.CustomerID
JOIN SalesLT.Address AS address
ON addressSpareTable.AddressID = address.AddressID
WHERE addressSpareTable.AddressType = 'Shipping';
-- 10 rows

--Challenge1 Task3
--Combine the results returned by the two queries to create a list of all 
--customer addresses that is sorted by company name and then address type.
SELECT customer.CompanyName, address.AddressLine1, address.City, 'Billing' AS AddressType 
FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS addressSpareTable 
ON customer.CustomerID = addressSpareTable.CustomerID
JOIN SalesLT.Address AS address
ON addressSpareTable.AddressID = address.AddressID
WHERE addressSpareTable.AddressType = 'Main Office'
UNION
SELECT customer.CompanyName, address.AddressLine1, address.City, 'Shipping' AS AddressType 
FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS addressSpareTable
ON customer.CustomerID = addressSpareTable.CustomerID
JOIN SalesLT.Address AS address
ON addressSpareTable.AddressID = address.AddressID
WHERE addressSpareTable.AddressType = 'Shipping'
ORDER BY customer.CompanyName, AddressType;
-- 417 rows

--Challenge2 Task1
--Write a query that returns the company name of each company that appears in a table of customers
--with a ‘Main Office’ address, but not in a table of customers with a ‘Shipping’ address.
SELECT customer.CompanyName FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS customerAddress
ON customer.CustomerID = customerAddress.CustomerID
WHERE customerAddress.AddressType = 'Main Office'
EXCEPT
SELECT customer.CompanyName FROM SalesLT.Customer AS customer
JOIN SalesLT.CustomerAddress AS customerAddress
ON customer.CustomerID = customerAddress.CustomerID
WHERE customerAddress.AddressType = 'Shipping';
-- 396 rows

--Challenge2 Task2
--Write a query that returns the company name of each company that appears in a table of customers
--with a ‘Main Office’ address, and also in a table of customers with a ‘Shipping’ address.
SELECT customer.CompanyName FROM SalesLT.Customer as customer
JOIN SalesLT.CustomerAddress AS customerAddress
ON customer.CustomerID = customerAddress.CustomerID
WHERE customerAddress.AddressType = 'Main Office'
INTERSECT
SELECT customer.CompanyName FROM SalesLT.Customer as customer
JOIN SalesLT.CustomerAddress AS customerAddress
ON customer.CustomerID = customerAddress.CustomerID
WHERE customerAddress.AddressType = 'Shipping'
-- 10 rows
