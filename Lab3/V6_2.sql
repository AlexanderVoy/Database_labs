USE AdventureWorks2012;
GO

/*
a) ��������� ���, ��������� �� ������ ������� ������ ������������ ������.
�������� � ������� dbo.Person ���� TotalGroupSales MONEY � SalesYTD MONEY.
����� �������� � ������� ����������� ���� RoundSales, ����������� �������� � ���� SalesYTD �� ������ �����.
*/
ALTER TABLE dbo.Person
ADD TotalGroupSales MONEY, SalesYTD MONEY, RoundSales AS (ROUND(SalesYTD, 0));

/*
b) �������� ��������� ������� #Person, � ��������� ������ �� ���� BusinessEntityID.
��������� ������� ������ �������� ��� ���� ������� dbo.Person �� ����������� ���� RoundSales.
*/
CREATE TABLE dbo.#Person (
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(4) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	TotalGroupSales MONEY,
	SalesYTD MONEY
	PRIMARY KEY(BusinessEntityID)
)

/*
c) ��������� ��������� ������� ������� �� dbo.Person.
���� SalesYTD ��������� ���������� �� ������� Sales.SalesTerritory.
���������� ����� ����� ������ (SalesYTD) ��� ������ ������ ���������� (Group)
� ������� Sales.SalesTerritory � ��������� ����� ���������� ���� TotalGroupSales.
������� ����� ������ ����������� � Common Table Expression (CTE).
*/
WITH SALES_CTE AS (SELECT st."Group", SUM(st.SalesYTD) TotalGroupSales
FROM Sales.SalesTerritory st
GROUP BY st."Group")

INSERT INTO dbo.#Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	TotalGroupSales,
	SalesYTD
) SELECT
	p.BusinessEntityID,
	p.PersonType,
	p.NameStyle,
	p.Title,
	p.FirstName,
	p.MiddleName,
	p.LastName,
	p.Suffix,
	p.EmailPromotion,
	p.ModifiedDate,
	t.TotalGroupSales,
	st.SalesYTD
FROM dbo.Person p
INNER JOIN Sales.Customer c ON c.PersonID = p.BusinessEntityID
INNER JOIN Sales.SalesTerritory st ON st.TerritoryID = c.TerritoryID
INNER JOIN SALES_CTE t ON st."Group" = t."Group";

SELECT * FROM dbo.#Person;

/*
d) ������� �� ������� dbo.Person ������, ��� EmailPromotion = 2
*/
DELETE FROM dbo.Person WHERE EmailPromotion = 2;

/*
e) �������� Merge ���������, ������������ dbo.Person ��� target, � ��������� ������� ��� source.
��� ����� target � source ����������� BusinessEntityID.
�������� ���� TotalGroupSales � SalesYTD, ���� ������ ������������ � source � target.
���� ������ ������������ �� ��������� �������, �� �� ���������� � target, �������� ������ � dbo.Person.
���� � dbo.Person ������������ ����� ������, ������� �� ���������� �� ��������� �������, ������� ������ �� dbo.Person.
*/
MERGE INTO dbo.Person dest
USING dbo.#Person src
ON dest.BusinessEntityID = src.BusinessEntityID
WHEN MATCHED THEN UPDATE SET
	dest.TotalGroupSales = src.TotalGroupSales,
	dest.SalesYTD = src.SalesYTD
WHEN NOT MATCHED BY TARGET THEN	INSERT (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	TotalGroupSales,
	SalesYTD)
VALUES(
	src.BusinessEntityID,
	src.PersonType,
	src.NameStyle,
	src.Title,
	src.FirstName,
	src.MiddleName,
	src.LastName,
	src.Suffix,
	src.EmailPromotion,
	src.ModifiedDate,
	src.TotalGroupSales,
	src.SalesYTD)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
GO

SELECT * FROM dbo.Person;