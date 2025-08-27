select *
from pizza_sales


/* A. KPI'S */
/* 1. Total Revenue */
select sum(total_price) as Total_Revenue from pizza_sales;


/* 2. Average Order Value */ 
select (sum(total_price) / count(distinct order_id)) as avg_order_value 
from pizza_sales;


/* 3. Total Pizzas Sold */
select sum(quantity) as total_pizza_sold 
from pizza_sales;


/* 4. Total Orders */
select count(distinct order_id) as total_orders 
from pizza_sales;


/* 5. Average Pizzas Per Order */
select cast(cast(sum(quantity) as decimal(10,2)) / 
cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) 
as avg_pizzas_per_order
from pizza_sales;


/* B. Daily Trend for Total Orders */
select datename(dw, order_date) as order_day, count(distinct order_id) as total_orders 
from pizza_sales
group by datename(dw, order_date);


/* C. Monthly Trend for Orders */
select datename(month, order_date) as month_name, count(distinct order_id) as total_orders
from pizza_sales
group by datename(month, order_date);


/* D. % of Sales by Pizza Category */
select pizza_category, cast(sum(total_price) as decimal(10,2)) as total_revenue,
cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as decimal(10,2)) as pct
from pizza_sales
group by pizza_category;


/* E. % of Sales by Pizza Size */
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_revenue,
cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as decimal(10,2)) as pct
from pizza_sales
group by pizza_size
order by pizza_size


/* F. Total Pizzas Sold by Pizza Category */
select pizza_category, sum(quantity) as total_quantity_sold
from pizza_sales
where month(order_date) = 2
group by pizza_category
order by total_quantity_sold desc;


/* G. Top 5 Pizzas by Revenue */
select top 5 pizza_name, sum(total_price) as total_revenue
from pizza_sales
group by pizza_name
order by total_revenue desc;


/* H. Bottom 5 Pizzas by Revenue */
select top 5 pizza_name, sum(total_price) as total_revenue
from pizza_sales
group by pizza_name
order by total_revenue 


/* I. Top 5 Pizzas by Quantity */
select top 5 pizza_name, sum(quantity) as total_pizza_sold
from pizza_sales
group by pizza_name
order by total_pizza_sold desc;


/* J. Bottom 5 Pizzas by Quantity */
select top 5 pizza_name, sum(quantity) as total_pizza_sold
from pizza_sales
group by pizza_name
order by total_pizza_sold


/* K. Top 5 Pizzas by Total Orders */
select top 5 pizza_name, count(distinct order_id) as total_orders
from pizza_sales
group by pizza_name
order by total_orders desc;


/* L. Borrom 5 Pizzas by Total Orders */
select top 5 pizza_name, count(distinct order_id) as total_orders
from pizza_sales
group by pizza_name
order by total_orders







