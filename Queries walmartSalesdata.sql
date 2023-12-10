-- --------------------------Create database-------------------------------------------
CREATE DATABASE IF NOT EXISTS walmartSales;

-- ---------------------------Create table---------------------------------------------
CREATE TABLE IF NOT EXISTS sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  tax_pct FLOAT NOT NULL,
  total DECIMAL(12, 4) NOT NULL,
  date DATETIME NOT NULL,
  time TIME NOT NULL,
  payment VARCHAR(15) NOT NULL,
  cogs DECIMAL(10,2) NOT NULL,
  gross_margin_pct FLOAT,
  gross_income DECIMAL(12, 4),
  rating FLOAT
);
select * from sales;

-- ------As there are no null values in the tble because i have used not null ---------

-- -----------------------Feature engineering -----------------------------------------
select time,
        (case 
            when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
		End
) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
       case 
            when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
	   End
);

-- ------------------------------------------------------------------------------------------
-- -----------------------------------Day name------------------------------------------

SELECT DAYNAME(date) AS extracted_day_name
FROM sales;
    
    
alter table sales add column day varchar(30);

update sales 
set day = (SELECT DAYNAME(date) AS extracted_day_name);
    
    
-- ------------------------------Month name--------------------------------------------

SELECT date,MONTHNAME(date) AS extracted_month_name
FROM sales;
    
alter table sales add column month varchar(30);

update sales 
set month = (SELECT MONTHNAME(date) AS extracted_month_name);
 -- -----------------------------------------------------------------------------------------   

-- --------------------------GENERIC QUESTIONS ----------------------------------------------
# 1.How many unique cities does the data have?

   select count(distinct city) from sales;


# 2. which city is each branch?
 
   select distinct branch ,city from sales;

-- ----------------------------------PRODUCTS QUESTIONS---------------------------------------
#1.How many unique product lines does the data have?

   select distinct product_line from sales;

#2.What is the most common payment method?
  select payment,count(payment) 
  from sales 
  group by payment 
  order by count(payment) desc;
  
  
#3.What is the most selling product line?
  select product_line ,count(product_line)
  from sales
  group by product_line
  order by count(product_line) desc;


#4.What is the total revenue by month?

	select month,sum(total)
    from sales
    group by month
    order by month asc;
    
#5.What month had the largest COGS?
	select month ,sum(cogs)
    from sales 
    group by month
    order by month;


#6.What product line had the largest revenue?
    select product_line,sum(total)
    from sales
    group by product_line
    order by sum(total) desc;


#7.What is the city with the largest revenue?
	select city,sum(total)
    from sales
    group by city
    order by sum(total) desc;
    

#8.What product line had the largest VAT?
	select product_line,avg(tax_pct)
    from sales
    group by product_line
    order by avg(tax_pct) desc;
    
    
#9.Fetch each product line and add a column to those product line showing "Good", "Bad". 
#Good if its greater than average sales

	SELECT AVG(quantity) AS avg_qnty FROM sales;

SELECT product_line,
	CASE
		WHEN avg(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

	
#10.Which branch sold more products than average product sold?
	select branch , sum(quantity)
	from sales 
    group by branch
    having sum(quantity) > (select avg(quantity) from sales );


#11.What is the most common product line by gender?
    select  gender ,product_line,count(gender)
    from sales
    group by gender ,product_line
    order by count(gender) desc;


#12.What is the average rating of each product line?
	select product_line , avg(rating)
    from sales
    group by product_line
    order by avg(rating) desc;
-- -------------------------------------------------------------------------------------

-- ------------------------------- Sales ------------------------------------------------
#1.Number of sales made in each time of the day per weekday
	select time_of_day,count(*) 
    from sales
    group by time_of_day
    order by time_of_day asc;
    

#2.Which of the customer types brings the most revenue?
	select customer_type,sum(total)
    from sales
    group by customer_type;


#3.Which city has the largest tax percent/ VAT (Value Added Tax)?
	select city ,max(tax_pct) 
    from sales
    group by city;
    

#4.Which customer type pays the most in VAT?
	select customer_type,sum(total)
    from sales
    group by customer_type;

-- -------------------------------------------------------------------------------------


-- ----------------------------------Customer-------------------------------------------
#1.How many unique customer types does the data have?
	
    select distinct customer_type from sales;


#2.How many unique payment methods does the data have?
	
    select distinct payment from sales;


#3.What is the most common customer type?

	select customer_type,count(*)
    from sales
    group by customer_type;


#4.Which customer type buys the most?
	select customer_type ,sum(total)
	from sales
    group by customer_type;


#5.What is the gender of most of the customers?

	select gender ,count(*)
    from sales
    group by gender;


#6.What is the gender distribution per branch?

	select branch ,gender,count(gender)
    from sales
    group by branch,gender
    order by branch asc;


#7.Which time of the day do customers give most ratings?

	select time_of_day, count(rating)
    from sales
    group by time_of_day;


#8.Which time of the day do customers give most ratings per branch?
	
    select branch,time_of_day,count(rating)
    from sales
    group by branch,time_of_day
    order by branch,time_of_day;
    
    
#9.Which day fo the week has the best avg ratings?

	select day ,avg(rating) 
    from sales
    group by day
    order by avg(rating) desc;
    

#10.Which day of the week has the best average ratings per branch?

	select branch,day,avg(rating)
    from sales
    group by branch,day
    order by branch,day;
    
