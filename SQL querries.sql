CREATE DATABASE IF NOT EXISTS salesDatawalmart;
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
Gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date DATETIME not null,
Time TIME not null,
payment_mthod varchar(15) not null,
cogs DECIMAL(10,2) not null,
gross_margin_pct FLOAT(10,9),
gross_income Decimal(12,4) not null,
Rating FLOAT(2,1)
);



--   ---------------------------------------------------------------
-- ----------------------------Feature Engineering------------------

-- time_of_day

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD Column time_of_day Varchar(20);

UPDATE sales
SET time_of_day = (
   CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- day_name----------

SELECT 
     date,
     dayname(date)
FROM Sales;

ALTER TABLE sales ADD column day_name varchar(10);

UPDATE sales
SET  day_name = dayname(date);

-- Month name ---------------

Select 
      date,
      monthname(date)
FROM sales;

ALTER TABLE sales ADD column month_name varchar(10);

UPDATE sales
SET month_name = monthname(date);

-- ------------------------------------------------------------
-- ------------------Generic-----------------------------------
-- How many unique cities does the data have?
Select
	distinct city from sales;
-- In which city is each braanch?   
Select
	distinct branch from sales;
    
select 
     distinct city,
     branch
from sales;

-- ----------------------------------------------------------
-- ================== Product-------------------------------
-- How many unique product lines does the data have?

SELECT
  distinct product_line
from sales;
-- What is the most common payment method?
Select 
     payment_mthod
From sales;
Select 
       payment_mthod,
     count(payment_mthod) As cnt
From sales
group by payment_mthod
order by cnt DESC;
-- ------------------------------------------------------
-- What is the most selling product line?
Select 
	 product_line,
     count(product_line) as CNTT
from sales
group by product_line
order by cntt desc;

-- -------------------------------------------------
-- What is the total revenue by month?
Select  
      month_name as Month,
      sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?

Select  
      month_name as month,
      sum(cogs) as Cogss
from sales
group by month
order by cogss desc;

-- What product line had the largest revenue?

select product_line,
     sum(total) As Total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?

select city, branch,
     sum(total) As Total_revenue
from sales
group by city, branch
order by total_revenue desc;

-- What product line had the largest VAT?
select product_line,
     avg(VAT) As Tax
from sales
group by product_line
order by Tax desc;

-- Fetch each product line and add a column to those product line showing 
-- "Good", "Bad". Good if its greater than average sales

-- Which branch sold more products than average product sold?
select 
     branch,
     sum(quantity) as Qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?     
Select 
      product_line, gender,
      count(gender) as total_cnt
from sales
group by product_line, Gender
order by total_cnt desc;      

-- What is the average rating of each product line?

select product_line,
      round(avg(rating),2) as avr_rating
from sales
group by product_line
order by avr_rating desc;

--  ----------------------------SALES---------------------------------

-- Number of sales made in each time of the day per weekday

SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
WHERE
    day_name = 'sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- like this we can check for each day

-- Which of the customer types brings the most revenue?

select 
      customer_type,
      sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select
      branch, city,
      avg(vat) as tax
from sales
group by city, branch
order by tax desc;
      
-- Which customer type pays the most in VAT?

Select 
      customer_type,
      sum(vat) as Tax
from sales
group by customer_type;

-- -----------------------CUSTOMER--------------------
-- How many unique customer types does the data have?
 select distinct customer_type from sales;

-- How many unique payment methods does the data have?

select distinct payment_mthod from sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?

select customer_type,
       count(*) as most_buyer
from sales
group by customer_type
order by most_buyer desc;

-- What is the gender of most of the customers?
SELECT Gender,
      count(gender) As gender_cnt
from sales
group by Gender;

-- What is the gender distribution per branch?

select 
      gender,
      count(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?
select time_of_day,
	avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch? 
select time_of_day,
	avg(rating) as avg_rating
from sales
where branch = "B"
group by time_of_day
order by avg_rating desc;

-- Which day fo the week has the best avg ratings?

select day_name,
	avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?

select day_name,
	avg(rating) as avg_rating
from sales
where branch = "A"
group by day_name
order by avg_rating desc;






