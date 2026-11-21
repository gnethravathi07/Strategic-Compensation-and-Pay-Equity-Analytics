### 11_Employee_Compensation_Segmentation


-- File 11: Employee Compensation Segmentation
-- Query 1: Salary Band Position Segmentation (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Employee_ID,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'

            WHEN Base_Salary > Band_Max
                THEN 'Above Band'

            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'

            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'

            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'

            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS Employee_Percentage

FROM Employee_Segments

GROUP BY
    Salary_Segment

ORDER BY
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;



-- Query 2: Salary Segmentation by Department (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        j.Department,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Department,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'

            WHEN Base_Salary > Band_Max
                THEN 'Above Band'

            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'

            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'

            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'

            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Department,
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY Department
        ),
        2
    ) AS Department_Percentage

FROM Employee_Segments

GROUP BY
    Department,
    Salary_Segment

ORDER BY
    Department,
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;





-- Query 3: Salary Segmentation by Job Level (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        j.Job_Level,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Job_Level,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'

            WHEN Base_Salary > Band_Max
                THEN 'Above Band'

            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'

            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'

            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'

            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Job_Level,
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY Job_Level
        ),
        2
    ) AS Job_Level_Percentage

FROM Employee_Segments

GROUP BY
    Job_Level,
    Salary_Segment

ORDER BY
    Job_Level,
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;




-- Query 4: Salary Segmentation by Location (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        e.Location,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Location,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'

            WHEN Base_Salary > Band_Max
                THEN 'Above Band'

            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'

            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'

            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'

            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Location,
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY Location
        ),
        2
    ) AS Location_Percentage

FROM Employee_Segments

GROUP BY
    Location,
    Salary_Segment

ORDER BY
    Location,
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;



-- Query 5: Salary Segmentation by Performance Rating (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        p.Performance_Rating,
        p.Performance_Category,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Performance p
        ON e.Employee_ID = p.Employee_ID
       AND p.Review_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Performance_Rating,
        Performance_Category,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'

            WHEN Base_Salary > Band_Max
                THEN 'Above Band'

            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'

            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'

            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'

            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Performance_Rating,
    Performance_Category,
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY Performance_Rating
        ),
        2
    ) AS Performance_Group_Percentage

FROM Employee_Segments

GROUP BY
    Performance_Rating,
    Performance_Category,
    Salary_Segment

ORDER BY
    Performance_Rating,
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;




-- Query 6: Compensation Segmentation by Experience (2026)

