-- DDL Script for Tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName NVARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Insert Statements for Sample Data
-- Insert into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

-- Insert into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, HireDate, Salary) VALUES
(107, 'Alice', 1, '2024-05-15', 60000.00),
(102, 'Bob', 2, '2021-06-20', 75000.00),
(103, 'Charlie', 3, '2020-03-01', 50000.00),
(104, 'Diana', 2, '2019-07-10', 80000.00),
(105, 'Eve', 1, '2023-02-25', 55000.00);

-- Insert into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
(201, 'Project Alpha', '2023-01-01', '2023-12-31'),
(202, 'Project Beta', '2022-05-15', NULL),
(203, 'Project Gamma', '2021-09-01', '2022-12-31');

-- Insert into EmployeeProjects
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(101, 201, 120),
(102, 202, 200),
(103, 203, 150),
(104, 201, 100),
(105, 202, 180);


select * from Employees
select * from Departments
select * from Projects
select * from EmployeeProjects


-- Homework 1: Use a Temporary Table
-- Create a temporary table to store employees hired in the last year and their department names.
-- Then return the contents of the temporary table.

create table #TempHiredEmployees2 (
    EmployeeID int,
    Name nvarchar(30),
    DepartmentName nvarchar(100),
    HireDate date
);

insert into #TempHiredEmployees2 (EmployeeID, Name, DepartmentName, HireDate)
select E.EmployeeID, E.Name, D.DepartmentName, E.HireDate
from Employees E
join Departments D on E.DepartmentID = D.DepartmentID
where E.HireDate >= dateadd(year, -1, getdate());

select * from #TempHiredEmployees2;



---------------------------------------------------------------------------------------------
-- Homework 2: Advanced Stored Procedure
-- Create a stored procedure that assigns an employee to a project.
-- Input: EmployeeID, ProjectID, HoursWorked
-- Output: Success/Failure Message
create procedure AssignEmployeeToProject
    @EmployeeID int,
    @ProjectID int,
    @HoursWorked int
as
begin
    begin try
        insert into EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
        values (@EmployeeID, @ProjectID, @HoursWorked);

        select 'Success: Employee assigned to project.' as message;
    end try
    begin catch
        select 'Failure: Could not assign employee to project. ' + error_message() as Message;
    end catch
end;


----------------------------------------------------------------------------------------------
-- Homework 3: Create a View for Analysis
-- Create a view that lists all active projects (projects that have not ended yet)
-- and the number of employees assigned to each project

create view ActiveProjects as
select P.ProjectID, P.ProjectName, count(E.EmployeeID) as EmployeeCount
from Projects as P
left join EmployeeProjects as EP on P.ProjectID = EP.ProjectID
where P.EndDate is null or P.EndDate > getdate()
group by P.ProjectID, P.ProjectName;


----------------------------------------------------------------------------------------------------------------
--Homework 4:
--- write a query to check number is perfect or not


declare @Number int = 7;
declare @SumOfDivisors int;

select @SumOfDivisors = sum(Divisor)
from (
    select n as Divisor
    from (
        select top (@Number - 1) row_number() over (order by (select null)) as n
        from master.dbo.spt_values
    ) as T
    where @Number % n = 0
) as Divisors;

if @SumOfDivisors = @Number
    select 'The number is a perfect number.' as Result;
else
    select 'The number is NOT a perfect number.' as Result;
