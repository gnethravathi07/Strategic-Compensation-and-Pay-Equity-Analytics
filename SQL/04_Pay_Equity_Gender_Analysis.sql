
USE Compensation_Pay_Equity_DB;

-- Query 1: Average Compensation by Gender (2026)

SELECT
    e.Gender,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(c.Annual_Bonus),
        2
    ) AS Avg_Annual_Bonus,

    ROUND(
        AVG(c.Allowances),
        2
    ) AS Avg_Allowances,

    ROUND(
        AVG(c.Total_Compensation),
        2
    ) AS Avg_Total_Compensation

FROM Employees e

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026

GROUP BY e.Gender

ORDER BY Avg_Total_Compensation DESC;



-- Query 2: Gender Pay Gap Percentage Analysis (2026)

WITH Gender_Compensation AS (
    SELECT
        e.Gender,
        AVG(c.Base_Salary) AS Avg_Base_Salary,
        AVG(c.Total_Compensation) AS Avg_Total_Compensation
    FROM Employees e
    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')
    GROUP BY e.Gender
)

SELECT
    ROUND(
        MAX(CASE WHEN Gender = 'Male'
            THEN Avg_Base_Salary END),
        2
    ) AS Male_Avg_Base_Salary,

    ROUND(
        MAX(CASE WHEN Gender = 'Female'
            THEN Avg_Base_Salary END),
        2
    ) AS Female_Avg_Base_Salary,

    ROUND(
        (
            MAX(CASE WHEN Gender = 'Male'
                THEN Avg_Base_Salary END)
            -
            MAX(CASE WHEN Gender = 'Female'
                THEN Avg_Base_Salary END)
        ) * 100.0
        /
        NULLIF(
            MAX(CASE WHEN Gender = 'Male'
                THEN Avg_Base_Salary END),
            0
        ),
        2
    ) AS Base_Salary_Gap_Pct,

    ROUND(
        (
            MAX(CASE WHEN Gender = 'Male'
                THEN Avg_Total_Compensation END)
            -
            MAX(CASE WHEN Gender = 'Female'
                THEN Avg_Total_Compensation END)
        ) * 100.0
        /
        NULLIF(
            MAX(CASE WHEN Gender = 'Male'
                THEN Avg_Total_Compensation END),
            0
        ),
        2
    ) AS Total_Compensation_Gap_Pct

FROM Gender_Compensation;



-- Query 3: Gender Pay Gap by Job Level (2026)

SELECT
    j.Job_Level,

    COUNT(CASE WHEN e.Gender = 'Male'
        THEN 1 END) AS Male_Employees,

    COUNT(CASE WHEN e.Gender = 'Female'
        THEN 1 END) AS Female_Employees,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END),
        2
    ) AS Male_Avg_Salary,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END),
        2
    ) AS Female_Avg_Salary,

    ROUND(
        (
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END)
            -
            AVG(CASE WHEN e.Gender = 'Female'
                THEN c.Base_Salary END)
        ) * 100.0
        /
        NULLIF(
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END),
            0
        ),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026
  AND e.Gender IN ('Male', 'Female')

GROUP BY j.Job_Level

ORDER BY j.Job_Level;




-- Query 4: Gender Pay Gap by Department (2026)

SELECT
    j.Department,

    COUNT(CASE WHEN e.Gender = 'Male'
        THEN 1 END) AS Male_Employees,

    COUNT(CASE WHEN e.Gender = 'Female'
        THEN 1 END) AS Female_Employees,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END),
        2
    ) AS Male_Avg_Salary,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END),
        2
    ) AS Female_Avg_Salary,

    ROUND(
        (
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END)
            -
            AVG(CASE WHEN e.Gender = 'Female'
                THEN c.Base_Salary END)
        ) * 100.0
        /
        NULLIF(
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END),
            0
        ),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

WHERE c.Compensation_Year = 2026
  AND e.Gender IN ('Male', 'Female')

GROUP BY j.Department

ORDER BY Gender_Pay_Gap_Pct DESC;



-- Query 5: Gender Pay Gap by Location (2026)

SELECT
    e.Location,

    COUNT(CASE WHEN e.Gender = 'Male'
        THEN 1 END) AS Male_Employees,

    COUNT(CASE WHEN e.Gender = 'Female'
        THEN 1 END) AS Female_Employees,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END),
        2
    ) AS Male_Avg_Salary,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END),
        2
    ) AS Female_Avg_Salary,

    ROUND(
        (
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END)
            -
            AVG(CASE WHEN e.Gender = 'Female'
                THEN c.Base_Salary END)
        ) * 100.0
        /
        NULLIF(
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END),
            0
        ),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Employees e

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
    
    


USE Compensation_Pay_Equity_DB;

-- Query 6: Gender Pay Gap by Job Level and Location

WITH Gender_Salary AS (
    SELECT
        j.Job_Level,
        e.Location,

        SUM(CASE WHEN e.Gender = 'Male'
            THEN 1 ELSE 0 END) AS Male_Employees,

        SUM(CASE WHEN e.Gender = 'Female'
            THEN 1 ELSE 0 END) AS Female_Employees,

        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END) AS Male_Avg_Salary,

        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END) AS Female_Avg_Salary

    FROM Employees e
    INNER JOIN Jobs j
        ON e.Job_ID = j.Job_ID
    INNER JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')

    GROUP BY j.Job_Level, e.Location
)

