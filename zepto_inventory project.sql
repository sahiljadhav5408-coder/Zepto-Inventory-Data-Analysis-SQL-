# create a database 
create database zepto_inventory;

# use the database
use zepto_inventory;

# show the all table of the database
select * from zepto_v2;

# show the all record in the database
select count(*) as total_record
from zepto_v2;

# Q1. Display all records from the dataset.
select * from zepto_v2;

# Q2. Find the total number of products.
select count(*) as total_product
from zepto_v2;

# Q3. Find all unique product categories
select distinct Category
from zepto_v2;

# Q4. Find the total number of categories.
select count(distinct Category) as total_category
from zepto_v2;

# Q5. Find all products that are currently out of stock.
select * from zepto_v2
where outOfStock = true;

#Q6. Find all products that are currently in stock.
select * from zepto_v2
where outOfStock = false;

#Q7. Find the most expensive product based on MRP.
select Category, name , mrp 
from zepto_v2
order by mrp desc
limit 1;

#Q8. Find the cheapest products based on discounted selling price.
select Category, name , discountedSellingPrice
from zepto_v2
order by discountedSellingPrice asc
limit 1;

#Q9. Find products having discounts greater than 20%.
select Category,name,discountPercent
from zepto_v2
where discountPercent > 20
order by discountPercent desc;

#Q10. Find products weighing more than 500 grams.
select Category,name,weightInGms
from zepto_v2
where weightInGms > 500
order by weightInGms desc;

#Q11. Count the number of products in each category.
select Category,count(*) as number_product
from zepto_v2
group by Category
order by number_product;

#Q12. Find the average MRP of each category.
select Category,round(avg(mrp)/100,2) as avg_mrp
from zepto_v2
group by Category
order by avg_mrp;

#Q13. Find the average discount offered in each category.
select Category,round(avg(discountPercent),2) as avg_discountPercent
from zepto_v2
group by Category
order by avg_discountPercent;

#Q14. Find the total number of in-stock and out-of-stock products.
select outOfStock , count(*) as total_product
from zepto_v2
group by outOfStock;

#Q15. Find the percentage of products that are out of stock.
select round(sum(case when outOfStock = true then 1 else 0 end)* 100.0 / count(*), 2) as out_of_stock_percentage
from zepto_v2;

#Q16. Find categories having more than 100 products.
select Category , count(*) as total_product
from zepto_v2
group by Category
having count(*) > 100
order by total_product desc;

#Q17. Find the maximum and minimum discount in each category.
select Category,max(discountPercent) as maximum_discount , min(discountPercent) as minimum_discount
from zepto_v2
group by Category;

#Q18. Calculate the average discounted selling price for each category.
select Category,round(avg(discountedSellingPrice)/100,2) as avg_discounted_price
from zepto_v2
group by Category
order by avg_discounted_price desc;

#Q19. Find products having an MRP greater than the overall average MRP.
select name , Category , round(mrp/100,2) as mrp
from zepto_v2
where mrp > (
select avg(mrp)
from zepto_v2
)
order by mrp desc;

#Q20. Find the top 10 products offering the highest discounts.
select name , Category ,discountPercent, round(mrp/100,2) as mrp,round(discountedSellingPrice/100,2) as selling_price
from zepto_v2
order by discountPercent desc
limit 10;

#Q21. Calculate the total potential inventory value for each category.
select Category,round(sum(discountedSellingPrice * availableQuantity) / 100, 2) as potential_inventory_value
from zepto_v2
where outOfStock = false
group by Category
order by potential_inventory_value desc;

# Q22. Find products having a discount greater than their category's average discount.
select name,Category,discountPercent
from (
select name,Category,discountPercent,
avg(discountPercent) over(partition by Category) as avg_discount
from zepto_v2
) as a
where discountPercent>avg_discount;

# Q23. Rank products based on discount percentage within each category.
select name,Category,discountPercent,
rank() over(partition by Category order by discountPercent desc) as product_rank
from zepto_v2;

# Q24. Find the top 3 discounted products from each category.
with a as(
select name,Category,discountPercent,
dense_rank() over(partition by Category order by discountPercent desc) as rnk
from zepto_v2
)
select *
from a
where rnk<=3;

# Q25. Calculate the savings amount for each product.
select name,Category,
round(mrp/100,2) as mrp,
round(discountedSellingPrice/100,2) as selling_price,
round((mrp-discountedSellingPrice)/100,2) as savings
from zepto_v2
order by savings desc;

