# 💜 Strategic Compensation and Pay Equity Analytics

<p align="center">
  <img src="https://img.shields.io/badge/HR%20Analytics-Compensation-8E44AD?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Python-Pandas%20%7C%20NumPy-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Power%20BI-DAX%20%7C%20Power%20Query-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/Project-HR%20Analytics-9B59B6?style=for-the-badge" />
</p>

<p align="center">
  
---

# Strategic Compensation & Pay Equity Analytics

An End-to-End HR Analytics, Compensation Intelligence, and Pay Equity Analysis Project using **Python, MySQL, SQL, and Microsoft Power BI**.

---

## 1. Project Overview

Strategic Compensation & Pay Equity Analytics is an end-to-end data analytics project designed to examine employee compensation structures, workforce demographics, salary distribution, gender pay differences, performance ratings, promotion patterns, and salary band compliance.

The project transforms raw HR datasets into meaningful business insights through data cleaning, exploratory data analysis, statistical analysis, SQL-based business intelligence, and interactive Power BI dashboards.

The objective is to help HR teams and business leaders understand compensation patterns, identify potential pay equity concerns, monitor salary structures, and make more informed workforce compensation decisions.

## 2. Business Objectives

- Analyze workforce composition across departments, job levels, locations, and gender.
- Evaluate base salary, annual bonuses, and total compensation.
- Examine gender-based salary differences across comparable employee groups.
- Identify salary band positioning and potential compensation risks.
- Analyze the relationship between employee performance and compensation.
- Evaluate promotion patterns and salary increases.
- Track workforce and compensation trends over time.
- Translate analytical findings into actionable HR recommendations.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data cleaning, EDA, statistical analysis, and pay equity analysis |
| Pandas & NumPy | Data manipulation and numerical calculations |
| Matplotlib & Seaborn | Exploratory data visualization |
| SciPy | Statistical hypothesis testing |
| Scikit-learn / Statsmodels | Regression and analytical modeling, where applicable |
| MySQL | Relational database storage and data management |
| SQL | Data validation, joins, aggregations, and business analysis |
| Microsoft Power BI | Interactive dashboards and business intelligence |
| Jupyter Notebook | Python analysis environment |
| GitHub | Project documentation and version control |

## 4. Dataset Overview

The project uses seven CSV files covering employee information, compensation, performance, promotions, job structures, and salary benchmarks.

| Dataset | Description |
|---|---|
| `employees.csv` | Employee demographics, department, location, job level, and experience |
| `compensation.csv` | Employee salary, bonus, and compensation records |
| `performance.csv` | Employee performance ratings and review information |
| `promotions.csv` | Employee promotion history and salary increases |
| `jobs.csv` | Job titles, job levels, and job-related information |
| `salary_bands.csv` | Salary ranges and compensation benchmarks |
| `data_dictionary.csv` | Dataset and column definitions |

**Analytical scope:** The project includes employee-level analysis for the 2026 compensation snapshot, along with historical compensation and promotion analysis where applicable.

## 5. Python Analysis

Python was used to perform the initial data preparation, quality checks, exploratory analysis, and detailed pay equity investigation.

Five Jupyter notebooks were completed.

### Notebook 01 — Data Understanding

**Objective:** Understand the structure and contents of the available HR datasets.

Activities performed:
- Loaded all seven CSV files.
- Examined dataset dimensions and column names.
- Reviewed data types and statistical summaries.
- Identified primary and foreign key candidates.
- Examined relationships between employee, compensation, performance, promotion, job, and salary band datasets.
- Evaluated the overall suitability of the data for analysis.

### Notebook 02 — Data Quality Audit

**Objective:** Identify data quality issues before analysis.

Activities performed:
- Checked missing values.
- Identified duplicate records.
- Validated employee identifiers.
- Examined invalid and inconsistent values.
- Checked compensation and performance records.
- Identified pre-hire compensation and performance records.
- Reviewed salary band ranges and key integrity.
- Evaluated data consistency across related datasets.

### Notebook 03 — Data Cleaning

**Objective:** Prepare reliable datasets for downstream analysis.

Activities performed:
- Removed duplicate compensation records.
- Identified and excluded pre-hire records from relevant employee-year analyses.
- Reconstructed missing annual bonus values where supported by the available compensation information.
- Recovered missing performance ratings from the corresponding performance categories where possible.
- Standardized missing education information.
- Retained missing experience values with appropriate handling flags.
- Validated salary band ranges and key uniqueness.
- Reconciled compensation components and checked cleaned dataset integrity.

