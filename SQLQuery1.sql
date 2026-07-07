Create Database Mainly;
use Mainly;

Create Table Department(
DPcode int Primary Key,
DPname varchar(50),
);

Create Table Students(
StuID int,
StuName varchar(50),
Age int,
StuDPcode int,
primary key(StuID,StuDPcode),
Foreign Key(StuDPcode) references Department(DPcode)
);

Insert Into Department values (200 , 'AI'),(210 , 'CyberSecurity'),(220,'GameDev');

Insert into Students Values (1,'Trevor David',18,200),
(2,'Mohamed Samy',16,200),
(3,'Belal Tamer',16,200),
(4,'Hesham Mahmoud',17,200),
(5,'Jack Black',18,210),
(6,'Retag Adel',19,210),
(7,'Saleh Mansour',20,210),
(8,'Mohamed Ali',22,220),
(9,'Kevin Remon',23,220),
(10,'Jana Magdy',21,220);


create procedure sp_insertStudents @StudentCode int, @StudentName varchar(50), @StudentAge int, @DepartmentCode int
AS
Begin
insert into Students values (@StudentCode,@StudentName,@StudentAge,@DepartmentCode);
end;

create Procedure sp_insertDepartment @DepartmentCode int, @DepartmentName varchar(50)
as
begin
insert into Department Values (@DepartmentCode,@DepartmentName);
end;

create procedure sp_editStudent @StudentCode int, @StudentName varchar(50), @StudentAge int, @StudentDPcode int
as
begin
Update Students set StuName = @StudentName, Age = @StudentAge, StuDPcode = @StudentDPcode where StuID = @StudentCode;
end;

Create procedure sp_getAllStudents
as
begin
SELECT * From Students where Age between 18 and 22 ;
end;

Create procedure sp_DPstatics 
as
begin
SELECT D.DPname , Count(S.StuID) as [Number of Students],
AVG(S.Age) AS [Avg Age],
MAX(S.Age) As [Highest age],
Min(S.Age) As [Lowest Age]

from Department D 
Left join Students S 
on S.StuDPcode = D.DPcode Group by D.DPname;
end;


create procedure sp_SearchByDepartment @DepartmentCode int
as
begin
Select * From Students s where S.StuDPcode = @DepartmentCode;
end;


CREATE PROCEDURE sp_LowestnHighest
AS
BEGIN
    WITH DPcount AS (
        SELECT StuDPcode, COUNT(StuID) AS StudentCount 
        FROM Students 
        GROUP BY StuDPcode
    )
    SELECT DP.DPname, D.StudentCount, 'Highest' AS [Type]
    FROM DPcount D 
    LEFT JOIN Department DP ON D.StuDPcode = DP.DPcode
    WHERE D.StudentCount = (SELECT MAX(StudentCount) FROM DPcount)

    UNION ALL

    SELECT DP.DPname, D.StudentCount, 'Lowest' AS [Type]
    FROM DPcount D 
    LEFT JOIN Department DP ON D.StuDPcode = DP.DPcode
    WHERE D.StudentCount = (SELECT MIN(StudentCount) FROM DPcount);
END;





-- 1. Insert a new Department
-- Adding a new department (e.g., Data Science)
EXEC sp_insertDepartment 
    @DepartmentCode = 230, 
    @DepartmentName = 'Data Science';
GO

-- 2. Insert a new Student into Department 200 (AI)
EXEC sp_insertStudents 
    @StudentCode = 11, 
    @StudentName = 'John Doe', 
    @StudentAge = 19, 
    @DepartmentCode = 200;
GO

-- 3. Update one student's Age, Name, and Department
-- Changing student ID 1's name, age, and moving them to CyberSecurity (210)
EXEC sp_editStudent 
    @StudentCode = 1, 
    @StudentName = 'Trevor David Updated', 
    @StudentAge = 20, 
    @StudentDPcode = 210;
GO

-- 4. Get all students between ages 18 and 22
EXEC sp_getAllStudents;
GO

-- 5. Search for students belonging to a specific department (e.g., Department 200)
EXEC sp_SearchByDepartment 
    @DepartmentCode = 200;
GO

-- 6. Get Department Statistics (Count, Avg, Max, Min age grouped by department)
EXEC sp_DPstatics;
GO


-- Execute the Lowest & Highest procedure
EXEC sp_LowestnHighest;

drop procedure sp_LowestnHighest;

