# 💜 Strategic Compensation and Pay Equity Analytics

<p align="center">
  <img src="https://img.shields.io/badge/HR%20Analytics-Compensation-8E44AD?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Python-Pandas%20%7C%20NumPy-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Power%20BI-DAX%20%7C%20Power%20Query-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/Project-HR%20Analytics-9B59B6?style=for-the-badge" />
</p>

<p align="center">
  **Transforming Employee Compensation Data into Strategic HR Insights**
</p>

---

## 📌 1. Project Overview

**Strategic Compensation and Pay Equity Analytics** is an end-to-end HR analytics project focused on understanding workforce composition, employee compensation, gender pay differences, salary band compliance, employee performance, and career progression.

The project analyzes employee and compensation data to identify salary distribution patterns, evaluate compensation consistency, examine promotion trends, and highlight potential areas of compensation risk.

Using Python-based data preparation, analytical techniques, and interactive Power BI reporting, the project transforms raw HR data into meaningful business insights that support data-driven HR decisions.

### 🎯 Project Goals

- Understand employee workforce composition.
- Analyze compensation across departments, job levels, and locations.
- Evaluate gender-based compensation differences.
- Assess employee salaries against defined salary bands.
- Investigate compensation differences across performance ratings.
- Analyze employee promotions and salary growth.
- Identify departments with potential compensation risks.
- Build interactive dashboards for HR decision-making.

## 📊 2. Dataset Overview

The documented project dataset contains:

| Dataset | Records | Purpose |
|---|---:|---|
| Employees | 10,000 | Employee and workforce information |
| Compensation | 30,000 | Salary, bonus, and compensation records |
| Salary Bands | Source reference table | Defined compensation ranges |
| Performance | Employee-level performance information | Performance analysis |
| Promotions | Promotion and salary increase information | Career growth analysis |


### Key Data Attributes

| Data Area | Example Attributes |
|---|---|
| Employee Information | Employee_ID, Gender, Department, Location |
| Compensation | Base_Salary, Annual_Bonus, Total_Compensation |
| Salary Bands | Band_Min, Band_Mid, Band_Max |
| Job Information | Job_ID, Job_Level |
| Performance | Performance Rating |
| Promotions | Promotion_Date, Salary_Increase_Pct |

## 🔗 3. Data Connection & Relationship Model

The project uses employee identifiers and job-related attributes to bring workforce, compensation, performance, promotion, and salary-band information together for analysis.

### Data Integration Approach

```text
                EMPLOYEE DATA
                     |
                     |
              Employee_ID
                     |
       +-------------+-------------+
       |             |             |
       ▼             ▼             ▼
 COMPENSATION    PERFORMANCE    PROMOTIONS
       |
       |
     Job_ID
       |
       ▼
  SALARY BANDS
```

### Relationship Logic

| Tables | Matching Attribute | Analytical Purpose |
|---|---|---|
| Employees → Compensation | Employee_ID | Connect employees with their compensation records |
| Employees → Performance | Employee_ID | Analyze employee performance |
| Employees → Promotions | Employee_ID | Analyze promotion history and salary growth |
| Compensation → Salary Bands | Job_ID and applicable band attributes | Compare employee compensation with assigned salary ranges |

**Important:** The diagram describes the intended analytical connections. Confirm the exact relationship keys, cardinality, filter direction, and any composite-key logic in your actual Power BI model before treating this as the final physical schema.

### Power BI Data Model

The integrated tables are used to create a relational model for cross-table analysis.

The model supports:
- Employee-level compensation analysis.
- Department and location filtering.
- Performance-based compensation comparisons.
- Promotion and salary growth analysis.
- Salary band compliance calculations.
- Year-based trend analysis.

## 🧹 4. Data Preparation & Cleaning

Python was used for data profiling, cleaning, validation, and preparation using Pandas and NumPy.

### Techniques Applied

**1. Data Profiling**
- Inspected dataset dimensions and column names.
- Reviewed data types and unique values.
- Examined missing-value patterns.
- Checked key fields and record distributions.

**2. Missing-Value Analysis**
- Identified missing values in important analytical columns.
- Evaluated missingness before using fields in calculations.
- Prepared data for reliable analysis.

**3. Duplicate Detection**
- Checked duplicate employee and compensation records.
- Examined duplicate business keys.
- Applied deduplication where appropriate.

