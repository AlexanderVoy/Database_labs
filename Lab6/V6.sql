USE AdventureWorks2012;
GO

/*Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
отображающую данные о количестве сотрудников (HumanResources.Employee) определенного пола,
проживающих в каждом городе (Person.Address). Список обозначений для пола передайте в процедуру 
через входной параметр.*/
CREATE PROCEDURE [dbo].[CitiesByGender](@GenderNames NVARCHAR(10)) AS
BEGIN
	DECLARE @SQLQuery AS NVARCHAR(900);
	SET @SQLQuery = '
		SELECT [City], ' + @GenderNames + '
		FROM (
			SELECT [E].[BusinessEntityID], [E].[Gender], [A].[City]
			FROM [HumanResources].[Employee] AS [E]
			INNER JOIN [Person].[BusinessEntityAddress] AS [BEA] ON [BEA].[BusinessEntityID] = [E].[BusinessEntityID]
			INNER JOIN [Person].[Address] AS [A] ON [A].[AddressID] = [BEA].[AddressID]
		) AS [EmployeesCities]
		PIVOT (COUNT([BusinessEntityID]) FOR [EmployeesCities].[Gender] IN(' + @GenderNames + ')) AS [CountOfEmployees]'
    EXECUTE sp_executesql @SQLQuery
END;
GO

EXECUTE [dbo].[CitiesByGender] '[F],[M]';
GO