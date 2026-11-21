
/*Strategic Compensation & Pay Equity Analytics

DATABASE:
Compensation_Pay_Equity_DB

TABLES:
1. Jobs
2. Employees
3. Salary_Bands
4. Compensation
5. Performance
6. Promotions

DESIGN PRINCIPLES:
- Use primary keys for unique records.
- Use foreign keys for relational integrity.
- Use DECIMAL for financial values.
- Allow NULL for missing Years_Experience.
- Retain Experience_Quality_Flag.
- Preserve cleaned employee-year records.
- Load cleaned data directly from Python.
*/



-- Step 2: Create  Database

CREATE DATABASE IF NOT EXISTS Compensation_Pay_Equity_DB;

-- Select the database
USE Compensation_Pay_Equity_DB;

-- Verify database creation
SELECT
    SCHEMA_NAME AS Database_Name
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'Compensation_Pay_Equity_DB';


-- 1. Jobs
CREATE TABLE IF NOT EXISTS Jobs (
    Job_ID VARCHAR(20) PRIMARY KEY,
    Job_Title VARCHAR(150) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Job_Family VARCHAR(100) NOT NULL,
    Job_Level INT NOT NULL,
    Min_Experience INT NOT NULL,
    Max_Experience INT NOT NULL
);

-- 2. Employees
CREATE TABLE IF NOT EXISTS Employees (
    Employee_ID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(20) NOT NULL,
    Age INT NOT NULL,
    Education_Level VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Hire_Date DATE NOT NULL,
    Years_Experience DECIMAL(5,1) NULL,
    Tenure_Years_2026 DECIMAL(5,1) NOT NULL,
    Job_ID VARCHAR(20) NOT NULL,
    Employment_Type VARCHAR(50) NOT NULL,
    Employment_Status VARCHAR(50) NOT NULL,
    Experience_Quality_Flag VARCHAR(20) NOT NULL,

    CONSTRAINT fk_employees_jobs
        FOREIGN KEY (Job_ID)
        REFERENCES Jobs(Job_ID)
);

-- 3. Salary Bands
CREATE TABLE IF NOT EXISTS Salary_Bands (
    Job_ID VARCHAR(20) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Job_Level INT NOT NULL,
    Band_Min DECIMAL(15,2) NOT NULL,
    Band_Mid DECIMAL(15,2) NOT NULL,
    Band_Max DECIMAL(15,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL,

    PRIMARY KEY (Job_ID, Location),

    CONSTRAINT fk_salary_bands_jobs
        FOREIGN KEY (Job_ID)
        REFERENCES Jobs(Job_ID)
);

-- 4. Compensation
CREATE TABLE IF NOT EXISTS Compensation (
    Employee_ID VARCHAR(20) NOT NULL,
    Compensation_Year INT NOT NULL,
    Base_Salary DECIMAL(15,2) NOT NULL,
    Annual_Bonus DECIMAL(15,2) NOT NULL,
    Allowances DECIMAL(15,2) NOT NULL,
    Total_Compensation DECIMAL(15,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL,

    PRIMARY KEY (Employee_ID, Compensation_Year),

    CONSTRAINT fk_compensation_employees
        FOREIGN KEY (Employee_ID)
        REFERENCES Employees(Employee_ID)
);


-- 5. Performance
CREATE TABLE IF NOT EXISTS Performance (
    Employee_ID VARCHAR(20) NOT NULL,
    Review_Year INT NOT NULL,
    Performance_Rating INT NOT NULL,
    Performance_Category VARCHAR(100) NOT NULL,

    PRIMARY KEY (Employee_ID, Review_Year),

    CONSTRAINT fk_performance_employees
        FOREIGN KEY (Employee_ID)
        REFERENCES Employees(Employee_ID)
);

-- 6. Promotions
CREATE TABLE IF NOT EXISTS Promotions (
    Employee_ID VARCHAR(20) NOT NULL,
    Promotion_Date DATE NOT NULL,
    Previous_Level INT NOT NULL,
    New_Level INT NOT NULL,
    Salary_Increase_Pct DECIMAL(6,2) NOT NULL,

    PRIMARY KEY (Employee_ID, Promotion_Date),

    CONSTRAINT fk_promotions_employees
        FOREIGN KEY (Employee_ID)
        REFERENCES Employees(Employee_ID)
);

-- Verify tables
SHOW TABLES;



USE Compensation_Pay_Equity_DB;

SELECT 'Jobs' AS Table_Name, COUNT(*) AS Total_Records
FROM Jobs

UNION ALL

SELECT 'Employees', COUNT(*)
FROM Employees

UNION ALL

SELECT 'Salary Bands', COUNT(*)
FROM Salary_Bands

UNION ALL

SELECT 'Compensation', COUNT(*)
FROM Compensation

UNION ALL

SELECT 'Performance', COUNT(*)
FROM Performance

UNION ALL

SELECT 'Promotions', COUNT(*)
FROM Promotions;




SELECT 'Employees without Jobs' AS Validation_Check,
       COUNT(*) AS Invalid_Records
FROM Employees e
LEFT JOIN Jobs j
    ON e.Job_ID = j.Job_ID
WHERE j.Job_ID IS NULL

UNION ALL

SELECT 'Salary Bands without Jobs',
       COUNT(*)
FROM Salary_Bands sb
LEFT JOIN Jobs j
    ON sb.Job_ID = j.Job_ID
WHERE j.Job_ID IS NULL

UNION ALL

SELECT 'Compensation without Employees',
       COUNT(*)
FROM Compensation c
LEFT JOIN Employees e
    ON c.Employee_ID = e.Employee_ID
WHERE e.Employee_ID IS NULL

UNION ALL

SELECT 'Performance without Employees',
       COUNT(*)
FROM Performance p
LEFT JOIN Employees e
    ON p.Employee_ID = e.Employee_ID
WHERE e.Employee_ID IS NULL

UNION ALL

SELECT 'Promotions without Employees',
       COUNT(*)
FROM Promotions pr
LEFT JOIN Employees e
    ON pr.Employee_ID = e.Employee_ID
WHERE e.Employee_ID IS NULL;





SELECT
    'Compensation without Performance' AS Validation_Check,
    COUNT(*) AS Unmatched_Records
FROM Compensation c
LEFT JOIN Performance p
    ON c.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year
WHERE p.Employee_ID IS NULL

UNION ALL

SELECT
    'Performance without Compensation',
    COUNT(*)
FROM Performance p
LEFT JOIN Compensation c
    ON p.Employee_ID = c.Employee_ID
   AND p.Review_Year = c.Compensation_Year
WHERE c.Employee_ID IS NULL;


