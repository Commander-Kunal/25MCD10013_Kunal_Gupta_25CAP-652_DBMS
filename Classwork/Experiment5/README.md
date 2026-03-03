# 👨‍🎓 Student Details

- Name: Kunal Gupta
- UID: 25MCD10013
- Branch: MCA (Data Science)
- Section: MCD-1(A)
- Semester: 2nd
- Subject: Technical Training
- Subject Code: 25CAP-652
- Date of Performance: 27 Feb. 2026


# 1️⃣ Experiment 5 


## 🎯 Aim of the Practical

- To gain hands-on experience in creating and using cursors for row-by-row processing in a database, enabling sequential access and manipulation of query results for complex business logic. 


## 💻 Tools Used

- PostgreSQL  


## 📌 Objectives of the Practical

-	Sequential Data Access: To understand how to fetch rows one by one from a result set using cursor mechanisms.
-	Row-Level Manipulation: To perform specific operations or calculations on individual records that require conditional procedural logic.
-	Resource Management: To learn the lifecycle of a cursor: Declaring, Opening, Fetching, and importantly, Closing and Deallocating to manage system memory.
-	Exception Handling: To handle cursor-related errors and performance considerations during large-scale data iteration. 


## 🛠️ Theory

- While SQL is generally set-oriented, certain tasks require a procedural approach where 	we process one row at a time. This is where Cursors are used:
  - Cursor Types: Cursors can be Implicit (managed by the system) or Explicit (defined by the developer). They can also be Forward-Only (moving only toward the end) or Scrollable (moving back and forth).
  - The Lifecycle: * DECLARE: Defines the SQL query for the cursor. 
      - OPEN: Executes the query and establishes the result set.
      - FETCH: Retrieves a specific row into variables for processing.
      - CLOSE: Releases the current result set.
      - DEALLOCATE: Removes the cursor definition from memory. 
  - Use Case: Cursors are ideal for generating row-specific reports, updating balances based on complex historical data, or migrating data where each record needs individual validation. 

# 🛠️ Practical / Experiment Steps

### Step 1: Implementing a Simple Forward-Only Cursor  
- Creating a cursor to loop through an Employee table and print individual records. 
  - Query:
~~~ sql
-- Query 1
-- Create Staff table
CREATE TABLE IF NOT EXISTS Staff (
    StaffID INT PRIMARY KEY,
    StaffName VARCHAR(50),
    MonthlyPay INT
);
-- Insert sample data
INSERT INTO Staff VALUES (101, 'Dr. Meera', 70000)
ON CONFLICT (StaffID) DO NOTHING;
INSERT INTO Staff VALUES (102, 'Nurse Karan', 45000)
ON CONFLICT (StaffID) DO NOTHING;
INSERT INTO Staff VALUES (103, 'Technician Isha', 38000)
ON CONFLICT (StaffID) DO NOTHING;
-- Cursor block
DO $$
DECLARE
    staff_record RECORD;
    staff_cursor CURSOR FOR
        SELECT StaffID, StaffName, MonthlyPay FROM Staff;
BEGIN
    OPEN staff_cursor;
    LOOP
        FETCH staff_cursor INTO staff_record;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'ID: %, Name: %, Monthly Pay: %',
        staff_record.StaffID,
        staff_record.StaffName,
        staff_record.MonthlyPay;
    END LOOP;
    CLOSE staff_cursor;
END $$;
 ~~~
Output: 
 
<img width="394" height="246" alt="Screenshot 2026-02-04 183757" src="https://github.com/user-attachments/assets/6e567898-d555-4ed2-ba94-ae6e66c74937" />

### Step 2: Complex Row-by-Row Manipulation  
- Using a cursor to update salaries based on a dynamic "Experience-to-Performance" ratio logic. 
  - Query:
~~~ sql 
-- Query 2
-- Add YearsOfService column
ALTER TABLE Staff
ADD COLUMN IF NOT EXISTS YearsOfService INT;
-- Update sample service values
UPDATE Staff SET YearsOfService = 3 WHERE StaffID = 101;
UPDATE Staff SET YearsOfService = 6 WHERE StaffID = 102;
UPDATE Staff SET YearsOfService = 9 WHERE StaffID = 103;
-- Cursor to update salary based on years of service
DO $$
DECLARE
    staff_record RECORD;
    staff_cursor CURSOR FOR
        SELECT StaffID, MonthlyPay, YearsOfService FROM Staff;
BEGIN
    OPEN staff_cursor;
    LOOP
        FETCH staff_cursor INTO staff_record;
        EXIT WHEN NOT FOUND;
        -- Salary update logic
        IF staff_record.YearsOfService >= 8 THEN
            UPDATE Staff
            SET MonthlyPay = MonthlyPay + 8000
            WHERE StaffID = staff_record.StaffID;
        ELSIF staff_record.YearsOfService >= 5 THEN
            UPDATE Staff
            SET MonthlyPay = MonthlyPay + 5000
            WHERE StaffID = staff_record.StaffID;
        ELSE
            UPDATE Staff
            SET MonthlyPay = MonthlyPay + 2000
            WHERE StaffID = staff_record.StaffID;
        END IF;
    END LOOP;
    CLOSE staff_cursor;
END $$;
-- View updated table
SELECT * FROM Staff;
~~~
Output:  
<img width="1028" height="245" alt="image" src="https://github.com/user-attachments/assets/edc6daa6-1600-4ccf-939a-58d8377c526e" />
 
### Step 3: Exception and Status Handling 
- Ensuring the cursor handles empty result sets or termination signals gracefully. 
  - Query:
~~~ sql
-- Query 3
DO $$
DECLARE
    staff_record RECORD;
    staff_cursor CURSOR FOR
        SELECT StaffID, StaffName, MonthlyPay FROM Staff;
BEGIN
    OPEN staff_cursor;
    -- Check if cursor has data
    FETCH staff_cursor INTO staff_record;
    IF NOT FOUND THEN
        RAISE NOTICE 'No records found in Staff table.';
    ELSE
        LOOP
            RAISE NOTICE 'Processing Staff ID: %, Name: %, Monthly Pay: %',
            staff_record.StaffID,
            staff_record.StaffName,
            staff_record.MonthlyPay;
            FETCH staff_cursor INTO staff_record;
            EXIT WHEN NOT FOUND;
        END LOOP;
    END IF;
    CLOSE staff_cursor;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred: %', SQLERRM;
END $$;
~~~
Output: 
  <img width="1052" height="150" alt="image" src="https://github.com/user-attachments/assets/d2590e50-b08b-4374-997c-e3ec226bb159" />
