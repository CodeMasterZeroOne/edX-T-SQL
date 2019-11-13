USE AdventureWorksLT2012
--LAB02

--The logistics manager at Adventure Works has asked you to generate some reports containing details of the company’s customers to help to reduce transportation costs. 
--Tip: Review the documentation for the SELECT and ORDER BY clauses in the Transact-SQL Reference.

--Challenge1 Task1
--Initially, you need to produce a list of all of you customers' locations. Write a Transact-SQL query that queries the Address table and retrieves all values for City and StateProvince, removing duplicates.
SELECT DISTINCT City, StateProvince
FROM SalesLT.Address

--Challenge1 Task2
--Transportation costs are increasing and you need to identify the heaviest products. Retrieve the names of the top ten percent of products by weight.
SELECT TOP 10 PERCENT Name
FROM SalesLT.Product
ORDER BY Weight DESC

--Challenge1 Task3
--The heaviest ten products are transported by a specialist carrier, therefore you need to modify the previous query to list the heaviest 100 products not including the heaviest ten.
SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
OFFSET 10 ROWS
FETCH NEXT 100 ROWS ONLY

--The Production Manager at Adventure Works would like you to create some reports listing details of the products that you sell.
--Tip: Review the documentation for the WHERE and LIKE keywords in the Transact-SQL Reference.

--Challenge2 Task1
--Initially, you need to find the names, colors, and sizes of the products with a product model ID 1.
SELECT Name, Color,Size
FROM SalesLT.Product
WHERE ProductModelID = 1

--Challenge2 Task2
--Retrieve the product number and name of the products that have a color of 'black', 'red', or 'white' and a size of 'S' or 'M'.
SELECT ProductNumber, Name
FROM SalesLT.Product
WHERE (Color='black' OR Color='red' OR Color='white') AND (Size='S' OR Size='M')

SELECT ProductNumber, Name
FROM SalesLT.Product
WHERE Color IN ('black', 'red', 'white') AND Size IN ('S', 'M')

--Challenge2 Task3
--Retrieve the product number, name, and list price of products whose product number begins 'BK-'.
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%'

--Challenge2 Task4
--Modify your previous query to retrieve the product number, name, and list price of products whose product number begins 'BK-' followed by any character other than 'R’, and ends with a '-' followed by any two numerals.
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'