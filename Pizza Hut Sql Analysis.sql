use pizzahut

/* Total Orders Count
 Find the total number of orders placed. */

select count(order_id) as 'Order_Count'
from orders

/* 	Revenue Calculation 
Calculate the total revenue from pizza sales. 
 */
 
select round(sum(quantity*price)) as 'Total_Revenue'
from order_details o join pizzas p
on o.pizza_id = p.pizza_id


/* Most Expensive Pizza 
Identify the highest-priced pizza.
  */
  
select pizza_id, pizza_type_id, price
from pizzas
order by price desc
limit 1


/* Most Ordered Pizza Size 
Determine the most frequently ordered pizza size.
 */

select size, count(size) as 'Most_Ordered'
from order_details o join pizzas p
on o.pizza_id = p.pizza_id
group by size
order by count(size) desc
limit 1


/*  Top 5 Popular Pizzas 
List the top 5 pizzas by order quantity. 
 */
 
 
select pt.pizza_type_id, sum(quantity) as 'Top_5_Pizzas_Ordered'
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id join order_details od
on p.pizza_id = od.pizza_id
group by pt.pizza_type_id
order by 2 desc
limit 5



/*  Pizza Quantity by Category 
Calculate the total quantity ordered for each pizza category. 
*/

select category, sum(quantity) as 'Total_Quantity_Ordered_by_Category'
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id join order_details od
on p.pizza_id = od.pizza_id
group by category
order by 2


/* Order Trends by Hour
 Analyze the distribution of orders by hour of day.
*/

with cte as  
(  
select order_id, hour(order_time) as 'Hour_Ordered'  
from orders  
)  
select Hour_Ordered, count(order_id) as 'No.Of.Orders'  
from cte  
group by Hour_Ordered  
order by Hour_Ordered  


/*Pizza Distribution by Category.
Determine the order distribution of pizzas by category.
 */
 
select category, count(order_id) as 'No.of_Orders_by_Category'  
from pizza_types pt  
join pizzas p on pt.pizza_type_id = p.pizza_type_id  
join order_details od on p.pizza_id = od.pizza_id  
group by category  


/* Average Daily Pizza Orders
Calculate the average number of pizzas ordered each day. 
 */
 
select round(avg(quantity)) as 'Avg_Order_Per_Day'  
from orders o  
join order_details od on o.order_id = od.order_id  


/* Top Pizza Types by Revenue.
Identify the top 3 pizzas based on revenue.
 */
 
 with cte as (
    select 
        o.pizza_id as e,
        pt.name,
        quantity * price as Total
    from order_details o
    join pizzas p on o.pizza_id = p.pizza_id
    join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
)
select 
    e,
    name,
    round(sum(Total), 0) as Revenue
from cte
group by e, name
order by Revenue desc
limit 3


/*  Revenue Contribution by Pizza Type .
Calculate each pizza type’s percentage contribution  to total revenue.
 */
 
 with cte as (
    select 
        p.pizza_type_id,
        od.quantity * p.price as Revenue,
        sum(od.quantity * p.price) over() as Total_Revenue
    from order_details od
    join pizzas p on od.pizza_id = p.pizza_id
)
select
    pizza_type_id,
    round(sum(Revenue)) as Each_Type_Revenue,
    round(max(Total_Revenue)) as Total_Revenue,
    round((sum(Revenue) / max(Total_Revenue)) * 100, 2) as Each_Type_Percent_Contribution
from cte
group by pizza_type_id
order by Each_Type_Revenue desc;


/* Cumulative Revenue Over Time
Track cumulative revenue growth over time.
 */
 
 select
    order_date,
    round(sum(quantity * price), 2) as Daily_Revenue,
    sum(sum(quantity * price)) over (order by order_date) as Cumulative_Revenue
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join orders o on od.order_id = o.order_id
group by order_date
order by order_date;


/* Top 3 Pizza Types by Revenue in Each Category
 Determine the top 3 pizzas by revenue within each category.
 */
 
 
select *  
from  
(with cte as  
(  
select  
  p.pizza_id,  
  pt.name,  
  category,  
  sum(quantity * price) as Pizza_Revenue,  
  dense_rank() over(partition by category order by sum(quantity * price) desc) as rn 
from pizzas p join order_details o 
on p.pizza_id = o.pizza_id join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by p.pizza_id, category, pt.name
order by Pizza_Revenue desc )
select * 
from cte 
where rn <= 3 
) as utututu