SELECT
    Job_Level,
    Location,
    Male_Employees,
    Female_Employees,
    ROUND(Male_Avg_Salary, 2) AS Male_Avg_Salary,
    ROUND(Female_Avg_Salary, 2) AS Female_Avg_Salary,

    ROUND(
        (Male_Avg_Salary - Female_Avg_Salary)
        * 100.0 / NULLIF(Male_Avg_Salary, 0),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Gender_Salary

WHERE Male_Employees > 0
  AND Female_Employees > 0

ORDER BY Job_Level, Location;




-- Query 7: Gender Pay Gap by Job Title (2026)

WITH Job_Gender_Salary AS (
    SELECT
        j.Job_Title,
        j.Department,
        j.Job_Level,

        SUM(CASE WHEN e.Gender = 'Male'
            THEN 1 ELSE 0 END) AS Male_Employees,

        SUM(CASE WHEN e.Gender = 'Female'
            THEN 1 ELSE 0 END) AS Female_Employees,

        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END) AS Male_Avg_Salary,

        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END) AS Female_Avg_Salary

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')

    GROUP BY
        j.Job_ID,
        j.Job_Title,
        j.Department,
        j.Job_Level
)

SELECT
    Job_Title,
    Department,
    Job_Level,
    Male_Employees,
    Female_Employees,

    ROUND(Male_Avg_Salary, 2) AS Male_Avg_Salary,
    ROUND(Female_Avg_Salary, 2) AS Female_Avg_Salary,

    ROUND(
        (Male_Avg_Salary - Female_Avg_Salary)
        * 100.0 / NULLIF(Male_Avg_Salary, 0),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Job_Gender_Salary

WHERE Male_Employees >= 5
  AND Female_Employees >= 5

ORDER BY Gender_Pay_Gap_Pct DESC;




-- Query 8: Gender Pay Gap by Job Title and Location (2026)

WITH Gender_Salary AS (
    SELECT
        j.Job_Title,
        j.Department,
        e.Location,

        SUM(CASE WHEN e.Gender = 'Male'
            THEN 1 ELSE 0 END) AS Male_Employees,

        SUM(CASE WHEN e.Gender = 'Female'
            THEN 1 ELSE 0 END) AS Female_Employees,

        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END) AS Male_Avg_Salary,

        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END) AS Female_Avg_Salary

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')

    GROUP BY
        j.Job_ID,
        j.Job_Title,
        j.Department,
        e.Location
)

SELECT
    Job_Title,
    Department,
    Location,
    Male_Employees,
    Female_Employees,

    ROUND(Male_Avg_Salary, 2) AS Male_Avg_Salary,
    ROUND(Female_Avg_Salary, 2) AS Female_Avg_Salary,

    ROUND(
        (Male_Avg_Salary - Female_Avg_Salary)
        * 100.0 / NULLIF(Male_Avg_Salary, 0),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Gender_Salary

WHERE Male_Employees >= 5
  AND Female_Employees >= 5

ORDER BY Gender_Pay_Gap_Pct DESC;




-- Query 9: Gender Pay Gap Summary by Comparable Groups (2026)

WITH Gender_Salary AS (
    SELECT
        j.Job_ID,
        e.Location,

        SUM(CASE WHEN e.Gender = 'Male'
            THEN 1 ELSE 0 END) AS Male_Employees,

        SUM(CASE WHEN e.Gender = 'Female'
            THEN 1 ELSE 0 END) AS Female_Employees,

        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END) AS Male_Avg_Salary,

        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END) AS Female_Avg_Salary

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')

    GROUP BY j.Job_ID, e.Location
),

Pay_Gaps AS (
    SELECT
        (Male_Avg_Salary - Female_Avg_Salary)
        * 100.0 / NULLIF(Male_Avg_Salary, 0)
        AS Gender_Pay_Gap_Pct

    FROM Gender_Salary

    WHERE Male_Employees >= 5
      AND Female_Employees >= 5
)

SELECT
    CASE
        WHEN Gender_Pay_Gap_Pct > 0
            THEN 'Positive Gap'
        WHEN Gender_Pay_Gap_Pct < 0
            THEN 'Negative Gap'
        ELSE 'Zero Gap'
    END AS Pay_Gap_Category,

    COUNT(*) AS Total_Groups,

    ROUND(
        AVG(Gender_Pay_Gap_Pct),
        2
    ) AS Avg_Gap_Pct

FROM Pay_Gaps

GROUP BY Pay_Gap_Category

ORDER BY Total_Groups DESC;




-- Query 10: Gender Pay Gap by Performance Rating (2026)

SELECT
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(CASE WHEN e.Gender = 'Male'
        THEN 1 END) AS Male_Employees,

    COUNT(CASE WHEN e.Gender = 'Female'
        THEN 1 END) AS Female_Employees,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END),
        2
    ) AS Male_Avg_Salary,

    ROUND(
        AVG(CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END),
        2
    ) AS Female_Avg_Salary,

    ROUND(
        (
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END)
            -
            AVG(CASE WHEN e.Gender = 'Female'
                THEN c.Base_Salary END)
        ) * 100.0
        /
        NULLIF(
            AVG(CASE WHEN e.Gender = 'Male'
                THEN c.Base_Salary END),
            0
        ),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Employees e

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Performance p
    ON e.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year

WHERE c.Compensation_Year = 2026
  AND e.Gender IN ('Male', 'Female')

GROUP BY
    p.Performance_Rating,
    p.Performance_Category

ORDER BY p.Performance_Rating;




