use burger;

select count(distinct customer_id) as uniqueorder from customer_orders;

select runner_id, count(distinct order_id) as successful from runner_orders 
where cancellation is  null
group by runner_id
order by successful desc;


select p.burger_name, count(c.burger_id) as deliveredburger from   customer_orders as c
join runner_orders as r on c.order_id = r.order_id
join burger_names as p on c.burger_id= p.burger_id
where r.distance!=0
group by burger_name
order by deliveredburger;

select c.customer_id, b.burger_name, count(b.burger_id) as quantity from customer_orders   as c
join burger_names as b on c.burger_id = b.burger_id
group by c.customer_id, b.burger_name
order by  c.customer_id;



WITH burger_count_cte AS (
    SELECT 
        c.order_id, 
        COUNT(c.burger_id) AS burger_count
    FROM customer_orders AS c
    JOIN runner_orders AS r ON c.order_id = r.order_id
    WHERE r.distance != 0
    GROUP BY c.order_id
)
SELECT MAX(burger_count) AS max_burger
FROM burger_count_cte;


select c.customer_id , sum(
case when c.exclusions<>' ' or c.extras<>' ' then 1
else 0 end
) as atleaset_onr_change,
sum(
case when c.exclusions = ' ' or c.extras = ' ' then 1
else 0 end ) as no_change from customer_orders as c
join runner_orders as r on c.order_id = r.order_id 
where r.distance != 0
group by c.customer_id
order by c.customer_id;


select extract(hour from order_time)  as hour_ofday, count(order_id) as num_of_bur from customer_orders  
group by extract(hour from order_time) 
order by hour_ofday,num_of_bur;

select extract(week from registration_date) as week_of_day,
count(runner_id) as no_of_runner from burger_runner
group by extract(week from registration_date);


select  c.customer_id, avg(r.distance) as average_distance from customer_orders  as c join runner_orders as r on c.order_id = r.order_id
where r.distance != 0 
group by c.customer_id;