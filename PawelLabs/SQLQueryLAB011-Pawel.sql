USE AdventureWorksLT2012
--LAB011

--You are implementing a Transact-SQL script to delete orders, and you want to handle any errors that occur during the deletion process. 
--Tip: Review the documentation for THROW and TRY…CATCH in the Transact-SQL Language Reference.

--Challenge1 Task1
--You are currently using the following code to delete order data:
--DECLARE @SalesOrderID int = <the_order_ID_to_delete>
--DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
--DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
--This code always succeeds, even when the specified order does not exist. 
--Modify the code to check for the existence of the specified order ID before attempting to delete it. 
--If the order does not exist, your code should throw an error. Otherwise, it should go ahead and delete the order data.
DECLARE @SalesOrderID int = 0;
IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
	END
ELSE
	BEGIN
		THROW 50001, 'This order ID does not exist.', 0
		-- NOTE: error number must be above 50000
	END

--Challenge1 Task2
--Your code now throws an error if the specified order does not exist. 
--You must now refine your code to catch this (or any other) error and print the error message to the user interface using the PRINT command.
DECLARE @SalesOrderID int = 0;
BEGIN TRY
	IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN
			DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
			DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
		END
	ELSE
		BEGIN
			THROW 50001, 'This order ID does not exist.', 0
		END
END TRY
BEGIN CATCH
	 PRINT ERROR_MESSAGE();
END CATCH

--You have implemented error handling logic in some Transact-SQL code that deletes order details and
--order headers. However, you are concerned that a failure partway through the process will result in data
--inconsistency in the form of undeleted order headers for which the order details have been deleted.
--Tip: Review the documentation for Transaction Statements in the Transact-SQL Language Reference.

--Challenge2 Task1
--Enhance the code you created in the previous challenge so that the two DELETE statements are treated
--as a single transactional unit of work. In the error handler, modify the code so that if a transaction is in
--process, it is rolled back and the error is re-thrown to the client application. If not transaction is in
--process the error handler should continue to simply print the error message.
--To test your transaction, add a THROW statement between the two DELETE statements to simulate an
--unexpected error. When testing with a valid, existing order ID, the error should be re-thrown by the
--error handler and no rows should be deleted from either table.
DECLARE @SalesOrderID int = 0;
BEGIN TRY
	IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN
			BEGIN TRANSACTION
				DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
				DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
			COMMIT TRANSACTION
		END
	ELSE
		BEGIN
			THROW 50001, 'This order ID does not exist.', 0
		END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
	ELSE
		BEGIN
			PRINT ERROR_MESSAGE();
		END
END CATCH
