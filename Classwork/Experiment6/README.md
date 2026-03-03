# 👨‍🎓 Student Details

- Name: Kunal Gupta
- UID: 25MCD10013
- Branch: MCA (Data Science)
- Section: MCD-1(A)
- Semester: 2nd
- Subject: Technical Training
- Subject Code: 25CAP-652
- Date of Performance: 27 Feb. 2026


# 1️⃣ Experiment 6


## 🎯 Aim of the Practical

- Learn how to create, query, and manage views in SQL to simplify database queries and provide a layer of abstraction for end-users. 


## 💻 Tools Used

- PostgreSQL  


## 📌 Objectives of the Practical

-	Data Abstraction: To understand how to hide complex table joins and calculations behind a simple virtual table interface. 
- Enhanced Security: To learn how to restrict user access to sensitive columns by providing views instead of direct table access. 
- Query Simplification: To master the creation of views that pre-join multiple tables, making reporting easier for non-technical users. 
- View Management: To understand the syntax for creating, altering, and dropping views, as well as the naming conventions required for efficient data access. 



## 🛠️ Theory
- A View is essentially a virtual table based on the result-set of an SQL statement. It does not contain data of its own but dynamically pulls data from the underlying "base tables". 
  - Simple Views: Created from a single table without any aggregate functions or grouping. These are often updatable.
  - Complex Views: Created from multiple tables using JOINs, or including GROUP BY and aggregate functions. These provide a consolidated summary of the database.
  - Security Layer: In enterprise environments, views are used to grant permissions on specific subsets of data. For example, a "SalaryView" might exclude the "Employee_SSN" or "Home_Address" columns for privacy.
  - Benefits: They simplify the user experience, ensure data consistency across reports, and reduce the risk of accidental data modification by providing read-only abstractions. 


# 🛠️ Practical / Experiment Steps

### Step 1: Creating a Simple View for Data Filtering 
- Query:
~~~ sql 
-- Query 1

-- Create Student table
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    Marks INT,
    EnrollmentStatus VARCHAR(20)
);

-- Insert sample data
INSERT INTO Student VALUES (201, 'Arjun', 78, 'Enrolled')
ON CONFLICT (StudentID) DO NOTHING;

INSERT INTO Student VALUES (202, 'Sneha', 85, 'Dropped')
ON CONFLICT (StudentID) DO NOTHING;

INSERT INTO Student VALUES (203, 'Ritika', 91, 'Enrolled')
ON CONFLICT (StudentID) DO NOTHING;

-- Create View to show only Enrolled Students
CREATE OR REPLACE VIEW EnrolledStudents AS
SELECT StudentID, StudentName, Marks
FROM Student
WHERE EnrollmentStatus = 'Enrolled';

-- Query the View
SELECT * FROM EnrolledStudents;SELECT *
~~~
- Output:
 <img width="717" height="188" alt="image" src="https://github.com/user-attachments/assets/00c66980-2d82-46c5-87ca-8dbff1d59637" />
  
### Step 2: Creating a View for Joining Multiple Tables  
- Query:
~~~ sql
-- Query 2
-- Create Course table
CREATE TABLE IF NOT EXISTS Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50)
);
-- Insert sample courses
INSERT INTO Course VALUES (501, 'Computer Science')
ON CONFLICT (CourseID) DO NOTHING;
INSERT INTO Course VALUES (502, 'Mathematics')
ON CONFLICT (CourseID) DO NOTHING;
INSERT INTO Course VALUES (503, 'Physics')
ON CONFLICT (CourseID) DO NOTHING;
-- Add CourseID column to Student table
ALTER TABLE Student
ADD COLUMN IF NOT EXISTS CourseID INT;
-- Assign courses to students
UPDATE Student SET CourseID = 501 WHERE StudentID = 201;
UPDATE Student SET CourseID = 502 WHERE StudentID = 202;
UPDATE Student SET CourseID = 503 WHERE StudentID = 203;
-- Create View joining Student and Course
CREATE OR REPLACE VIEW StudentCourseView AS
SELECT 
    s.StudentID,
    s.StudentName,
    s.Marks,
    c.CourseName
FROM Student s
JOIN Course c
ON s.CourseID = c.CourseID;
-- Query the View
SELECT * FROM StudentCourseView;
~~~
- Output: 
  <img width="1024" height="255" alt="image" src="https://github.com/user-attachments/assets/84246889-054c-4f70-ae4d-8dd79f177664" />

### Step 3: Advanced Summarization View 
- Query:
~~~ sql  
-- Query 3
-- Create summarization view showing course statistics
CREATE OR REPLACE VIEW CourseSummaryView AS
SELECT 
    c.CourseName,
    COUNT(s.StudentID) AS TotalStudents,
    AVG(s.Marks) AS AverageMarks,
    SUM(s.Marks) AS TotalMarks
FROM Student s
JOIN Course c
ON s.CourseID = c.CourseID
GROUP BY c.CourseName;

-- Query the View
SELECT * FROM CourseSummaryView;
~~~
- Output: 
  <img width="1054" height="240" alt="image" src="https://github.com/user-attachments/assets/d72c8d96-5f12-4c79-9c57-9d91946346b0" />
