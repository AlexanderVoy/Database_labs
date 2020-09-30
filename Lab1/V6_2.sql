USE AdventureWorks2012;
GO

--Вывести на экран список отделов, названия которых начинаются на букву ‘F’ и заканчиваются на букву ‘е’.
SELECT DepartmentID, Name FROM HumanResources.Department WHERE Name LIKE 'F%e';
GO

/*Вывести на экран среднее количество часов отпуска и среднее количество больничных часов у сотрудников.
Назовите столбцы с результатами ‘AvgVacationHours’ и ‘AvgSickLeaveHours’ для отпусков и больничных соответственно.*/
SELECT AVG(Employee.VacationHours) as AvgVacationHours, AVG(Employee.SickLeaveHours) as AvgSickLeaveHours
FROM HumanResources.Employee;
GO

/*Вывести на экран сотрудников, которым больше 65-ти лет на настоящий момент.
Вывести также количество лет, прошедших с момента трудоустройства, в столбце с именем ‘YearsWorked’.*/
SELECT Employee.BusinessEntityID, Employee.JobTitle, Employee.Gender, DATEDIFF(YEAR, Employee.HireDate, CURRENT_TIMESTAMP) 'YearsWorked'
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, Employee.BirthDate, CURRENT_TIMESTAMP) > 65;
GO