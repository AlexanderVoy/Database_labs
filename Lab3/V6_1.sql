USE AdventureWorks2012;
GO

/*
a) добавьте в таблицу dbo.Person поле EmailAddress типа nvarchar размерностью 50 символов;
*/
ALTER TABLE dbo.Person
ADD EmailAddress NVARCHAR(50) NULL;
GO

/*
b) объявите табличную переменную с такой же структурой как dbo.Person и заполните ее данными из dbo.Person.
Поле EmailAddress заполните данными из Person.EmailAddress;
*/
DECLARE @Person TABLE(
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
	EmailAddress NVARCHAR(50) NULL,
	PRIMARY KEY (BusinessEntityID, PersonType)
);

INSERT INTO @Person (
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
	EmailAddress)
SELECT
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
	ea.EmailAddress
FROM dbo.Person p
INNER JOIN Person.EmailAddress ea ON ea.BusinessEntityID = p.BusinessEntityID;

SELECT * FROM @Person;

/*
c) обновите поле EmailAddress в dbo.Person данными из табличной переменной, убрав из
адреса все встречающиеся нули;
*/
UPDATE dbo.Person
SET dbo.Person.EmailAddress = REPLACE(p.EmailAddress, '0', '')
FROM @Person AS p;

SELECT EmailAddress FROM dbo.Person;

/*
d) удалите данные из dbo.Person, для которых тип контакта в таблице PhoneNumberType равен ‘Work’;
*/
DELETE p
FROM dbo.Person p
JOIN Person.PersonPhone pp ON pp.BusinessEntityID = p.BusinessEntityID
JOIN Person.PhoneNumberType pnt ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID
WHERE pnt.Name = 'Work';

/*
e) удалите поле EmailAddress из таблицы, удалите все созданные ограничения и значения по умолчанию.
*/
ALTER TABLE dbo.Person DROP COLUMN EmailAddress
ALTER TABLE dbo.Person DROP CONSTRAINT PK_Person
ALTER TABLE dbo.Person DROP CONSTRAINT CheckType
ALTER TABLE dbo.Person DROP CONSTRAINT DF_Person_Title

/*
f) удалите таблицу dbo.Person.
*/
DROP TABLE dbo.Person;