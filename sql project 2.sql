create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

select *from zepto;

select * from zepto
limit 10;

select count(*) from zepto;

--null values in each cloumn

select * from zepto
where
name  IS Null
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--deffernt product category
select distinct category,quantity as number 
from zepto
order by category;

--products in stock vs out of stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

--product names present multiple times

select name , count(sku_id) as "Numer of SKUs"
from zepto
group by name 
having count(sku_id) >1
order by count(sku_id) desc;

--data cleaning

--products with price = 0
select *from zepto
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto 
where mrp = 0;

--convert paise to rupees
update zepto
set mrp = mrp/100, discountedSellingPrice = discountedSellingPrice/100;

select *from zepto;


--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


--Q2.What are the Products with High MRP but Out of Stock
select distinct name , mrp
from zepto
where outofstock = True and mrp > 300
order by mrp desc;

select distinct name , mrp
from zepto
where outofstock = True and mrp > 200
order by mrp desc;


--Q3.Calculate Estimated Revenue for each category
select category, sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name , mrp , discountPercent
from zepto
where discountPercent < 10 and mrp > 300
order by mrp desc 

select distinct name , mrp , discountPercent
from zepto
where discountPercent < 10 and mrp > 500
order by mrp desc , discountPercent desc ;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category , avg(discountPercent) as Average_dis
from zepto
group by category
order by category desc
limit 5;

select category , round(avg(discountPercent),2) as Average_dis
from zepto
group by category
order by category desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
(discountedSellingPrice/weightInGms) as prize_per_gram
from zepto
where weightInGms >=100
order by prize_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


--Q8.What is the Total Inventory Weight Per Category

select category , sum(weightInGms*availableQuantity) as Total_weight
from zepto
group by category
order by Total_weight desc;

