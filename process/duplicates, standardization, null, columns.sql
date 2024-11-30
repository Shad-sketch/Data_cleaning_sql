-- remove duplicates
--Standardize data
-- remove null values
--Drop columns

CREATE TABLE layoffs_staging AS 
SELECT * FROM layoffs;

--Remove duplicates

SELECT *
FROM layoffs_staging;

WITH duplicate_cte AS 
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)

DELETE 
FROM layoffs_staging
WHERE row_num > 1

CREATE TABLE layoffs_staging_2
(
    company	TEXT,
    location TEXT,	
    industry TEXT,	
    total_laid_off TEXT,	
    percentage_laid_off	TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions TEXT,
    row_num INT
);   

INSERT INTO layoffs_staging_2
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging;

DELETE 
FROM layoffs_staging_2
WHERE row_num > 1;

--standardizing data

SELECT company, TRIM(company)
FROM layoffs_staging_2

UPDATE layoffs_staging_2
SET company = TRIM(company)

SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET country =  TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'

SELECT date,
       TO_DATE(TRIM(date), 'YYYY/FMDD/FMMM') AS formatted_date
FROM layoffs_staging_2
WHERE date IS NOT NULL AND date ~ '^\d{1,2}/\d{1,2}/\d{4}$';

UPDATE layoffs_staging_2
SET date = TO_DATE(date, 'MM/DD/YYYY')  
WHERE date ~ '^\d{1,2}/\d{1,2}/\d{4}$';  

-- To change the date column from text to date 

ALTER TABLE layoffs_staging_2
ALTER COLUMN date SET DATA TYPE DATE
USING TO_DATE(date, 'YYYY/FMMM/FMDD'); 

--remove null values

SELECT *
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_2 t1
SET industry = t2.industry  
FROM layoffs_staging_2 t2
WHERE t1.company = t2.company
AND t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--drop columns

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num



