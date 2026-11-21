### 10_Compensation_Equity_And_Risk_Analysis



-- Query 1: Employees Below Their Salary Band (2026)

SELECT
    e.Employee_ID,
    j.Job_Title,
    j.Department,
    j.Job_Level,
    e.Location,

    c.Base_Salary,
    sb.Band_Min,

    ROUND(
        sb.Band_Min - c.Base_Salary,
        2
    ) AS Salary_Shortfall,

    ROUND(
        (sb.Band_Min - c.Base_Salary) * 100.0
        / NULLIF(sb.Band_Min, 0),
        2
    ) AS Shortfall_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary < sb.Band_Min

ORDER BY
    Shortfall_Pct DESC,
    Salary_Shortfall DESC;



-- Query 2: Employees Above Their Salary Band (2026)

SELECT
    e.Employee_ID,
    j.Job_Title,
    j.Department,
    j.Job_Level,
    e.Location,

    c.Base_Salary,
    sb.Band_Max,

    ROUND(
        c.Base_Salary - sb.Band_Max,
        2
    ) AS Amount_Above_Band,

    ROUND(
        (c.Base_Salary - sb.Band_Max) * 100.0
        / NULLIF(sb.Band_Max, 0),
        2
    ) AS Above_Band_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026
  AND c.Base_Salary > sb.Band_Max

ORDER BY
    Above_Band_Pct DESC;



-- Query 3: Salary Band Compliance by Department (2026)

