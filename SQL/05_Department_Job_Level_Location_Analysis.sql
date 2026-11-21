
USE Compensation_Pay_Equity_DB;

-- Query 1: Department-Wise Average Salary by Job Level (2026)

SELECT
    j.Department,
    j.Job_Level,

    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(c.Total_Compensation),
        2
    ) AS Avg_Total_Compensation,

    ROUND(
        MIN(c.Base_Salary),
        2
    ) AS Minimum_Base_Salary,

    ROUND(
        MAX(c.Base_Salary),
        2
    ) AS Maximum_Base_Salary

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY
    j.Department,
    j.Job_Level

ORDER BY
    j.Department,
    j.Job_Level;
    
    
    

-- Query 2: Department-Wise Salary Compa-Ratio (2026)

SELECT
    j.Department,

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

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY j.Department

ORDER BY Avg_Compa_Ratio_Pct DESC;




-- Query 3: Salary Compa-Ratio by Department and Job Level (2026)

SELECT
    j.Department,
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

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY
    j.Department,
    j.Job_Level

ORDER BY
    j.Department,
    j.Job_Level;
    
    



-- Query 4: Location-Wise Salary Compa-Ratio (2026)

SELECT
    e.Location,

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

FROM Employees e

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY e.Location

ORDER BY Avg_Compa_Ratio_Pct DESC;




-- Query 5: Salary Compa-Ratio by Location and Job Level (2026)

SELECT
    e.Location,
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

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY
    e.Location,
    j.Job_Level

ORDER BY
    e.Location,
    j.Job_Level;




-- Query 6: Salary Variation Within Job Levels (2026)

SELECT
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    ROUND(
        MIN(c.Base_Salary),
        2
    ) AS Minimum_Base_Salary,

    ROUND(
        MAX(c.Base_Salary),
        2
    ) AS Maximum_Base_Salary,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Average_Base_Salary,

    ROUND(
        STDDEV_POP(c.Base_Salary),
        2
    ) AS Salary_Standard_Deviation,

    ROUND(
        MAX(c.Base_Salary) - MIN(c.Base_Salary),
        2
    ) AS Salary_Range

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY j.Job_Level

ORDER BY j.Job_Level;




-- Query 7: Coefficient of Variation by Job Level (2026)

SELECT
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        STDDEV_POP(c.Base_Salary),
        2
    ) AS Salary_Standard_Deviation,

    ROUND(
        STDDEV_POP(c.Base_Salary) * 100.0 /
        NULLIF(AVG(c.Base_Salary), 0),
        2
    ) AS Coefficient_of_Variation_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY j.Job_Level

ORDER BY Coefficient_of_Variation_Pct DESC;




-- Query 8: Salary Variation by Department and Job Level (2026)

SELECT
    j.Department,
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        STDDEV_POP(c.Base_Salary),
        2
    ) AS Salary_Standard_Deviation,

    ROUND(
        STDDEV_POP(c.Base_Salary) * 100.0 /
        NULLIF(AVG(c.Base_Salary), 0),
        2
    ) AS Coefficient_of_Variation_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY
    j.Department,
    j.Job_Level

ORDER BY
    Coefficient_of_Variation_Pct DESC;





-- Query 9: Salary Variation by Location and Job Level (2026)

SELECT
    e.Location,
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        STDDEV_POP(c.Base_Salary),
        2
    ) AS Salary_Standard_Deviation,

    ROUND(
        STDDEV_POP(c.Base_Salary) * 100.0 /
        NULLIF(AVG(c.Base_Salary), 0),
        2
    ) AS Coefficient_of_Variation_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY
    e.Location,
    j.Job_Level

ORDER BY
    Coefficient_of_Variation_Pct DESC;





-- Query 10: Department Salary Ranking Within Job Levels (2026)

WITH Department_Salary AS (
    SELECT
        j.Department,
        j.Job_Level,

        COUNT(*) AS Total_Employees,

        ROUND(
            AVG(c.Base_Salary),
            2
        ) AS Avg_Base_Salary

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026

    GROUP BY
        j.Department,
        j.Job_Level
)

SELECT
    Department,
    Job_Level,
    Total_Employees,
    Avg_Base_Salary,

    DENSE_RANK() OVER (
        PARTITION BY Job_Level
        ORDER BY Avg_Base_Salary DESC
    ) AS Salary_Rank

FROM Department_Salary

ORDER BY
    Job_Level,
    Salary_Rank;





