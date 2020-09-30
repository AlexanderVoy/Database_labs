USE AdventureWorks2012;
GO

--Вывести на экран самую раннюю дату начала работы сотрудника в каждом отделе. Дату вывести для каждого отдела.
SELECT Department.Name, MIN(Employee.HireDate) as StartDate
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
INNER JOIN HumanResources.Department ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
GROUP BY Department.Name;

--Вывести на экран название смены сотрудников, работающих на позиции ‘Stocker’. Замените названия смен цифрами (Day — 1; Evening — 2; Night — 3).
SELECT Employee.BusinessEntityID, Employee.JobTitle, Shift.ShiftID as ShiftName
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
INNER JOIN HumanResources.Shift ON Shift.ShiftID = EmployeeDepartmentHistory.ShiftID
WHERE Employee.JobTitle = 'Stocker';

/*Вывести на экран информацию обо всех сотрудниках, с указанием отдела, в котором они работают в настоящий момент.
В названии позиции каждого сотрудника заменить слово ‘and’ знаком & (амперсанд).*/
SELECT Employee.BusinessEntityID, REPLACE(Employee.JobTitle, 'and', '&') as JobTitle, Department.Name as DepName
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
INNER JOIN HumanResources.Department ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
WHERE EmployeeDepartmentHistory.EndDate IS NULL;