
USE Compensation_Pay_Equity_DB;

-- Query 1: Average Compensation by Performance Rating (2026)

SELECT
    p.Performance_Rating,
    p.Performance_Category,

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

FROM Compensation c

JOIN Performance p
    ON c.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year

WHERE c.Compensation_Year = 2026

GROUP BY
    p.Performance_Rating,
    p.Performance_Category

ORDER BY p.Performance_Rating;



-- Query 2: Annual Bonus Percentage by Performance Rating (2026)

SELECT
    p.Performance_Rating,
    p.Performance_Category,

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
        AVG(
            c.Annual_Bonus * 100.0 /
            NULLIF(c.Base_Salary, 0)
        ),
        2
    ) AS Avg_Bonus_Percentage

FROM Compensation c

JOIN Performance p
    ON c.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year

WHERE c.Compensation_Year = 2026

GROUP BY
    p.Performance_Rating,
    p.Performance_Category

ORDER BY p.Performance_Rating;




-- Query 3: Bonus Percentage by Performance Rating and Job Level (2026)

SELECT
    j.Job_Level,
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Annual_Bonus),
        2
    ) AS Avg_Annual_Bonus,

    ROUND(
        AVG(
            c.Annual_Bonus * 100.0 /
            NULLIF(c.Base_Salary, 0)
        ),
        2
    ) AS Avg_Bonus_Percentage

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Performance p
    ON c.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year

WHERE c.Compensation_Year = 2026

GROUP BY
    j.Job_Level,
    p.Performance_Rating,
    p.Performance_Category

ORDER BY
    j.Job_Level,
    p.Performance_Rating;




-- Query 4: Bonus Contribution to Total Compensation by Job Level (2026)

SELECT
    j.Job_Level,

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
        AVG(c.Total_Compensation),
        2
    ) AS Avg_Total_Compensation,

    ROUND(
        AVG(
            c.Annual_Bonus * 100.0 /
            NULLIF(c.Total_Compensation, 0)
        ),
        2
    ) AS Avg_Bonus_Share_Pct

FROM Compensation c

JOIN Employees e
    ON c.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

WHERE c.Compensation_Year = 2026

GROUP BY j.Job_Level

ORDER BY j.Job_Level;





-- Query 5: Performance Rating Distribution by Job Level (2026)

WITH Performance_Counts AS (
    SELECT
        j.Job_Level,
        p.Performance_Rating,
        p.Performance_Category,

        COUNT(*) AS Total_Employees

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Performance p
        ON e.Employee_ID = p.Employee_ID

    WHERE p.Review_Year = 2026

    GROUP BY
        j.Job_Level,
        p.Performance_Rating,
        p.Performance_Category
)

SELECT
    Job_Level,
    Performance_Rating,
    Performance_Category,
    Total_Employees,

    ROUND(
        Total_Employees * 100.0 /
        SUM(Total_Employees) OVER (
            PARTITION BY Job_Level
        ),
        2
    ) AS Rating_Percentage

FROM Performance_Counts

ORDER BY
    Job_Level,
    Performance_Rating;




-- Query 6: High-Performance Employee Percentage by Department (2026)

SELECT
    j.Department,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN p.Performance_Rating >= 4
            THEN 1
            ELSE 0
        END
    ) AS High_Performers,

    ROUND(
        SUM(
            CASE
                WHEN p.Performance_Rating >= 4
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS High_Performer_Percentage,

    ROUND(
        AVG(p.Performance_Rating),
        2
    ) AS Avg_Performance_Rating

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Performance p
    ON e.Employee_ID = p.Employee_ID

WHERE p.Review_Year = 2026

GROUP BY j.Department

ORDER BY High_Performer_Percentage DESC;





-- Query 7: Bonus Percentage by Department and Performance Rating (2026)

SELECT
    j.Department,
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Annual_Bonus),
        2
    ) AS Avg_Annual_Bonus,

    ROUND(
        AVG(
            c.Annual_Bonus * 100.0 /
            NULLIF(c.Base_Salary, 0)
        ),
        2
    ) AS Avg_Bonus_Percentage

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Performance p
    ON c.Employee_ID = p.Employee_ID
   AND c.Compensation_Year = p.Review_Year