### Notebook 04 — Exploratory Data Analysis

**Objective:** Understand workforce and compensation patterns.

Areas examined:
- Employee demographics and workforce distribution.
- Department and job-level composition.
- Salary and bonus distributions.
- Compensation differences across departments and locations.
- Performance rating distributions.
- Promotion patterns.
- Salary trends and compensation characteristics.
- Relationships between workforce attributes and compensation.

### Notebook 05 — Pay Equity Analysis

**Objective:** Investigate gender-based compensation differences using multiple analytical approaches.

Activities performed:
- Calculated the overall gender pay gap.
- Compared compensation within comparable job and location groups.
- Examined weighted and unweighted group-level pay differences.
- Conducted experience-stratified comparisons.
- Conducted performance-stratified comparisons.
- Examined combined experience and performance groups.
- Analyzed salary band positioning by gender.
- Performed statistical hypothesis testing.
- Used bootstrap resampling to evaluate uncertainty.
- Developed adjusted regression models.
- Compared gender-only, job/location-adjusted, and fully adjusted models.
- Evaluated regression residuals and model performance.
- Conducted sensitivity analysis.
- Reviewed employee exclusions and analysis coverage.
- Prepared final business findings and recommendations.

### Key Python Analysis Results

The completed Python analysis reported:

| Metric | Result |
|---|---:|
| Employees in 2026 analysis | 10,000 |
| Average base salary | ₹2,047,550.81 |
| Average total compensation | ₹2,363,933.67 |
| Total compensation expense | ₹23,639,336,677.50 |
| Comparable job groups | 281 |
| Employees covered by comparable groups | 9,628 |
| Comparable-group weighted pay gap | 1.89% |
| Experience-stratified weighted gap | 1.95% |
| Performance-stratified weighted gap | 1.86% |
| Combined stratification weighted gap | 1.85% |
| Fully adjusted regression estimate | Approximately -1.94% |
| Regression R² | 0.9944 |

**Statistical interpretation:** The fully adjusted regression estimated female compensation to be approximately 1.94% lower than male compensation after accounting for the included explanatory variables. This is an observed statistical association, not proof of discrimination or causation.

The analysis also used a bootstrap confidence interval and sensitivity checks to assess the stability of the estimated pay difference.

## 6. MySQL Database and SQL Analysis

MySQL was used as the relational database layer for structured data storage, validation, and business analysis.

**Database name:** `Compensation_Pay_Equity_DB`

### Database Activities

- Created and organized the project database.
- Loaded the project datasets into relational tables.
- Examined table structures and column definitions.
- Validated employee identifiers and record consistency.
- Checked duplicate records and missing values.
- Reviewed relationships between employee, compensation, performance, promotion, job, and salary band data.
- Used joins to combine related HR information.
- Applied aggregations and conditional logic to answer business questions.

### SQL Analysis Areas

The SQL work covered 12 SQL script files and focused on the following analytical areas:

1. **Data Validation**
   - Record counts and table checks.
   - Duplicate identification.
   - Missing value checks.
   - Key and relationship validation.

2. **Workforce Analysis**
   - Employee distribution by department.
   - Employee distribution by job level.
   - Gender and location segmentation.
   - Workforce composition analysis.

3. **Compensation Analysis**
   - Average base salary.
   - Annual bonus analysis.
   - Total compensation calculations.
   - Department-level compensation comparisons.
   - Salary distribution analysis.

4. **Gender Pay Equity**
   - Gender-based salary comparisons.
   - Department-level pay differences.
   - Job-level compensation comparisons.
   - Comparable employee group analysis.

5. **Salary Band Analysis**
   - Salary band positioning.
   - Below-band and above-band employee identification.
   - Salary range compliance analysis.

6. **Performance and Promotion Analysis**
   - Performance rating distribution.
   - Promotion counts and rates.
   - Salary increase analysis.
   - Performance and compensation comparisons.

7. **Historical and Trend Analysis**
   - Year-over-year compensation comparisons.
   - Salary growth analysis.
   - Historical workforce and compensation trends.

8. **Final Business Insights**
   - Identified important compensation patterns.
   - Evaluated potential areas of compensation risk.
   - Prepared SQL-based business findings.

### SQL Business Value

The SQL phase made it possible to analyze the HR data through structured queries, combine related datasets, validate analytical results, and prepare business-level metrics for reporting.

## 7. Power BI — Interactive Dashboard Development

