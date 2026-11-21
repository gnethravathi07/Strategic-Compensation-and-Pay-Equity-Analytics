
USE Compensation_Pay_Equity_DB;

SELECT
    Employment_Status,
    COUNT(*) AS Total_Employees,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Employees),
        2
    ) AS Workforce_Percentage
FROM Employees
GROUP BY Employment_Status
ORDER BY Total_Employees DESC;



-- Query 2: Workforce Distribution by Department

SELECT
    j.Department,
    COUNT(e.Employee_ID) AS Total_Employees,
    ROUND(
        COUNT(e.Employee_ID) * 100.0 /
        (SELECT COUNT(*) FROM Employees),
        2
    ) AS Workforce_Percentage
FROM Employees e
JOIN Jobs j
    ON e.Job_ID = j.Job_ID
GROUP BY j.Department
ORDER BY Total_Employees DESC;



-- Query 3: Workforce Distribution by Job Level

SELECT
    j.Job_Level,
    COUNT(e.Employee_ID) AS Total_Employees,
    ROUND(
        COUNT(e.Employee_ID) * 100.0 /
        (SELECT COUNT(*) FROM Employees),
        2
    ) AS Workforce_Percentage
FROM Employees e
JOIN Jobs j
    ON e.Job_ID = j.Job_ID
GROUP BY j.Job_Level
ORDER BY j.Job_Level;



-- Query 4: Workforce Distribution by Gender

SELECT
    Gender,
    COUNT(*) AS Total_Employees,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Employees),
        2
    ) AS Workforce_Percentage
FROM Employees
GROUP BY Gender
ORDER BY Total_Employees DESC;



-- Query 5: Workforce Distribution by Location

SELECT
    Location,
    COUNT(*) AS Total_Employees,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Employees),
        2
    ) AS Workforce_Percentage
FROM Employees
GROUP BY Location
ORDER BY Total_Employees DESC;



-- Query 6: Overall Compensation Summary

SELECT
    COUNT(*) AS Total_Compensation_Records,
    COUNT(DISTINCT Employee_ID) AS Employees_With_Compensation,
    ROUND(SUM(Total_Compensation), 2) AS Total_Compensation_Expenditure,
    ROUND(AVG(Total_Compensation), 2) AS Avg_Annual_Compensation,
    ROUND(AVG(Base_Salary), 2) AS Avg_Base_Salary,
    ROUND(AVG(Annual_Bonus), 2) AS Avg_Annual_Bonus,
    ROUND(AVG(Allowances), 2) AS Avg_Allowances
FROM Compensation;


-- Query 7: Compensation Summary by Year

SELECT
    Compensation_Year,
    COUNT(DISTINCT Employee_ID) AS Total_Employees,
    ROUND(SUM(Total_Compensation), 2) AS Total_Compensation,
    ROUND(AVG(Total_Compensation), 2) AS Avg_Annual_Compensation,
    ROUND(AVG(Base_Salary), 2) AS Avg_Base_Salary
FROM Compensation
GROUP BY Compensation_Year
ORDER BY Compensation_Year;



-- Query 8: Compensation Distribution by Department

SELECT
    j.Department,
    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,
    ROUND(SUM(c.Total_Compensation), 2) AS Total_Compensation,
    ROUND(AVG(c.Total_Compensation), 2) AS Avg_Annual_Compensation
FROM Employees e
JOIN Jobs j
    ON e.Job_ID = j.Job_ID
JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
GROUP BY j.Department
ORDER BY Total_Compensation DESC;


-- Query 9: Compensation Distribution by Job Level

SELECT
    j.Job_Level,
    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,
    ROUND(SUM(c.Total_Compensation), 2) AS Total_Compensation,
    ROUND(AVG(c.Total_Compensation), 2) AS Avg_Annual_Compensation,
    ROUND(AVG(c.Base_Salary), 2) AS Avg_Base_Salary
FROM Employees e
JOIN Jobs j
    ON e.Job_ID = j.Job_ID
JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
GROUP BY j.Job_Level
ORDER BY j.Job_Level;



-- Query 10: Compensation Distribution by Location

SELECT
    e.Location,
    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,
    ROUND(SUM(c.Total_Compensation), 2) AS Total_Compensation,
    ROUND(AVG(c.Total_Compensation), 2) AS Avg_Annual_Compensation,
    ROUND(AVG(c.Base_Salary), 2) AS Avg_Base_Salary
FROM Employees e
JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
GROUP BY e.Location
ORDER BY Total_Compensation DESC;












