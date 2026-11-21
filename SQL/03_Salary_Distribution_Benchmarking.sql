
USE Compensation_Pay_Equity_DB;

-- Query 1: Overall Salary Distribution Summary

SELECT
    Compensation_Year,
    COUNT(*) AS Total_Records,
    ROUND(MIN(Base_Salary), 2) AS Minimum_Base_Salary,
    ROUND(MAX(Base_Salary), 2) AS Maximum_Base_Salary,
    ROUND(AVG(Base_Salary), 2) AS Average_Base_Salary,
    ROUND(AVG(Total_Compensation), 2) AS Average_Total_Compensation,
    ROUND(MAX(Base_Salary) - MIN(Base_Salary), 2)
        AS Base_Salary_Range
FROM Compensation
GROUP BY Compensation_Year
ORDER BY Compensation_Year;



-- Query 2: Salary Distribution by Salary Range
-- Using the latest compensation year (2026)

SELECT
    CASE
        WHEN Base_Salary < 500000 THEN 'Below 5 Lakhs'
        WHEN Base_Salary < 1000000 THEN '5-10 Lakhs'
        WHEN Base_Salary < 2000000 THEN '10-20 Lakhs'
        WHEN Base_Salary < 3000000 THEN '20-30 Lakhs'
        WHEN Base_Salary < 5000000 THEN '30-50 Lakhs'
        ELSE 'Above 50 Lakhs'
    END AS Salary_Range,
    COUNT(*) AS Total_Employees,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM Compensation
         WHERE Compensation_Year = 2026),
        2
    ) AS Employee_Percentage
FROM Compensation
WHERE Compensation_Year = 2026
GROUP BY Salary_Range
ORDER BY MIN(Base_Salary);



-- Query 3: Salary Band Compliance Analysis (2026)

SELECT
    CASE
        WHEN c.Base_Salary < sb.Band_Min
            THEN 'Below Band'
        WHEN c.Base_Salary > sb.Band_Max
            THEN 'Above Band'
        ELSE 'Within Band'
    END AS Salary_Band_Status,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM Compensation
         WHERE Compensation_Year = 2026),
        2
    ) AS Employee_Percentage

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY Salary_Band_Status
ORDER BY Total_Employees DESC;



-- Query 4: Employees Below Salary Band Minimum (2026)

SELECT
    e.Employee_ID,
    j.Department,
    j.Job_Title,
    j.Job_Level,
    e.Location,
    ROUND(c.Base_Salary, 2) AS Base_Salary,
    ROUND(sb.Band_Min, 2) AS Band_Minimum,
    ROUND(sb.Band_Min - c.Base_Salary, 2)
        AS Salary_Shortfall,
    ROUND(
        (sb.Band_Min - c.Base_Salary) * 100.0
        / sb.Band_Min,
        2
    ) AS Shortfall_Percentage
FROM Compensation c
JOIN Employees e
    ON c.Employee_ID = e.Employee_ID
JOIN Jobs j
    ON e.Job_ID = j.Job_ID
JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location
WHERE c.Compensation_Year = 2026
  AND c.Base_Salary < sb.Band_Min
ORDER BY Salary_Shortfall DESC;




-- Query 5: Total Salary Adjustment Required (2026)

SELECT
    COUNT(*) AS Employees_Below_Band,

    ROUND(
        SUM(sb.Band_Min - c.Base_Salary),
        2
    ) AS Total_Annual_Adjustment,

    ROUND(
        AVG(sb.Band_Min - c.Base_Salary),
        2
    ) AS Average_Adjustment_Per_Employee,

    ROUND(
        MAX(sb.Band_Min - c.Base_Salary),
        2
    ) AS Highest_Individual_Adjustment

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary < sb.Band_Min;
  
  
  
-- Query 6: Below-Band Employees by Department (2026)

SELECT
    j.Department,

    COUNT(*) AS Employees_Below_Band,

    ROUND(
        SUM(sb.Band_Min - c.Base_Salary),
        2
    ) AS Total_Salary_Shortfall,

    ROUND(
        AVG(sb.Band_Min - c.Base_Salary),
        2
    ) AS Average_Salary_Shortfall

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary < sb.Band_Min

GROUP BY j.Department

ORDER BY Total_Salary_Shortfall DESC;



-- Query 7: Below-Band Employees by Location (2026)

SELECT
    e.Location,

    COUNT(*) AS Employees_Below_Band,

    ROUND(
        SUM(sb.Band_Min - c.Base_Salary),
        2
    ) AS Total_Salary_Shortfall,

    ROUND(
        AVG(sb.Band_Min - c.Base_Salary),
        2
    ) AS Average_Salary_Shortfall

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary < sb.Band_Min

GROUP BY e.Location

ORDER BY Total_Salary_Shortfall DESC;



-- Query 8: Employees Above Salary Band Maximum (2026)

SELECT
    e.Employee_ID,
    j.Department,
    j.Job_Title,
    j.Job_Level,
    e.Location,

    ROUND(c.Base_Salary, 2) AS Base_Salary,

    ROUND(sb.Band_Max, 2) AS Band_Maximum,

    ROUND(
        c.Base_Salary - sb.Band_Max,
        2
    ) AS Amount_Above_Band,

    ROUND(
        (c.Base_Salary - sb.Band_Max) * 100.0
        / sb.Band_Max,
        2
    ) AS Above_Band_Percentage

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary > sb.Band_Max

ORDER BY Amount_Above_Band DESC;




-- Query 9: Salary Band Position Analysis (2026)

WITH Salary_Position AS (
    SELECT
        c.Employee_ID,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        ROUND(
            (c.Base_Salary - sb.Band_Min) * 100.0 /
            NULLIF(sb.Band_Max - sb.Band_Min, 0),
            2
        ) AS Band_Position_Pct

    FROM Compensation c

    JOIN Employees e
        ON c.Employee_ID = e.Employee_ID

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location

    WHERE c.Compensation_Year = 2026
)

SELECT
    CASE
        WHEN Band_Position_Pct < 0 THEN 'Below Band'
        WHEN Band_Position_Pct < 25 THEN 'Lower Quartile'
        WHEN Band_Position_Pct < 50 THEN 'Lower-Middle Quartile'
        WHEN Band_Position_Pct < 75 THEN 'Upper-Middle Quartile'
        WHEN Band_Position_Pct <= 100 THEN 'Upper Quartile'
        ELSE 'Above Band'
    END AS Band_Position_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Salary_Position),
        2
    ) AS Employee_Percentage

FROM Salary_Position

GROUP BY Band_Position_Category

ORDER BY MIN(Band_Position_Pct);



-- Query 10: Salary Compa-Ratio by Job Level (2026)

SELECT
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(sb.Band_Mid),
        2
    ) AS Avg_Band_Midpoint,

    ROUND(
        AVG(
            c.Base_Salary * 100.0 /
            NULLIF(sb.Band_Mid, 0)
        ),
        2
    ) AS Avg_Compa_Ratio_Pct

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY j.Job_Level

ORDER BY j.Job_Level;



