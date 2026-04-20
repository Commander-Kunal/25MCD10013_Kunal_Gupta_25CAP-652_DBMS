-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id)
);

-- Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Students
INSERT INTO Students VALUES 
(1, 'Rahul', 101),
(2, 'Priya', 102),
(3, 'Amit', 101),
(4, 'Neha', 103);

-- Courses
INSERT INTO Courses VALUES 
(201, 'DBMS'),
(202, 'AI'),
(203, 'ML');

-- Enrollments
INSERT INTO Enrollments VALUES 
(1, 201),
(1, 202),
(2, 202),
(3, 203);

-- Departments
INSERT INTO Departments VALUES 
(101, 'CSE'),
(102, 'IT'),
(103, 'ECE');


-- INNER JOIN Query
SELECT s.name AS student_name, c.course_name
FROM Students s
INNER JOIN Enrollments e 
    ON s.student_id = e.student_id
INNER JOIN Courses c 
    ON e.course_id = c.course_id;


-- LEFT JOIN Query
SELECT s.name AS student_name
FROM Students s
LEFT JOIN Enrollments e 
    ON s.student_id = e.student_id
WHERE e.course_id IS NULL;


-- RIGHT JOIN Query
SELECT c.course_name, s.name AS student_name
FROM Students s
RIGHT JOIN Enrollments e 
    ON s.student_id = e.student_id
RIGHT JOIN Courses c 
    ON e.course_id = c.course_id;


-- MULTIPLE JOIN Query
SELECT s.name AS student_name, d.dept_name
FROM Students s
JOIN Departments d 
    ON s.dept_id = d.dept_id;


-- CROSS JOIN Query
SELECT s.name AS student_name, c.course_name
FROM Students s
CROSS JOIN Courses c;
