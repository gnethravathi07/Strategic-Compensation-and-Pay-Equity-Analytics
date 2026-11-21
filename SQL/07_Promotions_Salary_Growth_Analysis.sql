
USE Compensation_Pay_Equity_DB;

-- Query 1: Promotion Distribution by Year

SELECT
    YEAR(Promotion_Date) AS Promotion_Year,

    COUNT(*) AS Total_Promotions,

    COUNT(DISTINCT Employee_ID) AS Employees_Promoted,

    ROUND(
        AVG(Salary_Increase_Pct),
        2
    ) AS Avg_Salary_Increase_Pct,

    ROUND(
        MIN(Salary_Increase_Pct),
        2
    ) AS Minimum_Salary_Increase_Pct,

    ROUND(
        MAX(Salary_Increase_Pct),
        2
    ) AS Maximum_Salary_Increase_Pct

FROM Promotions

GROUP BY YEAR(Promotion_Date)

ORDER BY Promotion_Year;




-- Query 2: Annual Employee Promotion Rate (2024–2026)

WITH Annual_Workforce AS (
    SELECT
        Compensation_Year AS Year,
        COUNT(DISTINCT Employee_ID) AS Total_Employees
    FROM Compensation
    GROUP BY Compensation_Year
),

Annual_Promotions AS (
    SELECT
        YEAR(Promotion_Date) AS Year,
        COUNT(DISTINCT Employee_ID) AS Promoted_Employees
    FROM Promotions
    GROUP BY YEAR(Promotion_Date)
)

SELECT
    w.Year,
    w.Total_Employees,

    COALESCE(
        p.Promoted_Employees,
        0
    ) AS Promoted_Employees,

    ROUND(
        COALESCE(p.Promoted_Employees, 0) * 100.0 /
        NULLIF(w.Total_Employees, 0),
        2
    ) AS Promotion_Rate_Pct

FROM Annual_Workforce w

LEFT JOIN Annual_Promotions p
    ON w.Year = p.Year

ORDER BY w.Year;




-- Query 3: Promotion Distribution by Department (2026)

WITH Department_Promotions AS (
    SELECT
        j.Department,

        COUNT(*) AS Total_Employees,

        COUNT(
            DISTINCT CASE
                WHEN YEAR(p.Promotion_Date) = 2026
                THEN p.Employee_ID
            END
        ) AS Promoted_Employees

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    LEFT JOIN Promotions p
        ON e.Employee_ID = p.Employee_ID

    GROUP BY j.Department
)

SELECT
    Department,
    Total_Employees,
    Promoted_Employees,

    ROUND(
        Promoted_Employees * 100.0 /
        NULLIF(Total_Employees, 0),
        2
    ) AS Promotion_Rate_Pct

FROM Department_Promotions

ORDER BY
    Promotion_Rate_Pct DESC;
    
    


-- Query 4: Average Promotion Salary Increase by Department (2026)

SELECT
    j.Department,

    COUNT(*) AS Total_Promotions,

    ROUND(
        AVG(p.Salary_Increase_Pct),
        2
    ) AS Avg_Salary_Increase_Pct,

    ROUND(
        MIN(p.Salary_Increase_Pct),
        2
    ) AS Min_Salary_Increase_Pct,

    ROUND(
        MAX(p.Salary_Increase_Pct),
        2
    ) AS Max_Salary_Increase_Pct

FROM Promotions p

JOIN Employees e
    ON p.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

WHERE YEAR(p.Promotion_Date) = 2026

GROUP BY j.Department

ORDER BY Avg_Salary_Increase_Pct DESC;

    


-- Query 5: Promotion Distribution by Job Level Transition

SELECT
    Previous_Level,
    New_Level,

    COUNT(*) AS Total_Promotions,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Promotions),
        2
    ) AS Promotion_Percentage,

    ROUND(
        AVG(Salary_Increase_Pct),
        2
    ) AS Avg_Salary_Increase_Pct,

    ROUND(
        MIN(Salary_Increase_Pct),
        2
    ) AS Min_Salary_Increase_Pct,

    ROUND(
        MAX(Salary_Increase_Pct),
        2
    ) AS Max_Salary_Increase_Pct

FROM Promotions

GROUP BY
    Previous_Level,
    New_Level

ORDER BY
    Previous_Level,
    New_Level;
    



-- Query 6: Promotion Trends by Job Level Transition and Year