SELECT
    j.Department,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN c.Base_Salary < sb.Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN c.Base_Salary BETWEEN sb.Band_Min AND sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Within_Band,

    SUM(
        CASE
            WHEN c.Base_Salary > sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band,

    ROUND(
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                  OR c.Base_Salary > sb.Band_Max
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Non_Compliance_Pct

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
    j.Department

ORDER BY
    Non_Compliance_Pct DESC,
    Below_Band DESC;




-- Query 4: Salary Band Compliance by Location (2026)

SELECT
    e.Location,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN c.Base_Salary < sb.Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN c.Base_Salary BETWEEN sb.Band_Min AND sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Within_Band,

    SUM(
        CASE
            WHEN c.Base_Salary > sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band,

    ROUND(
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                  OR c.Base_Salary > sb.Band_Max
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Non_Compliance_Pct

FROM Employees e

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

WHERE c.Compensation_Year = 2026

GROUP BY
    e.Location

ORDER BY
    Non_Compliance_Pct DESC,
    Below_Band DESC;



-- Query 5: Gender Pay Gap Within Comparable Job Groups (2026)

WITH Gender_Salary AS (
    SELECT
        j.Job_Title,
        j.Department,
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

    JOIN Jobs j
        ON e.Job_ID = j.Job_ID

    JOIN Compensation c
        ON e.Employee_ID = c.Employee_ID

    WHERE c.Compensation_Year = 2026
      AND e.Gender IN ('Male', 'Female')

    GROUP BY
        j.Job_Title,
        j.Department,
        j.Job_Level,
        e.Location
),

Pay_Gap AS (
    SELECT
        *,

        ROUND(
            (Male_Avg_Salary - Female_Avg_Salary)
            * 100.0 / NULLIF(Male_Avg_Salary, 0),
            2
        ) AS Gender_Pay_Gap_Pct

    FROM Gender_Salary

    WHERE Male_Employees >= 5
      AND Female_Employees >= 5
)

SELECT
    Job_Title,
    Department,
    Job_Level,
    Location,

    Male_Employees,
    Female_Employees,

    ROUND(Male_Avg_Salary, 2) AS Male_Avg_Salary,
    ROUND(Female_Avg_Salary, 2) AS Female_Avg_Salary,

    Gender_Pay_Gap_Pct

FROM Pay_Gap

WHERE ABS(Gender_Pay_Gap_Pct) > 5

ORDER BY
    ABS(Gender_Pay_Gap_Pct) DESC;




-- Query 6: Compensation Risk by Performance Rating (2026)

SELECT
    p.Performance_Rating,
    p.Performance_Category,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN c.Base_Salary < sb.Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN c.Base_Salary BETWEEN sb.Band_Min
                                   AND sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Within_Band,

    SUM(
        CASE
            WHEN c.Base_Salary > sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                  OR c.Base_Salary > sb.Band_Max
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Compensation_Risk_Pct

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

GROUP BY
    p.Performance_Rating,
    p.Performance_Category

ORDER BY
    p.Performance_Rating;
    
    
    

-- Query 7: Salary Growth and Compensation Risk (2026)

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
        Base_Salary,

        (Base_Salary - Previous_Base_Salary)
        * 100.0 /
        NULLIF(Previous_Base_Salary, 0)
            AS Salary_Growth_Pct

    FROM Salary_History

    WHERE Compensation_Year = 2026
      AND Previous_Year = 2025
),

Risk_Classification AS (
    SELECT
        sg.Employee_ID,
        sg.Salary_Growth_Pct,

        CASE
            WHEN sg.Base_Salary < sb.Band_Min
                THEN 'Below Band'

            WHEN sg.Base_Salary > sb.Band_Max
                THEN 'Above Band'

            ELSE 'Within Band'
        END AS Compensation_Risk_Category

    FROM Salary_Growth sg

    JOIN Employees e
        ON sg.Employee_ID = e.Employee_ID

    JOIN Salary_Bands sb
        ON e.Job_ID = sb.Job_ID
       AND e.Location = sb.Location
)

SELECT
    Compensation_Risk_Category,

    COUNT(*) AS Employees_Compared,

    ROUND(
        AVG(Salary_Growth_Pct), 2
    ) AS Avg_Salary_Growth_Pct,

    ROUND(
        MIN(Salary_Growth_Pct), 2
    ) AS Min_Salary_Growth_Pct,

    ROUND(
        MAX(Salary_Growth_Pct), 2
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

FROM Risk_Classification

GROUP BY
    Compensation_Risk_Category

ORDER BY
    CASE Compensation_Risk_Category
        WHEN 'Below Band' THEN 1
        WHEN 'Within Band' THEN 2
        WHEN 'Above Band' THEN 3
    END;




-- Query 8: High-Risk Compensation Groups (2026)

SELECT
    j.Department,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN c.Base_Salary < sb.Band_Min
            THEN 1 ELSE 0
        END
    ) AS Employees_Below_Band,

    ROUND(
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                THEN sb.Band_Min - c.Base_Salary
                ELSE 0
            END
        ), 2
    ) AS Total_Salary_Shortfall,

    ROUND(
        AVG(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                THEN sb.Band_Min - c.Base_Salary
            END
        ), 2
    ) AS Avg_Shortfall_Per_Employee,

    ROUND(
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Below_Band_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
   AND c.Compensation_Year = 2026

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

GROUP BY
    j.Department

HAVING Employees_Below_Band > 0

ORDER BY
    Total_Salary_Shortfall DESC;




-- Query 9: Compensation Consistency Across Job Levels (2026)

SELECT
    j.Job_Level,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN c.Base_Salary < sb.Band_Min
            THEN 1 ELSE 0
        END
    ) AS Below_Band,

    SUM(
        CASE
            WHEN c.Base_Salary BETWEEN sb.Band_Min AND sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Within_Band,

    SUM(
        CASE
            WHEN c.Base_Salary > sb.Band_Max
            THEN 1 ELSE 0
        END
    ) AS Above_Band,

    ROUND(
        AVG(c.Base_Salary), 2
    ) AS Avg_Base_Salary,

    ROUND(
        AVG(c.Base_Salary / NULLIF(sb.Band_Mid, 0))
        * 100, 2
    ) AS Avg_Compa_Ratio_Pct,

    ROUND(
        SUM(
            CASE
                WHEN c.Base_Salary < sb.Band_Min
                  OR c.Base_Salary > sb.Band_Max
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Band_Exception_Rate_Pct

FROM Employees e

JOIN Jobs j
    ON e.Job_ID = j.Job_ID

JOIN Compensation c
    ON e.Employee_ID = c.Employee_ID
   AND c.Compensation_Year = 2026

JOIN Salary_Bands sb
    ON e.Job_ID = sb.Job_ID
   AND e.Location = sb.Location

GROUP BY
    j.Job_Level

ORDER BY
    j.Job_Level;




-- Query 10: Final Compensation Equity & Risk Summary (2026)

WITH Compensation_Risk AS (
    SELECT
        e.Employee_ID,
        c.Base_Salary,
        sb.Band_Min,
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
        CASE WHEN Band_Status = 'Below Band'
             THEN 1 ELSE 0 END
    ) AS Employees_Below_Band,

    SUM(
        CASE WHEN Band_Status = 'Within Band'
             THEN 1 ELSE 0 END
    ) AS Employees_Within_Band,

    SUM(
        CASE WHEN Band_Status = 'Above Band'
             THEN 1 ELSE 0 END
    ) AS Employees_Above_Band,

    ROUND(
        SUM(CASE WHEN Band_Status = 'Within Band'
                 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS Band_Compliance_Pct,

    ROUND(
        SUM(
            CASE
                WHEN Band_Status = 'Below Band'
                THEN Band_Min - Base_Salary
                ELSE 0
            END
        ), 2
    ) AS Total_Salary_Shortfall,

    ROUND(
        SUM(
            CASE
                WHEN Band_Status = 'Above Band'
                THEN Base_Salary - Band_Max
                ELSE 0
            END
        ), 2
    ) AS Total_Amount_Above_Band,

    CASE
        WHEN COUNT(*) =
             SUM(CASE WHEN Band_Status = 'Below Band'
                      THEN 1 ELSE 0 END)
           + SUM(CASE WHEN Band_Status = 'Within Band'
                      THEN 1 ELSE 0 END)
           + SUM(CASE WHEN Band_Status = 'Above Band'
                      THEN 1 ELSE 0 END)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS Count_Validation

FROM Compensation_Risk;





