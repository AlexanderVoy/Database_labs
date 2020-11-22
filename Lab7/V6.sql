USE AdventureWorks2012;
GO 

/*Вывести значения полей [CreditCardID], [CardType], [CardNumber] из таблицы [Sales].[CreditCard] 
в виде xml, сохраненного в переменную. Формат xml должен соответствовать примеру. 
Создать хранимую процедуру, возвращающую таблицу, заполненную из xml переменной представленного вида. 
Вызвать эту процедуру для заполненной на первом шаге переменной.*/
CREATE PROCEDURE [dbo].[GetCreditCards](@CreditCardsXML XML)
AS
BEGIN
    CREATE TABLE #resultTable
    (
        [CreditCardID] INT,
        [CardType] NVARCHAR(50),
        [CardNumber] NVARCHAR(25)
    )

    INSERT #resultTable
    SELECT 
		x.value('@ID', 'INT') AS [CreditCardID],
        x.value('@Type', 'NVARCHAR(50)') AS [CardType] ,
        x.value('@Number', 'NVARCHAR(25)') AS [CardNumber]
    FROM @CreditCardsXML.nodes('/CreditCards/Card') XmlData(x)

    SELECT * FROM #resultTable;
END;
GO

DECLARE @Xml XML;
SET @Xml = (
	SELECT [CreditCardID] AS "@ID", [CardType] AS "@Type", [CardNumber] AS "@Number"
	FROM [Sales].[CreditCard]
	FOR XML PATH ('Card'), ROOT ('CreditCards'))
SELECT @Xml;
	
EXECUTE [dbo].[GetCreditCards] @Xml;
GO
