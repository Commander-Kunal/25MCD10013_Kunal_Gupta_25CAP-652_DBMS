CREATE TABLE Payroll (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2) CHECK(SALARY>0)
);


INSERT INTO Payroll VALUES
(1, 'Amit', 30000),
(2, 'Neha', 40000),
(3, 'Ravi', 50000);

SELECT * FROM Payroll;


-- using rollback
begin;

UPDATE Payroll
SET salary = -1000
WHERE emp_id = 3;

UPDATE Payroll
SET salary = 1000
WHERE emp_id = 3;

SELECT * FROM Payroll

ROLLBACK;

-- using savepoint

BEGIN;

-- Update 1
UPDATE Payroll
SET salary = salary +5000
WHERE emp_id = 1;

SAVEPOINT sp1;

-- Update 2
UPDATE Payroll
SET salary = salary +7000
WHERE emp_id = 2;

-- Error simulation
UPDATE Payroll
SET SALARY = -1000
WHERE emp_id = 3;

-- Rollback to savepoint 1
ROLLBACK TO sp1;

SELECT * FROM Payroll;

-- commit valid changes
COMMIT;
