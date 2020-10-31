USE [AdventureWorks2012];
GO

/*
a) �������� ������������� VIEW, ������������ ������ �� ������ Person.PhoneNumberType
� Person.PersonPhone. �������� ���������� ���������� ������ � �������������
�� ����� PhoneNumberTypeID � BusinessEntityID.
*/
CREATE VIEW [Person].[PhoneNumberTypeAndPhoneView] (
	[BusinessEntityID],
	[PhoneNumber],
	[PhoneNumberTypeID],
	[Name],
	[PhoneModifiedDate],
	[PhoneNumberTypeModifiedDate]
)
WITH SCHEMABINDING
AS SELECT
	[pp].[BusinessEntityID],
	[pp].[PhoneNumber],
	[pnt].[PhoneNumberTypeID],
	[pnt].[Name],
	[pp].[ModifiedDate],
	[pnt].[ModifiedDate]
FROM [Person].[PersonPhone] AS [pp]
INNER JOIN [Person].[PhoneNumberType] AS [pnt] ON [pnt].[PhoneNumberTypeID] = [pp].[PhoneNumberTypeID]
GO

CREATE UNIQUE CLUSTERED INDEX [IX_PhoneNumberTypeAndPhoneView_PhoneNumberTypeID_BusinessEntityID]
ON [Person].[PhoneNumberTypeAndPhoneView] ([PhoneNumberTypeID], [BusinessEntityID])
GO

/*
b) �������� ���� INSTEAD OF ������� ��� ������������� �� ��� �������� INSERT, UPDATE, DELETE.
������� ������ ��������� ��������������� �������� � �������� Person.PhoneNumberType � Person.PersonPhone
��� ���������� BusinessEntityID.
*/
CREATE TRIGGER [Person].[PhoneNumberTypeAndPhoneViewInsertUpdateDeleteTrigger]
ON [Person].[PhoneNumberTypeAndPhoneView]
INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
	IF EXISTS (SELECT * FROM [inserted])
	BEGIN
		IF NOT EXISTS (SELECT * FROM [deleted])
		BEGIN
			INSERT INTO [Person].[PhoneNumberType] (
				[Name],
				[ModifiedDate])
			SELECT
				[inserted].[Name],
				GETDATE()
			FROM [inserted]

			INSERT INTO [Person].[PersonPhone] (
				[BusinessEntityID],
				[PhoneNumber],
				[PhoneNumberTypeID],
				[ModifiedDate])
			SELECT
				[inserted].[BusinessEntityID],
				[inserted].[PhoneNumber],
				[pnt].[PhoneNumberTypeID],
				GETDATE()
			FROM [inserted]
			INNER JOIN [Person].[PhoneNumberType] [pnt] ON [pnt].[Name] = [inserted].[Name];
		END
		ELSE
		BEGIN
			UPDATE [Person].[PhoneNumberType] SET
				[Name] = [inserted].[Name],
				[ModifiedDate] = GETDATE()
			FROM [inserted], [deleted]
			WHERE [Person].[PhoneNumberType].[PhoneNumberTypeID] = [deleted].[PhoneNumberTypeID]

			UPDATE [Person].[PersonPhone] SET
				[BusinessEntityID] = [inserted].[BusinessEntityID],
				[PhoneNumber] = [inserted].[PhoneNumber],
				[ModifiedDate] = GETDATE()
			FROM [inserted], [deleted]
			WHERE [Person].[PersonPhone].[BusinessEntityID] = [deleted].[BusinessEntityID]
			AND [Person].[PersonPhone].[PhoneNumber] = [deleted].[PhoneNumber]
		END
	END
	ELSE
	BEGIN
		DELETE FROM [Person].[PersonPhone]
		WHERE [BusinessEntityID] IN (SELECT [BusinessEntityID] FROM [deleted])
		AND [PhoneNumber] IN (SELECT [PhoneNumber] FROM [deleted])

		DELETE FROM [Person].[PhoneNumberType]
		WHERE [PhoneNumberTypeID] IN (SELECT [PhoneNumberTypeID] FROM [deleted])
	END
END;
GO

/*c)
�������� ����� ������ � �������������, ������ ����� ������ ��� PhoneNumberType �
PersonPhone ��� ������������� BusinessEntityID (�������� 1). ������� ������ �������� ����� ������ � �������
Person.PhoneNumberType � Person.PersonPhone. �������� ����������� ������ ����� �������������. ������� ������.
*/
INSERT INTO [Person].[PhoneNumberTypeAndPhoneView] (
	[BusinessEntityID],
	[PhoneNumber],
	[Name])
VALUES(1, '999-999-999', 'NewType');

SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

UPDATE [Person].[PhoneNumberTypeAndPhoneView] SET
	[Name] = 'NewType2',
	[PhoneNumber] = '666-666-666'
WHERE [PhoneNumber] = '999-999-999';

SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

DELETE FROM [Person].[PhoneNumberTypeAndPhoneView]
WHERE [PhoneNumber] = '666-666-666';