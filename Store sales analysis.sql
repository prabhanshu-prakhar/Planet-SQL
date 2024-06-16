use masai;
select *, ntile(2) over(order by marks desc) as bucket_number from students;
select *  from sales;
select monthname(Month_) as month_name , sales, max(sales) over(order by Month_ rows between  2 preceding and 1 following  ) as max_sales
from sales;

select monthname(Month_) as month_name , sales, min(sales) over(order by Month_ rows between  2 preceding and 1 following  ) as max_sales
from sales;

--  get all the coloumns from orders tables along with th avg order amount for every customer sorted by order date among a 4 previous and 1 following ate and the number of orders for every customer sorted by oder data
select * from orders;
 ## creating stored procedure
 DELIMITER $$
 create procedure procedure_1(in CityName varchar(30))
 BEGIN 
 SELECT *
 FROM customers
 where city like CityName;
 END $$
 
 DELIMITER ;
 
 call procedure_1('New York');
 
 -- create new procedure
DELIMITER //

CREATE PROCEDURE procedure_2(IN order_amount FLOAT, IN weekday VARCHAR(30))
BEGIN 
    SELECT *, dayname(orderdate) AS weekday 
    FROM orders 
    WHERE Total_order_amount >= order_amount 
    AND dayname(orderdate) LIKE weekday;
END //

DELIMITER ;
call procedure_2('9000','Thursday');


## dropping the procedure
drop procedure procedure_1;

call procedure_1('New York');

call procedure_2('9000');

select * from  prodcts_owened;

##case when statements

select * from orders;
select CustomerID,
(case when year(OrderDate) = 2012 then ShipperID end) as '2012',
(case when year(OrderDate) = 2013 then ShipperID end) as '2013',
(case when year(OrderDate) = 2014 then ShipperID end) as '2014'
from orders
order by customerid;
select CustomerID,
max(case when year(OrderDate) = 2012 then ShipperID end) as '2012',
max(case when year(OrderDate) = 2013 then ShipperID end) as '2013',
max(case when year(OrderDate) = 2014 then ShipperID end) as '2014'
from orders
order by customerid;

##cte problem statement find all the products that have never been ordered and are from inactive category 

select * from category;
select * from products;
select * from orderdetails;


with inactivecategories as (
select categoryID
from category
where Active like '%No%' ),
unorderedproducts as (
select productID
from products
where productID not in(
select productID from orderdetails
)
)
select p.productID, p.product from products as p
join inactivecategories as ic
on p.category_ID = ic.CategoryID
join unorderedproducts  as up
on up.ProductID = p.productID;
select * from products;
select * from suppliers;
select * from orderdetails;
#list the average market price of product supplied by each supplier
with avgpr as (
select s.supplierID, p.productID, p.Market_Price
from suppliers as s
join orderdetails as od on s.supplierID = od.supplierID
join products as p on od.productID = p.productID
)
select a.supplierID, avg(a.Market_Price) as averagemarketprice from avgpr as a
group by a.supplierID
order by a.supplierID;

select avg(p.Market_Price)

--get the sum of quantity, shipped by each supplier in each quarter of year  tables order orderdetails, shippers

SELECT 
    YEAR(a.shipdate) AS year,
    QUARTER(a.shipdate) AS quarter,
    b.shipperID,
    SUM(c.quantity) AS total_quantity
FROM
    orders AS a
        JOIN
    shippers AS b ON a.shipperID = b.shipperID
        JOIN
    orderdetails AS c ON a.orderID = c.orderID
GROUP BY YEAR(a.shipdate), QUARTER(a.shipdate), b.shipperID
ORDER BY YEAR(a.shipdate), QUARTER(a.shipdate), b.shipperID;


with cte as(SELECT 
    YEAR(a.shipdate) AS year,
    QUARTER(a.shipdate) AS quarter,
    b.shipperID,
    SUM(c.quantity) AS total_quantity
FROM
    orders AS a
        JOIN
    shippers AS b ON a.shipperID = b.shipperID
        JOIN
    orderdetails AS c ON a.orderID = c.orderID
GROUP BY YEAR(a.shipdate), QUARTER(a.shipdate), b.shipperID
ORDER BY YEAR(a.shipdate), QUARTER(a.shipdate), b.shipperID
)
select year, quarter
(case when shipperID = 1 then total_quantity end ) as shipper_1,
(case when shipperID = 2 then total_quantity end ) as shipper2,
(case when shipperID = 3 then total_quantity end ) as shipper_3,
(case when shipperID = 4 then total_quantity end ) as shipper_4
from cte
group by year, quarter;

select * from customers;
SELECT 
    customerID,
    CONCAT(FirstName,' ', LastName) AS FullName,
    PostalCode
FROM
    customers
ORDER BY CustomerID DESC;


SELECT 
    c.customerID, 
    RIGHT(email, LENGTH(email) - POSITION('@' IN email)) AS domain,
    CONCAT(
        FirstName, ' ', 
        COALESCE(LastName, 'WEB'), 
        ' was born on ', DAY(Date_of_Birth), 'th ', 
        MONTHNAME(Date_of_Birth), ' ', YEAR(Date_of_Birth), 
        ' has ordered ', COUNT(DISTINCT a.OrderID), ' orders yet'
    ) AS description_
FROM 
    customers AS c
JOIN 
    orders AS a ON c.CustomerID = a.CustomerID
GROUP BY 
    c.customerID, 
    RIGHT(email, LENGTH(email) - POSITION('@' IN email)), 
    FirstName, 
    LastName, 
    Date_of_Birth
ORDER BY 
    MAX(DateEntered) DESC, 
    c.CustomerID ASC;


SELECT 
    DAYNAME(DeliveryDate) AS dayn, 
    COUNT(*) AS number_of_orders
FROM 
    orders
WHERE 
    DAYNAME(DeliveryDate) IN ('Saturday', 'Sunday')
GROUP BY 
    DAYNAME(DeliveryDate)
ORDER BY 
    number_of_orders DESC;

select * from products;

SELECT 
    productID,
    Product,
    COALESCE(Sub_category, 'No_sub_category') AS subcate
FROM
    products
WHERE
    Sub_Category IS NULL
ORDER BY ProductID ASC;


SELECT 
    OrderID,
    CustomerID,
    AVG(Total_order_amount) AS avg_total_order_amount
FROM
    orders
WHERE
    DATEDIFF(DeliveryDate, OrderDate) = 3
GROUP BY OrderID , CustomerID
ORDER BY orderID ASC;

select * from orders;