**4. Data Type Validation**
- Validated numeric salary and bonus fields.
- Checked date fields used for promotion and trend analysis.
- Ensured analytical columns were suitable for calculations.

**5. Cross-Table Reconciliation**
- Checked employee identifiers across related tables.
- Reviewed matching records between employee and compensation data.
- Evaluated relationships needed for integrated reporting.

**6. Feature Engineering**
- Prepared analytical attributes for salary distribution and compensation analysis.
- Used salary band information to classify compensation status.
- Prepared performance and promotion attributes for comparison.

## 🧠 5. Analytical Techniques

### A. Descriptive Analytics

Used to summarize the workforce and compensation structure.

Examples:
- Employee counts and distributions.
- Average salary and bonus.
- Department-level compensation.
- Workforce distribution by gender and job level.

### B. Comparative Analysis

Used to compare compensation across different employee groups.

Examples:
- Average salary by gender.
- Average compensation by department.
- Salary by job level.
- Compensation by performance rating.

### C. Salary Band Compliance Analysis

Employee compensation was evaluated against applicable salary band limits.

Conceptual classification:

```text
IF Compensation < Band Minimum
    → Below Band

IF Compensation >= Band Minimum
   AND Compensation <= Band Maximum
    → Within Band

IF Compensation > Band Maximum
    → Above Band
```

This classification helps identify compensation records that require further review.

### D. Gender Pay Gap Analysis

Compared average compensation across gender groups.

A general unadjusted pay-gap calculation is:

```text
Gender Pay Gap (%) =
(
    Average Male Salary - Average Female Salary
)
/
Average Male Salary
× 100
```

The interpretation depends on the selected salary measure and employee population. This comparison is descriptive and does not adjust for job level, tenure, experience, or other explanatory factors.

### E. Performance & Compensation Analysis

Compared employee performance ratings with compensation levels to identify patterns across performance categories.

### F. Promotion & Salary Growth Analysis

Examined promotion records, promotion rates, and recorded salary increases to understand career progression.

### G. Trend Analysis

Used time-based comparisons to evaluate changes in compensation and salary band compliance across reporting periods.

## 🗄️ 6. SQL & Business Analysis

SQL can be used to query and validate the integrated HR data and calculate business-level metrics.

Relevant analytical operations include:

| SQL Technique | Application |
|---|---|
| SELECT and WHERE | Retrieve and filter HR records |
| JOIN | Combine employee, compensation, and related tables |
| GROUP BY | Aggregate metrics by department, gender, and job level |
| CASE | Classify salary band status |
| COUNT and DISTINCTCOUNT logic | Calculate employee counts |
| AVG | Calculate average salary and compensation |
| CTEs | Organize multi-step analytical queries |
| Window Functions | Support ranking and comparative analysis |
| Conditional Aggregation | Calculate group-specific KPIs |


## 📐 7. Power BI & DAX Implementation

Power BI was used to develop a four-page interactive HR analytics dashboard.

### Dashboard Development Techniques

- Data modeling and table relationships.
- Power Query data transformation.
- DAX measures for KPI calculations.
- Interactive slicers and cross-filtering.
- KPI cards and conditional formatting.
- Donut charts, bar charts, and line charts.
- Department, gender, location, and job-level comparisons.
- Consistent visual design across dashboard pages.

### Example DAX Measures

**Total Employees**

```dax
Total Employees =
DISTINCTCOUNT(employees[Employee_ID])
```

**Average Total Compensation**

```dax
Avg Total Compensation =
AVERAGE(compensation[Total_Compensation])
```

**Below Band Employees**

```dax
Below Band Employees =
CALCULATE(
    DISTINCTCOUNT(compensation[Employee_ID]),
    compensation[Salary Band Status] = "Below Band"
)
```

**Above Band Employees**

```dax
Above Band Employees =
CALCULATE(
    DISTINCTCOUNT(compensation[Employee_ID]),
    compensation[Salary Band Status] = "Above Band"
)
```

**Below Band Employee Percentage**

```dax
Below Band Employee % =
DIVIDE(
    [Below Band Employees],
    DISTINCTCOUNT(compensation[Employee_ID]),
    0
)
```


## 📊 8. Dashboard Pages

### 1️⃣ Executive Workforce Overview

Provides an overview of the employee population.

