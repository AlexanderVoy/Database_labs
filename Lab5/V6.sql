USE AdventureWorks2012;
GO

/*Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра 
id заказа (Sales.SalesOrderHeader.SalesOrderID) и возвращать итоговую сумму для заказа 
(сумма по полям SubTotal, TaxAmt, Freight).*/
CREATE FUNCTION [Sales].[GetTotalPrice](@SalesOrderID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @result MONEY
	SELECT @result = (SUM([s].[SubTotal]) + SUM([s].[TaxAmt]) + SUM([s].[Freight]))
	FROM [Sales].[SalesOrderHeader] AS [s]
	WHERE [s].[SalesOrderID] = @SalesOrderID
	RETURN @result
END;
GO

SELECT [Sales].[GetTotalPrice](43659) AS [Total];
GO

/*Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра 
id заказа на производство (Production.WorkOrder.WorkOrderID), а возвращать детали заказа из 
Production.WorkOrderRouting.*/
CREATE FUNCTION [Production].[GetOrderDetailsByWorkOrderID](@WorkOrderID INT)
RETURNS TABLE AS RETURN (
	SELECT 
		[WorkOrderID],
		[ProductID],
		[OperationSequence],
		[LocationID],
		[ScheduledStartDate],
		[ScheduledEndDate],
		[ActualStartDate],
		[ActualEndDate],
		[ActualResourceHrs],
		[PlannedCost],
		[ActualCost],
		[ModifiedDate]
	FROM [Production].[WorkOrderRouting]
	WHERE [Production].[WorkOrderRouting].[WorkOrderID] = @WorkOrderID		
);
GO

SELECT * FROM [Production].[GetOrderDetailsByWorkOrderID](14); 
GO


/*Вызовите функцию для каждого заказа, применив оператор CROSS APPLY. Вызовите функцию 
для каждого заказа, применив оператор OUTER APPLY.*/
SELECT * FROM [Production].[WorkOrder] 
	CROSS APPLY [Production].[GetOrderDetailsByWorkOrderID]([WorkOrderID]);
SELECT * FROM [Production].[WorkOrder] 
	OUTER APPLY [Production].[GetOrderDetailsByWorkOrderID]([WorkOrderID]);
GO

/*Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
(предварительно сохранив для проверки код создания inline table-valued функции).*/
CREATE FUNCTION [Production].[GetOrderDetailsByWorkOrderIDMultist](@WorkOrderID INT)
RETURNS @result TABLE(
	[WorkOrderID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [OperationSequence] SMALLINT NOT NULL,
    [LocationID] SMALLINT NOT NULL,
    [ScheduledStartDate] DATETIME NOT NULL,
    [ScheduledEndDate] DATETIME NOT NULL,
    [ActualStartDate] DATETIME NULL,
    [ActualEndDate] DATETIME NULL,
    [ActualResourceHrs] DECIMAL(9, 4) NULL,
    [PlannedCost] MONEY NOT NULL,
    [ActualCost] MONEY NULL,
    [ModifiedDate] DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT 
		[WorkOrderID],
		[ProductID],
		[OperationSequence],
		[LocationID],
		[ScheduledStartDate],
		[ScheduledEndDate],
		[ActualStartDate],
		[ActualEndDate],
		[ActualResourceHrs],
		[PlannedCost],
		[ActualCost],
		[ModifiedDate]
	FROM [Production].[WorkOrderRouting]
	WHERE [Production].[WorkOrderRouting].[WorkOrderID] = @WorkOrderID
	RETURN
END;

SELECT * FROM [Production].[GetOrderDetailsByWorkOrderIDMultist](14); 
GO