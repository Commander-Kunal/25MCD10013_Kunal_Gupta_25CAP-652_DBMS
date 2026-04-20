-- Step 1: Create Table (Base Setup)
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT
);

-- Step 2: Insert Sample Data
INSERT INTO Employee VALUES
(1, 'Rahul', 30000),
(2, 'Priya', 35000),
(3, 'Amit', 40000),
(4, 'Neha', 45000),
(5, 'Karan', 38000),
(6, 'Simran', 42000),
(7, 'Arjun', 50000),
(8, 'Meera', 36000);

-- Step 3: Stored Procedure for INSERT Operation
CREATE OR REPLACE PROCEDURE add_employee(
    p_id INT,
    p_name VARCHAR,
    p_salary INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Employee(emp_id, name, salary)
    VALUES (p_id, p_name, p_salary);
END;
$$;

-- Step 4: Stored Procedure for UPDATE Operation
CREATE OR REPLACE PROCEDURE update_salary(
    p_id INT,
    p_salary INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Employee
    SET salary = p_salary
    WHERE emp_id = p_id;
END;
$$;

-- Step 5: Stored Procedure for DELETE Operation 
CREATE OR REPLACE PROCEDURE delete_employee(
    p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Employee
    WHERE emp_id = p_id;
END;
$$;

-- Step 6: Function for SELECT 
-- (As Stored Procedure donot directly return output in PostgreSQL)
CREATE OR REPLACE FUNCTION get_all_employee()
RETURNS TABLE(emp_id INT, name VARCHAR, salary INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Employee;
END;
$$;

-- Step 7: Calling Stored Procedures (Execution)
-- Insert
CALL add_employee(9, 'Rohan', 37000);

-- Update
CALL update_salary(2, 40000);

-- Delete
CALL delete_employee(3);

-- Select
SELECT * FROM get_all_employee();
