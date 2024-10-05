-- calculate total revenue generated fro  pizza sale
use pizza;
SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pzza_id;

-- highest priced pizza 

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- identify common pizza size orderd
select quantity,count(order_details_id)
from orders_details group by quantity;


select pizzas.size,count(orders_details.order_details_id) as order_count
from pizzas join orders_details
on pizzas.pizza_id=orders_details.pzza_id
group by pizzas.size order by order_count desc;


-- 5 most ordered pizza types along with quantities 
SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS top5
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pzza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY top5 DESC
LIMIT 5;  



-- join necessary tables to find the total quantity of each category ordered
SELECT 
    pizza_types.category,
    SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pzza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;


-- determine the distributions of order hour by a day
select hour(order_time),count(order_id) from orders
group by hour(order_time);  



-- joint relevant tables to find the category wise distribution of pizzaas
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category; 
 
 
 -- grop the orders by date cal avg ordered by day
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
    
    -- dtermine the top 3 most order pizza based on revenue
    select pizza_types.name,
    sum(orders_details.quantity * pizzas.price)as revenue
    from pizza_types join pizzas
    on pizzas.pizza_type_id= pizza_types.pizza_type_id
    join orders_details
    on orders_details.pzza_id=pizzas.pizza_id
    group by pizza_types.name
    order by revenue desc limit 3;
    
    
    -- cal the % contribution of each pizza  to total revenue
    select pizza_types.category,
     (sum(orders_details.quantity * pizzas.price)/
     (select round(sum(orders_details.quantity*pizzas.price),
    from pizza_types join pizzas
    on pizzas.pizza_type_id= pizza_types.pizza_type_id
    join orders_details
    on orders_details.pzza_id=pizzas.pizza_id
    group by pizza_types.category
    order by revenue desc  ;   
    