WHERE c.Compensation_Year = 2026

GROUP BY
    j.Department,
    p.Performance_Rating,
    p.Performance_Category

ORDER BY
    j.Department,
    p.Performance_Rating;




-- Query 8: High Performers vs Other Employees (2026)

WITH Employee_Performance AS (
    SELECT
        c.Employee_ID,
        c.Base_Salary,
        c.Annual_Bonus,
        c.Total_Compensation,

        CASE
            WHEN p.Performance_Rating >= 4
                THEN 'High Performers'
            ELSE 'Other Employees'
        END AS Performance_Group

    FROM Compensation c

    JOIN Performance p
        ON c.Employee_ID = p.Employee_ID
       AND c.Compensation_Year = p.Review_Year

    WHERE c.Compensation_Year = 2026
)

SELECT
    Performance_Group,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Base_Salary),
        2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Annual_Bonus),
        2
    ) AS Avg_Annual_Bonus,

    ROUND(
        AVG(Total_Compensation),
        2
    ) AS Avg_Total_Compensation,

    ROUND(
        AVG(
            Annual_Bonus * 100.0 /
            NULLIF(Base_Salary, 0)
        ),
        2
    ) AS Avg_Bonus_Percentage

FROM Employee_Performance

GROUP BY Performance_Group

ORDER BY Avg_Bonus_Percentage DESC;





-- Query 9: High Performer Bonus Comparison by Job Level (2026)

WITH Employee_Bonus AS (
    SELECT
        j.Job_Level,

        CASE
            WHEN p.Performance_Rating >= 4
                THEN 'High Performers'
            ELSE 'Other Employees'
        END AS Performance_Group,

        c.Base_Salary,
        c.Annual_Bonus,
        c.Total_Compensation

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    JOIN Performance p
        ON c.Employee_ID = p.Employee_ID
       AND c.Compensation_Year = p.Review_Year

    WHERE c.Compensation_Year = 2026
)

SELECT
    Job_Level,
    Performance_Group,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Annual_Bonus),
        2
    ) AS Avg_Annual_Bonus,

    ROUND(
        AVG(
            Annual_Bonus * 100.0 /
            NULLIF(Base_Salary, 0)
        ),
        2
    ) AS Avg_Bonus_Percentage,

    ROUND(
        AVG(Total_Compensation),
        2
    ) AS Avg_Total_Compensation

FROM Employee_Bonus

GROUP BY
    Job_Level,
    Performance_Group

ORDER BY
    Job_Level,
    Avg_Bonus_Percentage DESC;



-- Query 10: Department Ranking by High Performer Bonus Percentage (2026)

WITH Department_Bonus AS (
    SELECT
        j.Department,

        COUNT(*) AS High_Performers,

        ROUND(
            AVG(c.Annual_Bonus),
            2
        ) AS Avg_Annual_Bonus,

        ROUND(
            AVG(
                c.Annual_Bonus * 100.0 /
                NULLIF(c.Base_Salary, 0)
            ),
            2
        ) AS Avg_Bonus_Percentage

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    JOIN Performance p
        ON c.Employee_ID = p.Employee_ID
       AND c.Compensation_Year = p.Review_Year

    WHERE c.Compensation_Year = 2026
      AND p.Performance_Rating >= 4

    GROUP BY j.Department
)

SELECT
    Department,
    High_Performers,
    Avg_Annual_Bonus,
    Avg_Bonus_Percentage,

    DENSE_RANK() OVER (
        ORDER BY Avg_Bonus_Percentage DESC
    ) AS Bonus_Rank

FROM Department_Bonus

ORDER BY Bonus_Rank;




