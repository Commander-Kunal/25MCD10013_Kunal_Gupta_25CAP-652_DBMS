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

------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------
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
