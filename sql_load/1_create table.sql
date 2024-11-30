-- creating our layoffs table 

DROP TABLE layoffs;

CREATE TABLE layoffs 
(
    company	TEXT,
    location TEXT,	
    industry TEXT,	
    total_laid_off TEXT,	
    percentage_laid_off	TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions TEXT
);    


ALTER TABLE layoffs OWNER to postgres;

COPY layoffs
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\layoffs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy layoffs FROM '[Insert File Path]/layoffs.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- created another table named layoffs_staging, this was to make sure that if I removed the wrong column, 
row or data I would still have the original data file

DROP TABLE layoffs_staging;
CREATE TABLE layoffs_staging AS 
SELECT * FROM layoffs;