SELECT
    YEAR(Promotion_Date) AS Promotion_Year,

    Previous_Level,
    New_Level,

    COUNT(*) AS Total_Promotions,

    ROUND(
        AVG(Salary_Increase_Pct),
        2
    ) AS Avg_Salary_Increase_Pct,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (
            PARTITION BY YEAR(Promotion_Date)
        ),
        2
    ) AS Yearly_Promotion_Share_Pct

FROM Promotions

GROUP BY
    YEAR(Promotion_Date),
    Previous_Level,
    New_Level

ORDER BY
    Promotion_Year,
    Previous_Level;
    
    


-- Query 7: Performance Ratings of Promoted Employees (2026)

SELECT
    pf.Performance_Rating,
    pf.Performance_Category,

    COUNT(DISTINCT p.Employee_ID) AS Promoted_Employees,

    ROUND(
        COUNT(DISTINCT p.Employee_ID) * 100.0 /
        SUM(COUNT(DISTINCT p.Employee_ID)) OVER (),
        2
    ) AS Promotion_Distribution_Pct,

    ROUND(
        AVG(p.Salary_Increase_Pct),
        2
    ) AS Avg_Salary_Increase_Pct

FROM Promotions p

JOIN Performance pf
    ON p.Employee_ID = pf.Employee_ID
   AND YEAR(p.Promotion_Date) = pf.Review_Year

WHERE YEAR(p.Promotion_Date) = 2026

GROUP BY
    pf.Performance_Rating,
    pf.Performance_Category

ORDER BY pf.Performance_Rating;




-- Query 8: Promotion Rate by Performance Rating (2026)

SELECT
    pf.Performance_Rating,
    pf.Performance_Category,

    COUNT(DISTINCT pf.Employee_ID) AS Total_Employees,

    COUNT(
        DISTINCT CASE
            WHEN YEAR(pr.Promotion_Date) = 2026
            THEN pr.Employee_ID
        END
    ) AS Promoted_Employees,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN YEAR(pr.Promotion_Date) = 2026
                THEN pr.Employee_ID
            END
        ) * 100.0 /
        NULLIF(COUNT(DISTINCT pf.Employee_ID), 0),
        2
    ) AS Promotion_Rate_Pct

FROM Performance pf

LEFT JOIN Promotions pr
    ON pf.Employee_ID = pr.Employee_ID
   AND YEAR(pr.Promotion_Date) = 2026

WHERE pf.Review_Year = 2026

GROUP BY
    pf.Performance_Rating,
    pf.Performance_Category

ORDER BY pf.Performance_Rating;




-- Query 9: Promotion Rate by Job Level (2026)

SELECT
    j.Job_Level,

    COUNT(DISTINCT e.Employee_ID) AS Total_Employees,

    COUNT(
        DISTINCT CASE
            WHEN YEAR(p.Promotion_Date) = 2026
            THEN p.Employee_ID
        END
    ) AS Promoted_Employees,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN YEAR(p.Promotion_Date) = 2026
                THEN p.Employee_ID
            END
        ) * 100.0 /
        NULLIF(COUNT(DISTINCT e.Employee_ID), 0),
        2
    ) AS Promotion_Rate_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

LEFT JOIN Promotions p
    ON e.Employee_ID = p.Employee_ID
   AND YEAR(p.Promotion_Date) = 2026

GROUP BY j.Job_Level

ORDER BY j.Job_Level;




-- Query 10: Average Salary Increase by Promotion Transition (2026)

WITH Promotion_Analysis AS (
    SELECT
        Previous_Level,
        New_Level,

        COUNT(*) AS Total_Promotions,

        ROUND(
            AVG(Salary_Increase_Pct),
            2
        ) AS Avg_Salary_Increase_Pct,

        ROUND(
            MIN(Salary_Increase_Pct),
            2
        ) AS Min_Salary_Increase_Pct,

        ROUND(
            MAX(Salary_Increase_Pct),
            2
        ) AS Max_Salary_Increase_Pct

    FROM Promotions

    WHERE YEAR(Promotion_Date) = 2026

    GROUP BY
        Previous_Level,
        New_Level
)

SELECT
    Previous_Level,
    New_Level,
    Total_Promotions,
    Avg_Salary_Increase_Pct,
    Min_Salary_Increase_Pct,
    Max_Salary_Increase_Pct,

    DENSE_RANK() OVER (
        ORDER BY Avg_Salary_Increase_Pct DESC
    ) AS Salary_Increase_Rank

FROM Promotion_Analysis

ORDER BY Salary_Increase_Rank;







