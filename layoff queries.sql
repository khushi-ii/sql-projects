create database layoff;
use layoff;
create table layoff_staging 
like layoffs;

insert layoff_staging
select * from layoffs;

select * from layoff_staging;


with cte as(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from layoff_staging)
select * from cte
where row_num >1;

select * from layoff_staging
where company='Casper';



CREATE TABLE `layoffs_staging4` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
`row_num` INT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging4
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;
select * from layoffs_staging4 where row_num>1;


insert into layoffs_staging4
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from layoff_staging;


select company,trim(company)
from layoffs_staging4;
SET SQL_SAFE_UPDATES = 0;
update layoffs_staging4
set company=trim(company);


select * from layoffs_staging4
where industry='crypto%';

select distinct country ,trim(trailing '.' from country)
from layoffs_staging4
order by 1;

update layoffs_staging4
set country=trim(trailing '.' from country)
where country='united states%';

update layoffs_staging4
set industry='crypto'
 where industry='crypto%';
 
update layoffs_staging4
 set `date`=str_to_date(`date`,'%m/%d/%Y');
 
 select `date` from layoffs_staging4;
 alter table layoffs_staging4
 modify column `date` date;
 
 select * from layoffs_staging4
 where total_laid_off is NULL
 and percentage_laid_off is NULL;
 
 select * from layoffs_staging4
 where industry is NULL or industry='';
 
 select * from layoffs_staging4
 where company='airbnb';
 
 update layoffs_staging4
 set industry=NULL
 where industry='';
 
 update layoffs_staging4 t1
 join  layoffs_staging4 t2
 on t1.company=t2.company
 set t1.industry=t2.industry
 where t1.industry is NULL 
 and t2.industry is not null;
 
select * from layoffs_staging4
where industry is null or industry='';

delete from layoffs_staging4
where total_laid_off is null and percentage_laid_off is null;

alter table layoffs_staging4
drop column row_num;