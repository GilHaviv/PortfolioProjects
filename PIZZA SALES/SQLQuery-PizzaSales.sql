use PizzaSales


------------------------------------------------------------------------
--Standardize Date Format in orders table

select Date,CONVERT(date,Date)
from orders

Update orders
SET Date = CONVERT(date,Date)

ALTER TABLE orders
ADD DateConverted Date;

Update orders
SET DateConverted = CONVERT(date,Date)

------------------------------------------------------------------------
--Create Query

select 
	orders.order_id,
	orders.DateConverted,
	pizza_types.name,
	pizzas.size,
	pizza_types.category,
	order_details.quantity,
	pizzas.price,
	sum(order_details.quantity*pizzas.price) as 'revenue'
from orders
join order_details
on orders.order_id = order_details.order_id
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by
	orders.order_id,
	orders.DateConverted,
	pizza_types.name,
	pizzas.size,
	pizza_types.category,
	order_details.quantity,
	pizzas.price