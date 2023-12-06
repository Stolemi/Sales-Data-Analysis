/**************** EXPLORATIVE DATA ANALYSIS ****************/

/* 1. Total number of orders, total sales, total orders by month */ 
SELECT 
    COUNT(DISTINCT(orderID)) as totOrders,
    SUM(totSales) as totSales
FROM
    SalesTab_final; 

SELECT 
    s.monthofpurch,
    s.totmonthlyorders,
    ROUND(s.totmonthlyorders / t.totorders*100, 2) as percYearPurch
FROM
    (SELECT 
        monthofpurch, COUNT(DISTINCT(OrderID)) AS TotMonthlyOrders
    FROM
        SalesTab_final
    GROUP BY monthofpurch) AS s
        JOIN
    (SELECT 
        COUNT(distinct(orderID)) AS totOrders
    FROM
        SalesTab_final) AS t
	ORDER BY s.monthofpurch;
    
/* 2. Month with highest revenue */ 
WITH CTE_totMonthSales as (SELECT 
    monthofpurch, SUM(totsales) AS TotMonthlySales
FROM
    SalesTab_final
GROUP BY monthofpurch
ORDER BY monthofpurch) 
SELECT 
    monthofpurch, totmonthlysales
FROM
    CTE_totMonthSales
WHERE
    totmonthlysales = (SELECT 
            MAX(totmonthlysales)
        FROM
            CTE_totMonthSales); 
            
/* 3. Day of the month with highest sales: Do we observe an increase in orders/sales after pay day (around the 25th of the month) ? */ 
WITH CTE_totDaySales as (SELECT 
    EXTRACT(DAY FROM orderdate) as dayofpurch, count(distinct(orderID)) as totOrders, SUM(totsales) AS TotDailySales
FROM
    SalesTab_final
GROUP BY EXTRACT(DAY FROM orderdate))
SELECT 
    dayofpurch, totorders, rank() over (order by totorders desc) as rank_orders, totdailysales /*, rank() over (order by totdailysales desc) as rank_sales*/
FROM
    CTE_totDaySales
ORDER BY totdailysales DESC;

/* 4. At what hour are the most purchases made? What hour is the best for ads? */ 
SELECT 
    HourofPurch, sum(quantityordered) AS totProducts
FROM
    SalesTab_final
GROUP BY HourofPurch
ORDER BY totProducts DESC; 

/* 5. Cities with most products sold and cities with highest revenue */ 
SELECT 
    city,
    SUM(quantityordered) AS TotProducts,
    SUM(totsales) AS totSales
FROM
    SalesTab_final
GROUP BY city
ORDER BY totProducts DESC
LIMIT 3; 

/* 5.1 Average monthly number of orders and average monthly sales per state */ 
WITH CTE_ordersperstate AS (
	SELECT 
    state,
    monthofpurch,
    COUNT(distinct(orderid)) AS totmonthorders,
    ROUND(AVG(totsales),2) as avgmonthsales
FROM
    SalesTab_final
GROUP BY state , monthofpurch
ORDER BY state , monthofpurch
)
SELECT
    state,
    FLOOR(AVG(totmonthorders)) AS avgmonthlyorders,
    ROUND(AVG(avgmonthsales),2) AS avgmonthlysales
FROM
    CTE_ordersperstate
GROUP BY state
ORDER BY avgmonthlyorders DESC;

/* 6. What products sell the most ? What products sell together (product bundle)? */ 
SELECT 
    product, SUM(quantityordered) AS quantitySold
FROM
    SalesTab_v2
GROUP BY product
ORDER BY quantitySold DESC; 

/* Create dataset with all product pairs ordered */
SELECT 
    COUNT(*) AS maxProductsordered
FROM
    SalesTab_final
GROUP BY orderID
ORDER BY maxProductsordered DESC
LIMIT 1; 

DROP TABLE IF EXISTS products; 
CREATE  TABLE products AS 
SELECT orderid, product, ROW_NUMBER() OVER (PARTITION BY orderid) AS prodNumber
FROM salestab_final;

