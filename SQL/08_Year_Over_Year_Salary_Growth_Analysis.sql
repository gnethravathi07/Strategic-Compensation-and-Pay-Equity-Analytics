
USE Compensation_Pay_Equity_DB;

-- Query 1: Employee Year-over-Year Base Salary Growth

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
)

SELECT
    Employee_ID,
    Compensation_Year,

    ROUND(Base_Salary, 2) AS Current_Base_Salary,

    ROUND(
        Previous_Year_Salary,
        2
    ) AS Previous_Year_Salary,

    CASE
        WHEN Previous_Year = Compensation_Year - 1
        THEN ROUND(
            Base_Salary - Previous_Year_Salary,
            2
        )
        ELSE NULL
    END AS Salary_Change,

    CASE
        WHEN Previous_Year = Compensation_Year - 1
        THEN ROUND(
            (Base_Salary - Previous_Year_Salary) * 100.0 /
            NULLIF(Previous_Year_Salary, 0),
            2
        )
        ELSE NULL
    END AS Salary_Growth_Pct

FROM Salary_History

ORDER BY
    Employee_ID,
    Compensation_Year;



-- Query 2: Average Year-over-Year Base Salary Growth

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,
        Previous_Base_Salary,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Previous_Year = Compensation_Year - 1
)

SELECT
    Compensation_Year,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN Base_Salary > Previous_Base_Salary
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN Base_Salary < Previous_Base_Salary
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease,

    SUM(
        CASE
            WHEN Base_Salary = Previous_Base_Salary
            THEN 1 ELSE 0
        END
    ) AS Employees_With_No_Change

FROM Salary_Growth

GROUP BY Compensation_Year

ORDER BY Compensation_Year;



-- Query 3: Year-over-Year Salary Growth Distribution

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,
        Compensation_Year,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Previous_Year = Compensation_Year - 1
),

Growth_Categories AS (
    SELECT
        Compensation_Year,

        CASE
            WHEN Salary_Growth_Pct < 0
                THEN 'Salary Decrease'
            WHEN Salary_Growth_Pct = 0
                THEN 'No Change'
            WHEN Salary_Growth_Pct < 5
                THEN 'Increase Below 5%'
            WHEN Salary_Growth_Pct < 10
                THEN 'Increase 5-10%'
            WHEN Salary_Growth_Pct < 20
                THEN 'Increase 10-20%'
            ELSE 'Increase 20% or More'
        END AS Growth_Category

    FROM Salary_Growth
)

SELECT
    Compensation_Year,
    Growth_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (
            PARTITION BY Compensation_Year
        ),
        2
    ) AS Employee_Percentage

FROM Growth_Categories

GROUP BY
    Compensation_Year,
    Growth_Category

ORDER BY
    Compensation_Year,
    FIELD(
        Growth_Category,
        'Salary Decrease',
        'No Change',
        'Increase Below 5%',
        'Increase 5-10%',
        'Increase 10-20%',
        'Increase 20% or More'
    );
    
    
    
    
    