**Visuals and Analysis**
- Total employees.
- Active employees.
- Total compensation.
- Average salary.
- Employee distribution by gender.
- Employee distribution by department.
- Employee distribution by job level.
- Headcount trend.
- Employee distribution by location.

**Business Question:** What does the overall workforce structure look like?

### 2️⃣ Compensation & Pay Equity

Evaluates salary distribution and compensation differences.

**Visuals and Analysis**
- Average base salary.
- Average annual bonus.
- Gender pay gap.
- Salary band compliance.
- Average salary by gender.
- Salary distribution.
- Employees by salary band.
- Average salary by department.
- Gender pay gap by department.

**Business Question:** How is compensation distributed, and where do differences require further investigation?

### 3️⃣ Performance & Career Growth

Examines performance, promotions, and salary progression.

**Visuals and Analysis**
- Average performance rating.
- High performer percentage.
- Total promotions.
- Promotion rate.
- Performance rating distribution.
- Average salary by performance rating.
- Promotions by department.
- Salary growth after promotion.
- Promotion rate by job level.

**Business Question:** How do employee performance and career progression relate to compensation?

### 4️⃣ Compensation Risk & Strategic Insights

Highlights salary band exceptions and potential compensation risks.

**Visuals and Analysis**
- Below-band employee percentage.
- Below-band employee count.
- Above-band employee count.
- Average salary growth.
- Gender pay gap.
- Compensation risk by department.
- Employees by salary band status.
- Average compensation by department.
- Salary band compliance trend.
- Employees by job level.

**Business Question:** Which departments and employee groups should HR review more closely?

## 📌 9. Key Findings & Business Insights

The following findings are based on the documented analysis and dashboard observations. Confirm them against the final refreshed dataset and measures before publishing.

### Workforce Insights

- The documented employee dataset contains 10,000 employee records.
- Workforce composition can be explored across gender, department, location, and job level.
- Department-level and location-level comparisons provide visibility into workforce distribution.

### Compensation Insights

- Salary and bonus distributions can be compared across employee groups.
- Gender-based average salary differences were identified as an area for pay-equity investigation.
- Salary band compliance analysis helps distinguish employees within, below, and above their defined ranges.

### Salary Band Findings

The documented analysis identified:

- **338 below-band compensation records**
- **1.13% of the 30,000 compensation records**

This is a record-level result, not necessarily a count of unique employees. It should not be directly compared with a distinct employee-level dashboard measure without reconciling the calculation.

### Performance & Career Growth Insights

- Compensation can be compared across performance-rating categories.
- Promotion records provide a basis for evaluating career progression.
- Salary growth analysis helps examine compensation changes associated with promotions.

### Department-Level Risk Insights

- Department-level compensation risk measures help identify areas with higher proportions of out-of-band employees.
- These departments can be prioritized for further HR review.
- Salary band exceptions should be investigated in the context of job level, location, tenure, and other relevant factors.

## 💼 10. Business Recommendations

Based on the analytical framework, HR teams can:

1. Review employees whose compensation falls outside assigned salary bands.
2. Investigate gender pay differences after accounting for relevant job-related factors.
3. Review salary structures across departments and job levels.
4. Evaluate promotion and salary growth patterns.
5. Monitor compensation compliance periodically.
6. Establish consistent compensation review procedures.
7. Use interactive reporting to support workforce planning.

**Interpretation Note:** A gender pay gap or salary band exception is a signal for further investigation, not proof of discrimination or unfair treatment.

## 🚀 13. Project Skills Demonstrated

- HR and compensation analytics.
- Data profiling and quality assessment.
- Missing-value and duplicate analysis.
- Data cleaning and feature engineering.
- Cross-table data reconciliation.
- Relational data modeling.
- SQL-based data analysis.
- Python with Pandas and NumPy.
- Power Query and DAX.
- Power BI dashboard development.
- KPI design and business insight communication.

## 👩‍💻 14. Author

**Nethravathi G**

🔗 **GitHub:** https://github.com/gnethravathi07

🔗 **LinkedIn:** https://www.linkedin.com/in/nethravathi-g-2309772b6/

---

<p align="center">
  **💜 Turning HR Data into Meaningful Insights 💛**
  <br/>
  <i>Data-Driven Decisions | Transparent Compensation | Strategic Workforce Planning</i>
</p>
