USE AdventureWorksLT2012
--LAB010

--You want to create reusable scripts that make it easy to insert sales orders. You plan to create a script to insert the 
--order header record, and a separate script to insert order detail records for a specified order header. 
--Both scripts will make use of variables to make them easy to reuse. 
--Tip: Review the documentation for variables and the IF�ELSE block in the Transact-SQL Language Reference.

--Challenge1 Task1
--Your script to insert an order header must enable users to specify values for the order date, due date, and 
--customer ID. The SalesOrderID should be generated from the next value for the SalesLT.SalesOrderNumber sequence and assigned to a variable. 
--The script should then insert a record into the SalesLT.SalesOrderHeader table using these values and a hard-coded value of �CARGO TRANSPORT 5�
--for the shipping method with default or NULL values for all other columns.
--After the script has inserted the record, it should display the inserted SalesOrderID using the PRINT command.
--Test your code with the following values:

--Order Date     Due Date          Customer ID 
--Today�s date   7 days from now   1

DECLARE @orderDate date = GETDATE();
DECLARE @dueDate date = DATEADD(DD, 7, GETDATE());
DECLARE @customerID int = 1;

INSERT INTO SalesLT.SalesOrderHeader(OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@orderDate, @dueDate, @customerID, 'CARGO TRANSPORT 5')
PRINT SCOPE_IDENTITY();
-- 1 row affected, new sales order ID = 71947

--Note: Support for Sequence objects was added to Azure SQL Database in version 12, which became
--available in some regions in February 2015. If you are using the previous version of Azure SQL database
--(and the corresponding previous version of the AdventureWorksLT sample database), you will need to
--adapt your code to insert the sales order header without specifying the SalesOrderID (which is an
--IDENTITY column in older versions of the sample database), and then assign the most recently
--generated identity value to the variable you have declared.

--Challenge1 Task2
--The script to insert an order detail must enable users to specify a sales order ID, a product ID, a quantity,
--and a unit price. It must then check to see if the specified sales order ID exists in the
--SalesLT.SalesOrderHeader table. If it does, the code should insert the order details into the
--SalesLT.SalesOrderDetail table (using default values or NULL for unspecified columns). If the sales order
--ID does not exist in the SalesLT.SalesOrderHeader table, the code should print the message �The order
--does not exist�. You can test for the existence of a record by using the EXISTS predicate.
DECLARE @salesOrderID int = 71947;
DECLARE @productID int = 760;
DECLARE @quantity smallint = 1;
DECLARE @unitPrice money = 782.99;

IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @salesOrderID)
	BEGIN 
		INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
		VALUES (@salesOrderID, @productID, @quantity, @unitPrice)
	END
ELSE
	BEGIN
		PRINT 'The order does not exist'
	END
-- 1 row affected 

--Test your code with the following values:
--Sales Order ID 		Product ID 		Quantity 	Unit Price
--The sales order ID    760				1			782.99
--returned by your
--previous code to insert
--a sales order header.

--Then test it again with the following values:
--Sales Order ID	Product ID	Quantity	Unit Price
--0			760		1		782.99
DECLARE @salesOrderID int = 0;
DECLARE @productID int = 760;
DECLARE @quantity smallint = 1;
DECLARE @unitPrice money = 782.99;

IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @salesOrderID)
	BEGIN 
		INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
		VALUES (@salesOrderID, @productID, @quantity, @unitPrice)
	END
ELSE
	BEGIN
		PRINT 'The order does not exist'
	END
-- The order does not exist

--Adventure Works has determined that the market average price for a bike is $2,000, and consumer
--research has indicated that the maximum price any customer would be likely to pay for a bike is $5,000.
--You must write some Transact-SQL logic that incrementally increases the list price for all bike products
--by 10% until the average list price for a bike is at least the same as the market average, or until the most
--expensive bike is priced above the acceptable maximum indicated by the consumer research.
--Tip: Review the documentation for WHILE in the Transact-SQL Language Reference.

--Challenge2 Task1
--Write a WHILE loop to update bike prices
--The loop should:
--1) Execute only if the average list price of a product in the �Bikes� parent category is less than the
--market average. Note that the product categories in the Bikes parent category can be
--determined from the SalesLT.vGetAllCategories view.
--2) Update all products that are in the �Bikes� parent category, increasing the list price by 10%.
--3) Determine the new average and maximum selling price for products that are in the �Bikes� parent category.
--4) If the new maximum price is greater than or equal to the maximum acceptable price, exit the loop; otherwise continue. 
DECLARE @marketAveragePrice money = 2000;
DECLARE @marketMaximumPrice money = 5000;
DECLARE @BikesAveragePrice money; -- 1586.74 AVG for Bikes
DECLARE @BikesMaximumPrice money; -- 3578.27 MAX for Bikes

SELECT @BikesAveragePrice = AVG(ListPrice), @BikesMaximumPrice = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT ProductCategoryID FROM SalesLT.vGetAllCategories
	WHERE ParentProductCategoryName ='Bikes');

PRINT 'Bikes AVG price is ' + CAST(@BikesAveragePrice AS nvarchar(50));
PRINT 'Bikes MAX price is ' + CAST(@BikesMaximumPrice AS nvarchar(50));

WHILE (@BikesAveragePrice < @marketAveragePrice)
BEGIN
	UPDATE SalesLT.Product
	SET ListPrice = ListPrice * 1.1
	WHERE ProductCategoryID IN
		(SELECT ProductCategoryID FROM SalesLT.vGetAllCategories
		WHERE ParentProductCategoryName ='Bikes');

	IF(@BikesMaximumPrice >= @marketMaximumPrice)
		BREAK;
	ELSE
		CONTINUE;
END

SELECT @BikesAveragePrice = AVG(ListPrice), @BikesMaximumPrice = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT ProductCategoryID FROM SalesLT.vGetAllCategories
	WHERE ParentProductCategoryName ='Bikes');

PRINT 'New Bikes AVG price is ' + CAST(@BikesAveragePrice AS nvarchar(50));
PRINT 'New Bikes MAX price is ' + CAST(@BikesMaximumPrice AS nvarchar(50));
-- result of the full query
--(97 rows affected)
--Bikes AVG price is 2111.95
--Bikes MAX price is 4762.68
--New Bikes AVG price is 2111.95
--New Bikes MAX price is 4762.68