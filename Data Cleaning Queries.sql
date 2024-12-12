USE world_layoffs

SELECT MAX(total_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT YEAR([date]), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR([date])
ORDER BY 1 DESC;

SELECT SUBSTRING(CONVERT(VARCHAR(8), [date], 112), 5, 2) AS 'MONTH', SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY SUBSTRING(CONVERT(VARCHAR(8), [date], 112), 5, 2);

SELECT SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) AS month_year, SUM(total_laid_off) AS 'Total Layoffs by Month'
FROM layoffs_staging2
WHERE SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) IS NOT NULL
GROUP BY SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7)
ORDER BY 1 ASC;

WITH Rolling_Total AS
(SELECT SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) AS month_year, SUM(total_laid_off) AS 'Total Layoffs by Month'
FROM layoffs_staging2
WHERE SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) IS NOT NULL
GROUP BY SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7)
ORDER BY 1 ASC
)

SELECT month_year, Total_Layoffs_by_Month,SUM(Total_Layoffs_by_Month) OVER (ORDER BY month_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_total
FROM Rolling_Total
ORDER BY month_year ASC;

WITH Rolling_Total AS (
    SELECT 
        SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) AS month_year,
        SUM(total_laid_off) AS Total_Layoffs_by_Month
    FROM layoffs_staging2
    WHERE SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7) IS NOT NULL
    GROUP BY SUBSTRING(CONVERT(VARCHAR(10), [date], 120), 1, 7)
)

SELECT 
    month_year,
    Total_Layoffs_by_Month,
    SUM(Total_Layoffs_by_Month) OVER (ORDER BY month_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_total
FROM Rolling_Total
ORDER BY month_year ASC;

SELECT company, YEAR([date]),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR([date])
ORDER BY 3 DESC

WITH Company_Year AS (
    SELECT 
        company, 
        YEAR([date]) AS Year, 
        SUM(total_laid_off) AS [Total Laid Off]
    FROM layoffs_staging2
    GROUP BY company, YEAR([date])
)
SELECT *,DENSE_RANK() OVER (PARTITION BY Year ORDER BY [Total Laid Off] DESC) AS rank
FROM Company_Year
WHERE Year IS NOT NULL
ORDER BY Year, rank;

- changed slightly for view 

WITH Company_Year AS (
    SELECT 
        company, 
        YEAR([date]) AS years, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR([date])
)
SELECT 
    company, 
    years, 
    total_laid_off, 
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM 
    Company_Year
WHERE 
    years IS NOT NULL
ORDER BY Ranking ASC, years DESC;

Top 5 view

WITH Company_Year AS (
    SELECT 
        company, 
        YEAR([date]) AS years, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR([date])
), 
Company_Year_Rank AS (
    SELECT 
        company, 
        years, 
        total_laid_off, 
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM 
        Company_Year
    WHERE 
        years IS NOT NULL
)

SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5
ORDER BY Ranking ASC, years DESC;
