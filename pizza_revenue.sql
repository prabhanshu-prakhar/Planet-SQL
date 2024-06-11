create database pizzahut;
use pizzahut;
create table orders (
orderid int not null,
orderdate date not null,
ordertime time  not null,
primary key(orderid)
);
select * from orderdetails;
create table orderdetails (
order_details_id int not null,
order_id int not null,
pizza_id text  not null,
quantity int not null,
primary key(order_details_id)
); 
select * FROM orders;
select * from orderdetails;
select * from pizzas;
select * from pizza_types;
##retreive total number of oredr placed 
select count(orderid) from orders;
##calculate total revenue generated from pizza sales
SELECT 
    ROUND(SUM(orderdetails.quantity * pizzas.price),
            2) AS total_revenue
FROM
    orderdetails
        JOIN
    pizzas ON orderdetails.pizza_id = pizzas.pizza_id;
    
    
##highest amount pizza
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

##identify most common pizza size ordered;
SELECT 
    pizzas.size, COUNT(orderdetails.order_details_id)
FROM
    pizzas
        JOIN
    orderdetails ON pizzas.pizza_id = orderdetails.pizza_id
GROUP BY pizzas.size;

##identify top 5 most ordered pizzas alonfg withn their quantity
SELECT 
    pizza_types.name, SUM(orderdetails.quantity)
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON orderdetails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name , orderdetails.quantity
ORDER BY SUM(orderdetails.quantity) DESC
LIMIT 5;


##join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category, SUM(orderdetails.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON pizzas.pizza_id = orderdetails.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

##determine distributions of orders by hour of the day
SELECT 
    HOUR(ordertime), COUNT(orderid)
FROM
    orders
GROUP BY HOUR(ordertime);

##join relevant tables to find category wise distribution of pizzas
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

##group the orders by date and calculate the average number of pizzas_ordered per day
SELECT round(AVG(quantity)) AS average_quantity_per_day
FROM (
    SELECT 
        orders.orderdate, 
        SUM(orderdetails.quantity) AS total_quantity
    FROM
        orders 
    JOIN 
        orderdetails ON orders.orderid = orderdetails.order_id
    GROUP BY 
        orders.orderdate
) AS orderquantity;

## determine the top 3 most ordered pizza types based  on their revenue

SELECT 
    pizza_types.name, 
    sum(orderdetails.quantity * pizzas.price) AS revenue
FROM 
    pizza_types 
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    orderdetails ON orderdetails.pizza_id = pizzas.pizza_id
    group by pizza_types.name
    order by revenue desc
    limit 3;
    
    
##calculate percentage contribution  of each pizza type to total revenue
SELECT 
    pizza_types.category,
    ROUND(SUM(orderdetails.quantity * price) / (SELECT 
                    ROUND(SUM(orderdetails.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    orderdetails
                        JOIN
                    pizzas ON pizzas.pizza_id = orderdetails.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON orderdetails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

##analyze the cumilative revenue overtime
SELECT 
    sales.orderdate, 
    SUM(sales.revenue) OVER (ORDER BY sales.orderdate) AS cum_rev
FROM (
    SELECT 
        orders.orderdate,
        SUM(orderdetails.quantity * pizzas.price) AS revenue
    FROM
        orderdetails
        JOIN pizzas ON orderdetails.pizza_id = pizzas.pizza_id
        JOIN orders ON orderdetails.order_id = orders.orderid
    GROUP BY orders.orderdate
) AS sales
ORDER BY sales.orderdate;


##determine top 3 most ordered pizza type based on revenue for each pizza category
select name , revenue, rn from (select category, name,  revenue , rank() over(partition by category order by revenue desc ) as rn from (SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM((orderdetails.quantity) * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orderdetails ON orderdetails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name
ORDER BY revenue desc)  as a ) as b
where rn<=3;