DROP TABLE IF EXISTS T1; 
CREATE TEMPORARY TABLE T1 as 
with CTE as (
select orderid, product, prodnumber, max(prodnumber) over (partition by orderid) as max_num
from products
), CTE2 as(
select t.* 
from (select distinct(orderid) from CTE where max_num = 5) as s
left join CTE as t 
on s.orderid = t.orderid), 
CTE3 as (select s.orderid, s.product, t.product as product2
from (select * from CTE2 order by orderid, product)  as s 
left join CTE2 as t 
on s.orderid = t.orderid and (s.prodnumber + 1 = t.prodnumber or s.prodnumber + 2 = t.prodnumber or s.prodnumber + 3 = t.prodnumber or s.prodnumber + 4= t.prodnumber))
select * from CTE3
where product2 is not null; 

DROP TABLE IF EXISTS T2; 
CREATE TEMPORARY TABLE T2 as 
with CTE as (
select orderid, product, prodnumber, max(prodnumber) over (partition by orderid) as max_num
from products 
), CTE2 as(
select t.* 
from (select distinct(orderid) from CTE where max_num = 4) as s
left join CTE as t 
on s.orderid = t.orderid), 
CTE3 as (select s.orderid, s.product, t.product as product2
from (select * from CTE2 order by orderid, product) as s 
left join CTE2 as t 
on s.orderid = t.orderid and (s.prodnumber + 1 = t.prodnumber or s.prodnumber + 2 = t.prodnumber or s.prodnumber + 3 = t.prodnumber))
select * from CTE3
where product2 is not null; 

DROP TABLE IF EXISTS T3; 
CREATE TEMPORARY TABLE T3 as 
with CTE as (
select orderid, product, prodnumber, max(prodnumber) over (partition by orderid) as max_num
from products
), CTE2 as(
select t.* 
from (select distinct(orderid) from CTE where max_num = 3) as s
left join CTE as t 
on s.orderid = t.orderid), 
CTE3 as (select s.orderid, s.product, t.product as product2
from (select * from CTE2 order by orderid, product)  as s 
left join CTE2 as t 
on s.orderid = t.orderid and (s.prodnumber + 1 = t.prodnumber or s.prodnumber + 2 = t.prodnumber))
select * from CTE3
where product2 is not null; 

DROP TABLE IF EXISTS T4; 
CREATE TEMPORARY TABLE T4 as 
WITH CTE AS (
SELECT orderid, product, prodnumber, MAX(prodnumber) OVER (PARTITION BY orderid) AS max_num
FROM products
), CTE2 AS(
SELECT t.* 
FROM (SELECT DISTINCT(orderid) FROM CTE WHERE max_num = 2) AS s
LEFT JOIN CTE AS t 
ON s.orderid = t.orderid), 
CTE3 AS (SELECT s.orderid, s.product, t.product AS product2
FROM (SELECT * FROM CTE2 ORDER BY orderid, product)  AS s 
LEFT JOIN CTE2 AS t 
ON s.orderid = t.orderid AND s.prodnumber + 1 = t.prodnumber)
SELECT * FROM CTE3
WHERE product2 IS NOT NULL; 
 
/* Append the datasets */ 
DROP TABLE IF EXISTS product_pairs;
CREATE TABLE product_pairs AS 
WITH CTE_pairs AS(
SELECT 
    *
FROM
    t1 
UNION ALL SELECT 
    *
FROM
    t2 
UNION ALL SELECT 
    *
FROM
    t3 
UNION ALL SELECT 
    *
FROM
    t4
ORDER BY orderid)
SELECT 
    *, CONCAT(product, ', ', product2) AS product_bundle
FROM
    CTE_pairs;


SELECT 
    product_bundle, COUNT(*) AS totPairOrders
FROM
    product_pairs
GROUP BY product_bundle
ORDER BY COUNT(*) DESC;















