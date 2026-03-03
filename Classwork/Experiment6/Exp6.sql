
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
SELECT * FROM EnrolledStudents;

------------------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------------------------------------

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