Microsoft Power BI was used to develop an interactive HR compensation and workforce intelligence report.

**Data connection:** Power BI connected to the MySQL database `Compensation_Pay_Equity_DB`, allowing the dashboard to use the structured database tables rather than relying only on disconnected CSV files.

### Dashboard Design

The completed dashboard contains four analytical pages.

### Page 1 — Executive Workforce Overview

**Purpose:** Provide a high-level view of workforce structure and employee demographics.

Key performance indicators:
- Total Employees
- Active Employees
- Average Base Salary
- Average Annual Bonus
- Total Compensation

Visualizations:
- Employees by Gender
- Employees by Department
- Employees by Job Level
- Head Count Trend
- Employees by Location

Business questions answered:
- How large is the workforce?
- How is the workforce distributed by gender?
- Which departments have the highest employee counts?
- Which job levels have the largest workforce?
- How has employee headcount changed over time?
- Which locations have the highest employee concentration?

### Page 2 — Compensation & Pay Equity Analytics

**Purpose:** Analyze compensation structures, gender-based salary differences, and salary band positioning.

Key performance indicators:
- Average Base Salary
- Average Annual Bonus
- Total Compensation
- Gender Pay Gap %
- Salary Band Compliance %

Visualizations:
- Average Salary by Gender
- Salary Distribution
- Employees by Salary Band
- Gender Pay Gap by Department
- Average Salary by Department

Business questions answered:
- How does average salary differ across gender groups?
- How is compensation distributed across salary ranges?
- How many employees fall below, within, or above salary bands?
- Which departments show larger gender pay differences?
- Which departments have higher average compensation?

### Page 3 — Performance & Career Growth Analytics

**Purpose:** Understand employee performance, promotion activity, and salary growth.

Key performance indicators:
- Average Performance Rating
- High Performance %
- Total Promotions
- Promotion Rate
- Average Salary Growth %

Visualizations:
- Promotion Rate by Performance Rating
- Average Salary by Performance Rating
- Promotion by Department
- Average Salary Growth Trend
- Performance Rating Distribution

Business questions answered:
- How are employee performance ratings distributed?
- Which performance categories have higher promotion rates?
- How does average salary vary by performance rating?
- Which departments have higher promotion activity?
- How has salary growth changed over time?

### Page 4 — Compensation Risk & Strategic Insights

**Purpose:** Highlight potential compensation risks and areas that require HR attention.

Key performance indicators:
- Compensation Risk %
- Below Band Employees
- Above Band Employees
- Average Salary Growth
- Gender Pay Gap

Visualizations:
- Compensation Risk by Department
- Average Compensation by Department
- Salary Band Compliance Trend
- Employees by Job Level
- Key Strategic Insights

Business questions answered:
- Which departments have higher out-of-band rates?
- How many employees fall below or above their salary bands?
- How is compensation distributed across departments?
- How has salary band compliance changed over time?
- Which workforce segments may need further compensation review?

### Dashboard Interactivity

The report includes common slicers for:
- Year
- Job Level Category
- Department

These filters allow users to explore compensation, workforce, performance, and risk metrics across different employee segments.

The dashboard uses KPI cards, bar charts, donut charts, trend charts, and analytical summaries to communicate the findings clearly.

## 8. Key Dashboard Findings

The following figures are displayed in the submitted Power BI dashboard.

### Workforce Overview
- Total employees: 10,000.
- Active employees: 9,467.
- Average base salary: approximately ₹2.09M.
- Average annual bonus: approximately ₹250.96K.
- Bengaluru has the largest displayed location-level employee count, at 2,450.

### Compensation and Pay Equity
- Displayed gender pay gap: 1.6%.
- Displayed salary band compliance: 99.87%.
- The dashboard identifies employees below and above salary bands.
- Gender-based compensation comparisons are available by department.

### Performance and Career Growth
- Average performance rating: 3.20.
- High performance percentage: 63.81%.
- Total promotions displayed: 2,605.
- Promotion rate displayed: 26.05%.
- Average salary growth displayed: 14.57%.

### Compensation Risk
- Displayed compensation risk: 1.48%.
- Displayed below-band employees: 148.
- Displayed above-band employees: 1.
- Sales and Human Resources are highlighted as departments with comparatively higher out-of-band rates in the dashboard.

These are dashboard-displayed metrics. Their definitions, filters, and calculation periods should be checked against the corresponding SQL queries and Power BI measures before comparing them directly with Python outputs.