# Q26. Find products having discounts above 20% but are out of stock.
select name,Category,discountPercent,outOfStock
from zepto_v2
where discountPercent>=20 and outOfStock=true
order by discountPercent desc;

# Q27. Calculate product availability percentage for each category.
select Category,
count(*) as total_products,
sum(case when outOfStock=false then 1 else 0 end) as available_products,
round(sum(case when outOfStock=false then 1 else 0 end)*100.0/count(*),2) as availability_percentage
from zepto_v2
group by Category
order by availability_percentage desc;

# Q28. Identify products having incorrect discount calculations.
select name,Category,discountPercent,
round((mrp-discountedSellingPrice)*100.0/nullif(mrp,0),2) as calculated_discount
from zepto_v2
where mrp>0
and abs(discountPercent-((mrp-discountedSellingPrice)*100.0/mrp))>1;

# Q29. Find duplicate product records.
select Category,name,count(*) as duplicate_count
from zepto_v2
group by Category,name
having count(*)>1
order by duplicate_count desc;

# Q30. Divide products into different discount categories.
select name,Category,discountPercent,
case
when discountPercent=0 then 'No Discount'
when discountPercent<=10 then 'Low Discount'
when discountPercent<=20 then 'Medium Discount'
else 'High Discount'
end as discount_category
from zepto_v2;

# Q31. Find the most expensive product in each category.
with a as(
select name,Category,mrp,
rank() over(partition by Category order by mrp desc) as rnk
from zepto_v2
)
select name,Category,round(mrp/100,2) as mrp
from a
where rnk=1;

# Q32. Find categories having an average discount greater than 10%.
select Category,round(avg(discountPercent),2) as avg_discount
from zepto_v2
group by Category
having avg(discountPercent)>10
order by avg_discount desc;

# Q33. Find categories having the highest out-of-stock products.
select Category,
count(*) as total_products,
sum(case when outOfStock=true then 1 else 0 end) as out_of_stock_products,
round(sum(case when outOfStock=true then 1 else 0 end)*100.0/count(*),2) as stockout_percentage
from zepto_v2
group by Category
order by stockout_percentage desc;

# Q34. Analyse the price difference between MRP and selling price category wise.
select Category,
round(avg(mrp)/100,2) as avg_mrp,
round(avg(discountedSellingPrice)/100,2) as avg_selling_price,
round(avg(mrp-discountedSellingPrice)/100,2) as avg_price_difference
from zepto_v2
group by Category
order by avg_price_difference desc;

# Q35. Find expensive products that are currently out of stock.
select name,Category,
round(mrp/100,2) as mrp,
discountPercent,outOfStock
from zepto_v2
where outOfStock=true
and mrp>(select avg(mrp) from zepto_v2)
order by mrp desc;

# Q36. Classify categories based on their average discount strategy.
select Category,
round(avg(discountPercent),2) as avg_discount,
case
when avg(discountPercent)>=15 then 'Aggressive Discounting'
when avg(discountPercent)>=8 then 'Moderate Discounting'
else 'Low Discounting'
end as discount_strategy
from zepto_v2
group by Category
order by avg_discount desc;

# Q37. Analyse the relationship between discounts and product availability.
select
case
when discountPercent=0 then '0% Discount'
when discountPercent<=10 then '1-10% Discount'
when discountPercent<=20 then '11-20% Discount'
else 'Above 20% Discount'
end as discount_range,
count(*) as total_products,
sum(case when outOfStock=true then 1 else 0 end) as out_of_stock_products,
round(sum(case when outOfStock=true then 1 else 0 end)*100.0/count(*),2) as stockout_percentage
from zepto_v2
group by discount_range
order by stockout_percentage desc;

# Q38. Check missing values in the dataset.
select
sum(Category is null) as missing_category,
sum(name is null) as missing_name,
sum(mrp is null) as missing_mrp,
sum(discountPercent is null) as missing_discount,
sum(discountedSellingPrice is null) as missing_price
from zepto_v2;

# Q39. Find products having zero or invalid prices.
select *
from zepto_v2
where mrp<=0 or discountedSellingPrice<=0;

# Q40. Find products having zero weight or quantity.
select *
from zepto_v2
where weightInGms<=0 or quantity<=0;

# Q41. Remove extra spaces from product names.
select trim(name) as clean_product_name,Category
from zepto_v2;

# Q42. Identify duplicate records using ROW_NUMBER().
with a as(
select *,
row_number() over(
partition by Category,name,mrp,discountPercent,availableQuantity,discountedSellingPrice,weightInGms,outOfStock,quantity
order by name
) as row_num
from zepto_v2
)
select *
from a
where row_num>1;