WITH Employee_Experience AS (
    SELECT
        e.Employee_ID,
        e.Years_Experience,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        CASE
            WHEN e.Years_Experience IS NULL
                THEN 'Unknown'
            WHEN e.Years_Experience < 3
                THEN '0-2 Years'
            WHEN e.Years_Experience < 6
                THEN '3-5 Years'
            WHEN e.Years_Experience < 11
                THEN '6-10 Years'
            ELSE '11+ Years'
        END AS Experience_Group,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Experience_Group,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct,

    SUM(
        CASE
            WHEN Base_Salary < Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN Base_Salary > Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band

FROM Employee_Experience

GROUP BY
    Experience_Group

ORDER BY
    CASE Experience_Group
        WHEN '0-2 Years' THEN 1
        WHEN '3-5 Years' THEN 2
        WHEN '6-10 Years' THEN 3
        WHEN '11+ Years' THEN 4
        WHEN 'Unknown' THEN 5
    END;



-- Query 7: Compensation Segmentation by Employment Type (2026)

WITH Employee_Compensation AS (
    SELECT
        e.Employee_ID,
        e.Employment_Type,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Employment_Type,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2
    ) AS Employee_Percentage,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct,

    SUM(
        CASE
            WHEN Base_Salary < Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN Base_Salary > Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band

FROM Employee_Compensation

GROUP BY
    Employment_Type

ORDER BY
    Total_Employees DESC;



-- Query 8: Compensation Segmentation by Gender (2026)

WITH Employee_Compensation AS (
    SELECT
        e.Employee_ID,
        e.Gender,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Gender,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2
    ) AS Employee_Percentage,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct,

    SUM(
        CASE
            WHEN Base_Salary < Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN Base_Salary > Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band

FROM Employee_Compensation

GROUP BY
    Gender

ORDER BY
    Total_Employees DESC;



-- Query 9: Compensation Segmentation by
-- Performance and Experience (2026)

WITH Employee_Compensation AS (
    SELECT
        e.Employee_ID,
        p.Performance_Rating,
        p.Performance_Category,

        CASE
            WHEN e.Years_Experience IS NULL
                THEN 'Unknown'
            WHEN e.Years_Experience < 3
                THEN '0-2 Years'
            WHEN e.Years_Experience < 6
                THEN '3-5 Years'
            WHEN e.Years_Experience < 11
                THEN '6-10 Years'
            ELSE '11+ Years'
        END AS Experience_Group,

        c.Base_Salary,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Performance p
        ON e.Employee_ID = p.Employee_ID
       AND p.Review_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Experience_Group,
    Performance_Rating,
    Performance_Category,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct

FROM Employee_Compensation

GROUP BY
    Experience_Group,
    Performance_Rating,
    Performance_Category

ORDER BY
    CASE Experience_Group
        WHEN '0-2 Years' THEN 1
        WHEN '3-5 Years' THEN 2
        WHEN '6-10 Years' THEN 3
        WHEN '11+ Years' THEN 4
        WHEN 'Unknown' THEN 5
    END,
    Performance_Rating;
    
  
  
  
-- Query 10: Final Employee Compensation
-- Segmentation Summary (2026)

WITH Employee_Band_Position AS (
    SELECT
        e.Employee_ID,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
),

Employee_Segments AS (
    SELECT
        Employee_ID,
        Base_Salary,
        Band_Position,

        CASE
            WHEN Base_Salary < Band_Min
                THEN 'Below Band'
            WHEN Base_Salary > Band_Max
                THEN 'Above Band'
            WHEN Band_Position < 0.25
                THEN 'Lower Quartile'
            WHEN Band_Position < 0.50
                THEN 'Lower-Middle Quartile'
            WHEN Band_Position < 0.75
                THEN 'Upper-Middle Quartile'
            ELSE 'Upper Quartile'
        END AS Salary_Segment

    FROM Employee_Band_Position
)

SELECT
    Salary_Segment,

    COUNT(*) AS Total_Employees,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2
    ) AS Employee_Percentage,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct

FROM Employee_Segments

GROUP BY
    Salary_Segment

ORDER BY
    CASE Salary_Segment
        WHEN 'Below Band' THEN 1
        WHEN 'Lower Quartile' THEN 2
        WHEN 'Lower-Middle Quartile' THEN 3
        WHEN 'Upper-Middle Quartile' THEN 4
        WHEN 'Upper Quartile' THEN 5
        WHEN 'Above Band' THEN 6
    END;



-- File 12: Final Business Insights and Validation
-- Query 1: Final Workforce and Compensation KPI Summary (2026)

WITH Compensation_KPIs AS (
    SELECT
        COUNT(*) AS Total_Employees,
        ROUND(AVG(Base_Salary), 2) AS Avg_Base_Salary,
        ROUND(AVG(Annual_Bonus), 2) AS Avg_Annual_Bonus,
        ROUND(AVG(Total_Compensation), 2) AS Avg_Total_Compensation,
        ROUND(SUM(Total_Compensation), 2) AS Total_Compensation_Expense
    FROM Compensation
    WHERE Compensation_Year = 2026
),

Performance_KPIs AS (
    SELECT
        SUM(
            CASE
                WHEN Performance_Rating >= 4 THEN 1
                ELSE 0
            END
        ) AS High_Performers
    FROM Performance
    WHERE Review_Year = 2026
),

Promotion_KPIs AS (
    SELECT
        COUNT(DISTINCT Employee_ID) AS Promoted_Employees,
        ROUND(AVG(Salary_Increase_Pct), 2)
            AS Avg_Promotion_Increase_Pct
    FROM Promotions
    WHERE YEAR(Promotion_Date) = 2026
)

SELECT
    c.Total_Employees,
    c.Avg_Base_Salary,
    c.Avg_Annual_Bonus,
    c.Avg_Total_Compensation,
    c.Total_Compensation_Expense,

    p.High_Performers,

    ROUND(
        p.High_Performers * 100.0
        / c.Total_Employees, 2
    ) AS High_Performer_Pct,

    pr.Promoted_Employees,

    ROUND(
        pr.Promoted_Employees * 100.0
        / c.Total_Employees, 2
    ) AS Promotion_Rate_Pct,

    pr.Avg_Promotion_Increase_Pct

FROM Compensation_KPIs c
CROSS JOIN Performance_KPIs p
CROSS JOIN Promotion_KPIs pr;

    


-- Query 2: Final Salary Band Compliance
-- and Risk Summary (2026)

WITH Employee_Band_Analysis AS (
    SELECT
        e.Employee_ID,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Mid,
        sb.Band_Max,

        CASE
            WHEN c.Base_Salary < sb.Band_Min
                THEN 'Below Band'
            WHEN c.Base_Salary > sb.Band_Max
                THEN 'Above Band'
            ELSE 'Within Band'
        END AS Band_Status

    FROM Employees e

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    COUNT(*) AS Total_Employees,

    SUM(
        CASE WHEN Band_Status = 'Within Band'
        THEN 1 ELSE 0 END
    ) AS Employees_Within_Band,

    SUM(
        CASE WHEN Band_Status = 'Below Band'
        THEN 1 ELSE 0 END
    ) AS Employees_Below_Band,

    SUM(
        CASE WHEN Band_Status = 'Above Band'
        THEN 1 ELSE 0 END
    ) AS Employees_Above_Band,

    ROUND(
        100.0 * SUM(
            CASE WHEN Band_Status = 'Within Band'
            THEN 1 ELSE 0 END
        ) / COUNT(*), 2
    ) AS Band_Compliance_Pct,

    ROUND(
        SUM(
            CASE
                WHEN Base_Salary < Band_Min
                THEN Band_Min - Base_Salary
                ELSE 0
            END
        ), 2
    ) AS Total_Salary_Shortfall,

    ROUND(
        SUM(
            CASE
                WHEN Base_Salary > Band_Max
                THEN Base_Salary - Band_Max
                ELSE 0
            END
        ), 2
    ) AS Total_Amount_Above_Band

FROM Employee_Band_Analysis;



-- Query 3: Final Salary Growth and Performance Summary (2026)

WITH Salary_Growth AS (
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

Employee_Growth AS (
    SELECT
        sg.Employee_ID,

        ROUND(
            (sg.Base_Salary - sg.Previous_Base_Salary)
            * 100.0
            / NULLIF(sg.Previous_Base_Salary, 0),
            2
        ) AS Salary_Growth_Pct

    FROM Salary_Growth sg

    WHERE sg.Compensation_Year = 2026
      AND sg.Previous_Year = 2025
),

Performance_Growth AS (
    SELECT
        p.Performance_Rating,
        p.Performance_Category,
        eg.Employee_ID,
        eg.Salary_Growth_Pct

    FROM Employee_Growth eg

    JOIN Performance p
        ON eg.Employee_ID = p.Employee_ID
       AND p.Review_Year = 2026
)

SELECT
    Performance_Rating,
    Performance_Category,

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

FROM Performance_Growth

GROUP BY
    Performance_Rating,
    Performance_Category

ORDER BY
    Performance_Rating;




-- Query 4: Final Promotion and Performance Summary (2026)

WITH Promoted_Employees AS (
    SELECT DISTINCT
        Employee_ID
    FROM Promotions
    WHERE YEAR(Promotion_Date) = 2026
)

SELECT
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(*) AS Total_Employees,

    COUNT(pr.Employee_ID) AS Promoted_Employees,

    ROUND(
        COUNT(pr.Employee_ID) * 100.0
        / COUNT(*), 2
    ) AS Promotion_Rate_Pct

FROM Performance p

LEFT JOIN Promoted_Employees pr
    ON p.Employee_ID = pr.Employee_ID

WHERE p.Review_Year = 2026

GROUP BY
    p.Performance_Rating,
    p.Performance_Category

ORDER BY
    p.Performance_Rating;



-- Query 5: Final Gender Pay Equity Summary (2026)
-- Descriptive comparison within job levels

WITH Gender_Compensation AS (
    SELECT
        j.Job_Level,
        e.Gender,
        c.Base_Salary,

        (c.Base_Salary - sb.Band_Min)
        / NULLIF(sb.Band_Max - sb.Band_Min, 0)
            AS Band_Position

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Job_Level,
    Gender,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(Band_Position) * 100, 2
    ) AS Avg_Band_Position_Pct

FROM Gender_Compensation

GROUP BY
    Job_Level,
    Gender

ORDER BY
    Job_Level,
    CASE Gender
        WHEN 'Male' THEN 1
        WHEN 'Female' THEN 2
        WHEN 'Non-binary' THEN 3
        ELSE 4
    END;



-- Query 6: Final Department-Level Compensation Scorecard (2026)

WITH Promoted_Employees AS (
    SELECT DISTINCT Employee_ID
    FROM Promotions
    WHERE YEAR(Promotion_Date) = 2026
)

SELECT
    j.Department,

    COUNT(*) AS Total_Employees,

    ROUND(
        AVG(c.Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(c.Total_Compensation), 2
    ) AS Avg_Total_Compensation,

    ROUND(
        AVG(p.Performance_Rating), 2
    ) AS Avg_Performance_Rating,

    SUM(
        CASE
            WHEN p.Performance_Rating >= 4
            THEN 1 ELSE 0
        END
    ) AS High_Performers,

    ROUND(
        SUM(
            CASE
                WHEN p.Performance_Rating >= 4
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*), 2
    ) AS High_Performer_Pct,

    COUNT(pr.Employee_ID) AS Promoted_Employees,

    ROUND(
        COUNT(pr.Employee_ID) * 100.0
        / COUNT(*), 2
    ) AS Promotion_Rate_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
   AND c.Compensation_Year = 2026

JOIN Performance p
    ON e.Employee_ID = p.Employee_ID
   AND p.Review_Year = 2026

LEFT JOIN Promoted_Employees pr
    ON e.Employee_ID = pr.Employee_ID

GROUP BY
    j.Department

ORDER BY
    Avg_Total_Compensation DESC;



-- Query 7: Final Compensation Risk by Department (2026)

WITH Employee_Band_Risk AS (
    SELECT
        e.Employee_ID,
        j.Department,
        c.Base_Salary,
        sb.Band_Min,
        sb.Band_Max

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Department,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE WHEN Base_Salary < Band_Min
        THEN 1 ELSE 0 END
    ) AS Below_Band,

    SUM(
        CASE WHEN Base_Salary > Band_Max
        THEN 1 ELSE 0 END
    ) AS Above_Band,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Base_Salary BETWEEN Band_Min AND Band_Max
                THEN 1 ELSE 0
            END
        ) / COUNT(*), 2
    ) AS Compliance_Rate_Pct,

    ROUND(
        SUM(
            CASE
                WHEN Base_Salary < Band_Min
                THEN Band_Min - Base_Salary
                ELSE 0
            END
        ), 2
    ) AS Total_Salary_Shortfall,

    ROUND(
        SUM(
            CASE
                WHEN Base_Salary > Band_Max
                THEN Base_Salary - Band_Max
                ELSE 0
            END
        ), 2
    ) AS Total_Amount_Above_Band

FROM Employee_Band_Risk

GROUP BY Department

ORDER BY
    Total_Salary_Shortfall DESC,
    Department;




-- Query 8: Final Gender Pay Gap by Comparable
-- Job Title and Location (2026)

WITH Gender_Job_Salary AS (
    SELECT
        j.Job_Title,
        j.Department,
        j.Job_Level,
        e.Location,

        SUM(
            CASE WHEN e.Gender = 'Male'
            THEN 1 ELSE 0 END
        ) AS Male_Employees,

        SUM(
            CASE WHEN e.Gender = 'Female'
            THEN 1 ELSE 0 END
        ) AS Female_Employees,

        AVG(
            CASE WHEN e.Gender = 'Male'
            THEN c.Base_Salary END
        ) AS Male_Avg_Salary,

        AVG(
            CASE WHEN e.Gender = 'Female'
            THEN c.Base_Salary END
        ) AS Female_Avg_Salary

    FROM Employees e

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026

    GROUP BY
        j.Job_Title,
        j.Department,
        j.Job_Level,
        e.Location
)

SELECT
    Job_Title,
    Department,
    Job_Level,
    Location,

    Male_Employees,
    Female_Employees,

    ROUND(Male_Avg_Salary, 2)
        AS Male_Avg_Salary,

    ROUND(Female_Avg_Salary, 2)
        AS Female_Avg_Salary,

    ROUND(
        (Male_Avg_Salary - Female_Avg_Salary)
        * 100.0 / NULLIF(Male_Avg_Salary, 0),
        2
    ) AS Gender_Pay_Gap_Pct

FROM Gender_Job_Salary

WHERE Male_Employees >= 5
  AND Female_Employees >= 5

ORDER BY
    ABS(
        (Male_Avg_Salary - Female_Avg_Salary)
        / NULLIF(Male_Avg_Salary, 0)
    ) DESC;



-- Query 9: Final Compensation Data Integrity Validation
-- Compensation & Pay Equity Analytics

WITH Validation_Checks AS (
    SELECT
        (SELECT COUNT(*)
         FROM Employees) AS Total_Employees,

        (SELECT COUNT(*)
         FROM Compensation
         WHERE Compensation_Year = 2026) AS Compensation_2026,

        (SELECT COUNT(*)
         FROM Performance
         WHERE Review_Year = 2026) AS Performance_2026,

        (SELECT COUNT(DISTINCT Employee_ID)
         FROM Promotions
         WHERE YEAR(Promotion_Date) = 2026)
            AS Promoted_Employees_2026,

        (SELECT COUNT(*)
         FROM Employees e
         LEFT JOIN Jobs j
             ON e.Job_ID = j.Job_ID
         WHERE j.Job_ID IS NULL)
            AS Missing_Job_Mappings,

        (SELECT COUNT(*)
         FROM Employees e
         LEFT JOIN Salary_Bands sb
             ON e.Job_ID = sb.Job_ID
            AND e.Location = sb.Location
         WHERE sb.Job_ID IS NULL)
            AS Missing_Salary_Bands,

        (SELECT COUNT(*)
         FROM Compensation
         WHERE Compensation_Year = 2026
           AND ABS(
               Total_Compensation -
               (Base_Salary + Annual_Bonus + Allowances)
           ) > 0.01)
            AS Compensation_Reconciliation_Errors
)

SELECT
    Total_Employees,
    Compensation_2026,
    Performance_2026,
    Promoted_Employees_2026,
    Missing_Job_Mappings,
    Missing_Salary_Bands,
    Compensation_Reconciliation_Errors,

    CASE
        WHEN Total_Employees = 10000
         AND Compensation_2026 = 10000
         AND Performance_2026 = 10000
         AND Promoted_Employees_2026 = 970
         AND Missing_Job_Mappings = 0
         AND Missing_Salary_Bands = 0
         AND Compensation_Reconciliation_Errors = 0
        THEN 'PASS'
        ELSE 'CHECK'
    END AS Overall_Validation_Status

FROM Validation_Checks;



-- Query 10: Final Executive Business Summary (2026)
-- Compensation & Pay Equity Analytics

WITH Workforce_Summary AS (
    SELECT
        COUNT(*) AS Total_Employees,
        ROUND(AVG(c.Base_Salary), 2) AS Avg_Base_Salary,
        ROUND(AVG(c.Total_Compensation), 2)
            AS Avg_Total_Compensation,
        ROUND(SUM(c.Total_Compensation), 2)
            AS Total_Compensation_Expense
    FROM Employees e
    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026
),

Performance_Summary AS (
    SELECT
        SUM(
            CASE WHEN Performance_Rating >= 4
            THEN 1 ELSE 0 END
        ) AS High_Performers
    FROM Performance
    WHERE Review_Year = 2026
),

Promotion_Summary AS (
    SELECT
        COUNT(DISTINCT Employee_ID) AS Promoted_Employees
    FROM Promotions
    WHERE YEAR(Promotion_Date) = 2026
),

Band_Summary AS (
    SELECT
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                THEN 1 ELSE 0
            END
        ) AS Below_Band,

        SUM(
            CASE
                WHEN c.Base_Salary > sb.Band_Max
                THEN 1 ELSE 0
            END
        ) AS Above_Band,

        SUM(
            CASE
                WHEN c.Base_Salary BETWEEN
                     sb.Band_Min AND sb.Band_Max
                THEN 1 ELSE 0
            END
        ) AS Within_Band

    FROM Employees e
    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID
       AND c.Compensation_Year = 2026
    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    w.Total_Employees,
    w.Avg_Base_Salary,
    w.Avg_Total_Compensation,
    w.Total_Compensation_Expense,

    p.High_Performers,

    ROUND(
        p.High_Performers * 100.0 /
        NULLIF(w.Total_Employees, 0), 2
    ) AS High_Performer_Pct,

    pr.Promoted_Employees,

    ROUND(
        pr.Promoted_Employees * 100.0 /
        NULLIF(w.Total_Employees, 0), 2
    ) AS Promotion_Rate_Pct,

    b.Within_Band,
    b.Below_Band,
    b.Above_Band,

    ROUND(
        b.Within_Band * 100.0 /
        NULLIF(w.Total_Employees, 0), 2
    ) AS Band_Compliance_Pct

FROM Workforce_Summary w
CROSS JOIN Performance_Summary p
CROSS JOIN Promotion_Summary pr
CROSS JOIN Band_Summary b;