## 9. Overall Business Insights

The combined analysis provides several important HR and compensation perspectives:

1. **Workforce Structure:** Employee distribution across departments, locations, and job levels helps HR understand workforce concentration.

2. **Compensation Visibility:** Salary and bonus analysis provides a structured view of employee compensation across organizational segments.

3. **Pay Equity Monitoring:** Comparable-group and adjusted regression analysis offers a more meaningful assessment of gender-based compensation differences than an overall average comparison alone.

4. **Salary Band Management:** Employees outside their salary bands can be identified for further review and compensation planning.

5. **Performance and Rewards:** Performance ratings, promotions, and salary growth can be examined together to understand career progression and compensation patterns.

6. **Strategic HR Decisions:** Department-level and workforce-level findings can help prioritize compensation reviews and improve monitoring practices.

## 10. End-to-End Project Workflow

The project follows this analytical workflow:

```text
Raw HR CSV Datasets
        |
        v
Python - Data Understanding
        |
        v
Data Quality Audit
        |
        v
Data Cleaning
        |
        v
Exploratory Data Analysis
        |
        v
Pay Equity & Statistical Analysis
        |
        v
MySQL Database
        |
        v
SQL Data Validation & Business Analysis
        |
        v
Power BI - MySQL Data Connection
        |
        v
Interactive Dashboard Development
        |
        v
Business Insights & Recommendations
```

## 11. Project Structure

```text
Strategic Compensation & Pay Equity Analytics/
│
├── data/
│   ├── compensation.csv
│   ├── data_dictionary.csv
│   ├── employees.csv
│   ├── jobs.csv
│   ├── performance.csv
│   ├── promotions.csv
│   └── salary_bands.csv
│
├── notebooks/
│   ├── 01_Data_Understanding.ipynb
│   ├── 02_Data_Quality_Audit.ipynb
│   ├── 03_Data_Cleaning.ipynb
│   ├── 04_Exploratory_Data_Analysis.ipynb
│   └── 05_Pay_Equity_Analysis.ipynb
│
├── sql/
│   └── SQL analysis scripts (12 files)
│
├── powerbi/
│   └── Compensation_Pay_Equity_Analysis.pbix
│
├── reports/
│   └── Strategic Compensation & Pay Equity Analytics.pdf
│
└── README.md
```

## 12. Skills Demonstrated

**Python**
- Data cleaning and preprocessing
- Exploratory data analysis
- Data transformation
- Statistical hypothesis testing
- Bootstrap analysis
- Regression modeling
- Sensitivity analysis
- Data visualization

**MySQL and SQL**
- Database management
- Data validation
- Joins and aggregations
- Subqueries and conditional logic
- Compensation analysis
- Window and trend analysis
- Business query development

**Power BI**
- MySQL data connectivity
- Data modeling and relationships
- DAX measures and calculated metrics
- KPI development
- Interactive report design
- Slicers and cross-filtering
- Business intelligence storytelling

**Business and Analytical Skills**
- HR analytics
- Compensation analytics
- Pay equity investigation
- Salary benchmarking
- Workforce analysis
- Performance and promotion analysis
- Business insight development

## 13. Important Analytical Considerations

- A gender pay gap is an observed difference in compensation and does not independently establish discrimination.
- Comparisons should consider relevant factors such as job level, department, location, experience, and performance.
- Missing or excluded records can affect analytical coverage and should be monitored.
- Salary band compliance is a monitoring indicator, not proof that every employee's compensation is equitable.
- Dashboard metrics should be reconciled with the underlying SQL and Python calculations, particularly where filters, reporting periods, and aggregation levels differ.

## 14. Conclusion

Strategic Compensation & Pay Equity Analytics demonstrates an end-to-end analytical workflow combining Python, MySQL, SQL, and Power BI.

The project begins with raw HR datasets, performs structured data quality checks and cleaning, investigates compensation and pay equity using statistical methods, applies SQL for relational analysis, and presents the findings through interactive Power BI dashboards.

The final solution provides a consolidated view of workforce composition, compensation structure, pay equity, employee performance, career growth, and compensation risk.

It demonstrates how data analytics can support more transparent compensation monitoring, informed HR decisions, and evidence-based workforce planning.

---

**Project Category:** Human Resources Analytics | Compensation Analytics | Pay Equity | Business Intelligence

**Tools:** Python | MySQL | SQL | Microsoft Power BI

**Project Type:** End-to-End Data Analytics & Business Intelligence Project
