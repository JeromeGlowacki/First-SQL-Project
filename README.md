First-SQL-Project

Project Overview

This project demonstrates my SQL skills by analyzing and cleaning a dataset related to company layoffs. The goal was to identify trends, clean data inconsistencies, and produce actionable insights. This repository contains SQL scripts, queries, and findings from my work, showcasing key concepts such as Common Table Expressions (CTEs), window functions, and data partitioning.

Dataset Description

The dataset focuses on company layoffs, including:

Company Names

Industry

Location

Date of Layoffs

Total Employees Laid Off

Percentage of Workforce Laid Off

Stage of Company (e.g., Post-IPO)

Country

Funds Raised

Key Objectives

Identify and clean duplicate rows.

Correct inconsistencies in categorical data (e.g., removing trailing periods in country names).

Extract and analyze date-related information (e.g., year and month).

Perform aggregations and ranking to identify trends.

Utilize window functions to calculate rolling totals and rankings.

Key SQL Techniques Used

Common Table Expressions (CTEs): Used for simplifying complex queries and organizing transformations.

Window Functions: Applied for ranking, dense ranking, and calculating rolling totals.

Data Cleaning:

Removing duplicates using ROW_NUMBER().

Fixing inconsistent formatting (e.g., RTRIM() and REPLACE()).

Handling null values.

Date Functions:

Extracting year and month using YEAR() and SUBSTRING().

Converting date formats using CONVERT().

Aggregations and Grouping: Summing layoffs by year and industry.

Key Findings

Top Companies with Layoffs:

Identified companies with the highest layoffs for each year using DENSE_RANK().

Example: In 2022, Meta had the most layoffs (11,000).

Yearly Trends:

Grouped layoffs by year to visualize trends in the dataset.

Example: Total layoffs increased significantly from 2020 to 2022.

Rolling Totals:

Calculated rolling totals of layoffs by month to observe cumulative trends.

Data Cleaning:

Removed duplicate rows and fixed formatting issues such as inconsistent country names (e.g., "United States." to "United States").

Repository Structure

|-- SQL Files
|   |-- data_cleaning.sql  # Scripts for cleaning the dataset
|   |-- analysis_queries.sql  # Queries for analysis and insights
|-- Results
|   |-- screenshots/  # Visual results from SQL queries
|-- README.md  # Overview of the project

Example Queries

Identifying Duplicates

WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, [date] ORDER BY company) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

Cleaning Inconsistent Data

UPDATE layoffs_staging
SET country = RTRIM(REPLACE(country, '.', ''))
WHERE country LIKE '%.';

Ranking Companies by Layoffs

WITH Company_Year AS (
    SELECT
        company,
        YEAR([date]) AS years,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging
    GROUP BY company, YEAR([date])
)
SELECT
    company,
    years,
    total_laid_off,
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL;

Tools Used

SQL Server for query execution and database management.

GitHub for version control and project sharing.

