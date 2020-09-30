-- Создание базы данных
CREATE DATABASE Alexander_Voyteshonok;
GO

-- Использование созданной БД в качестве рабочей
USE Alexander_Voyteshonok;
GO

-- Создание в текущей БД схем sales и persons
CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

-- Создание таблицы Orders в схеме sales с полем OrderNum типа Int 
CREATE TABLE sales.Orders(OrderNum INT NULL);
GO

-- Создание резервной копии всей базы данных на диске
BACKUP DATABASE Alexander_Voyteshonok
	TO DISK = N'D:\DBlabs\Lab1\Alexander_Voyteshonok.bak';
GO

-- Удаление базы данных
DROP DATABASE Alexander_Voyteshonok;
GO

-- Восстановление базы данных из резервной
RESTORE DATABASE Alexander_Voyteshonok
	FROM DISK = N'D:\DBlabs\Lab1\Alexander_Voyteshonok.bak';
GO