-- Query 4: Average Year-over-Year Salary Growth by Department (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    j.Department,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(sg.Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(sg.Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

GROUP BY j.Department

ORDER BY Avg_Salary_Growth_Pct DESC;





-- Query 5: Year-over-Year Salary Growth by Job Level (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    j.Job_Level,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(sg.Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(sg.Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

GROUP BY j.Job_Level

ORDER BY j.Job_Level;




-- Query 6: Year-over-Year Salary Growth by Location (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    e.Location,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(sg.Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(sg.Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

GROUP BY e.Location

ORDER BY Avg_Salary_Growth_Pct DESC;




-- Query 7: Salary Growth - Promoted vs Non-Promoted (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
),

Promotion_Status AS (
    SELECT
        sg.Employee_ID,
        sg.Salary_Growth_Pct,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM Promotions p
                WHERE p.Employee_ID = sg.Employee_ID
                  AND YEAR(p.Promotion_Date) = 2026
            )
            THEN 'Promoted'
            ELSE 'Not Promoted'
        END AS Promotion_Group

    FROM Salary_Growth sg
)

SELECT
    Promotion_Group,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Promotion_Status

GROUP BY Promotion_Group

ORDER BY Avg_Salary_Growth_Pct DESC;



-- Query 8: Year-over-Year Salary Growth by Performance Rating (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    pf.Performance_Rating,
    pf.Performance_Category,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(sg.Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(sg.Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Performance pf
    ON sg.Employee_ID = pf.Employee_ID
   AND pf.Review_Year = 2026

GROUP BY
    pf.Performance_Rating,
    pf.Performance_Category

ORDER BY pf.Performance_Rating;



-- Query 9: Year-over-Year Salary Growth by Gender (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    e.Gender,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(sg.Salary_Growth_Pct),
        2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(sg.Salary_Growth_Pct),
        2
    ) AS Max_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

GROUP BY e.Gender

ORDER BY Avg_Salary_Growth_Pct DESC;



-- Query 10: Salary Growth by Gender and Job Level (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    j.Job_Level,
    e.Gender,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct),
        2
    ) AS Avg_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

WHERE e.Gender IN ('Male', 'Female')

GROUP BY
    j.Job_Level,
    e.Gender

ORDER BY
    j.Job_Level,
    e.Gender;



-- Query 11: Salary Growth by Performance Rating and Job Level (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,
        (Base_Salary - Previous_Base_Salary) * 100.0
            / NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    j.Job_Level,
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    SUM(
        CASE WHEN sg.Salary_Growth_Pct > 0
             THEN 1 ELSE 0 END
    ) AS Employees_With_Increase,

    SUM(
        CASE WHEN sg.Salary_Growth_Pct < 0
             THEN 1 ELSE 0 END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Performance p
    ON sg.Employee_ID = p.Employee_ID
   AND p.Review_Year = 2026

GROUP BY
    j.Job_Level,
    p.Performance_Rating,
    p.Performance_Category

ORDER BY
    j.Job_Level,
    p.Performance_Rating;





-- Query 12: Salary Growth by Promotion Status
-- and Performance Rating (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary) * 100.0
        / NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
),

Employee_Analysis AS (
    SELECT
        sg.Employee_ID,
        sg.Salary_Growth_Pct,
        pf.Performance_Rating,
        pf.Performance_Category,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM Promotions pr
                WHERE pr.Employee_ID = sg.Employee_ID
                  AND YEAR(pr.Promotion_Date) = 2026
            )
            THEN 'Promoted'
            ELSE 'Not Promoted'
        END AS Promotion_Group

    FROM Salary_Growth sg

    JOIN Performance pf
        ON sg.Employee_ID = pf.Employee_ID
       AND pf.Review_Year = 2026
)

SELECT
    Performance_Rating,
    Performance_Category,
    Promotion_Group,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Employee_Analysis

GROUP BY
    Performance_Rating,
    Performance_Category,
    Promotion_Group

ORDER BY
    Performance_Rating,
    Promotion_Group;



-- Query 13: Salary Growth by Gender
-- and Performance Rating (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary) * 100.0
        / NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    pf.Performance_Rating,
    pf.Performance_Category,
    e.Gender,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Performance pf
    ON sg.Employee_ID = pf.Employee_ID
   AND pf.Review_Year = 2026

WHERE e.Gender IN ('Male', 'Female')

GROUP BY
    pf.Performance_Rating,
    pf.Performance_Category,
    e.Gender

ORDER BY
    pf.Performance_Rating,
    e.Gender;



-- Query 14: Salary Growth by Department
-- and Performance Rating (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary) * 100.0
        / NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
)

SELECT
    j.Department,
    pf.Performance_Rating,
    pf.Performance_Category,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(sg.Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct > 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Increase,

    SUM(
        CASE
            WHEN sg.Salary_Growth_Pct < 0
            THEN 1 ELSE 0
        END
    ) AS Employees_With_Decrease

FROM Salary_Growth sg

JOIN Employees e
    ON sg.Employee_ID = e.Employee_ID

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Performance pf
    ON sg.Employee_ID = pf.Employee_ID
   AND pf.Review_Year = 2026

GROUP BY
    j.Department,
    pf.Performance_Rating,
    pf.Performance_Category

ORDER BY
    j.Department,
    pf.Performance_Rating;



-- Query 15: Salary Growth Outlier Analysis (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        ROUND(
            (Base_Salary - Previous_Base_Salary)
            * 100.0 /
            NULLIF(Previous_Base_Salary, 0),
            2
        ) AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
),

Growth_Classification AS (
    SELECT
        Employee_ID,
        Salary_Growth_Pct,

        CASE
            WHEN Salary_Growth_Pct > 20
                THEN 'High Salary Increase'

            WHEN Salary_Growth_Pct < -15
                THEN 'High Salary Decrease'

            ELSE 'Normal Salary Change'
        END AS Growth_Category

    FROM Salary_Growth
)

SELECT
    Growth_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Employee_Percentage,

    ROUND(
        AVG(Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(Salary_Growth_Pct), 2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(Salary_Growth_Pct), 2
    ) AS Max_Salary_Growth_Pct

FROM Growth_Classification

GROUP BY Growth_Category

ORDER BY
    CASE Growth_Category
        WHEN 'High Salary Increase' THEN 1
        WHEN 'High Salary Decrease' THEN 2
        ELSE 3
    END;




-- Query 16: Final Salary Growth Summary & Validation (2026)

WITH Salary_History AS (
    SELECT
        Employee_ID,
        Compensation_Year,
        Base_Salary,

        LAG(Base_Salary) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Base_Salary,

        LAG(Compensation_Year) OVER (
            PARTITION BY Employee_ID
            ORDER BY Compensation_Year
        ) AS Previous_Year

    FROM Compensation
),

Salary_Growth AS (
    SELECT
        Employee_ID,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
),

Growth_Summary AS (
    SELECT
        COUNT(*) AS Total_Employees,

        ROUND(
            AVG(Salary_Growth_Pct), 2
        ) AS Avg_Salary_Growth_Pct,

        SUM(
            CASE
                WHEN Salary_Growth_Pct > 0
                THEN 1 ELSE 0
            END
        ) AS Employees_With_Increase,

        SUM(
            CASE
                WHEN Salary_Growth_Pct < 0
                THEN 1 ELSE 0
            END
        ) AS Employees_With_Decrease,

        SUM(
            CASE
                WHEN Salary_Growth_Pct = 0
                THEN 1 ELSE 0
            END
        ) AS Employees_With_No_Change,

        SUM(
            CASE
                WHEN Salary_Growth_Pct > 20
                THEN 1 ELSE 0
            END
        ) AS High_Salary_Increases,

        SUM(
            CASE
                WHEN Salary_Growth_Pct < -15
                THEN 1 ELSE 0
            END
        ) AS High_Salary_Decreases

    FROM Salary_Growth
)

SELECT
    Total_Employees,
    Avg_Salary_Growth_Pct,

    Employees_With_Increase,
    Employees_With_Decrease,
    Employees_With_No_Change,

    High_Salary_Increases,
    High_Salary_Decreases,

    CASE
        WHEN Total_Employees =
             Employees_With_Increase
             + Employees_With_Decrease
             + Employees_With_No_Change
        THEN 'PASS'
        ELSE 'FAIL'
    END AS Employee_Count_Validation,

    CASE
        WHEN High_Salary_Increases
             + High_Salary_Decreases
             <= Total_Employees
        THEN 'PASS'
        ELSE 'FAIL'
    END AS Outlier_Count_Validation

FROM Growth_Summary;




