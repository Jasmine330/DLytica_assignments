--TASK E. JOINS, GROUPING, OPERATORS (REINFORCEMENT)

/*1. **Average Order Value by City (Delivered Only)**
    - Output: city, avg_order_value, delivered_orders_count. Order by `avg_order_value` desc. Use `HAVING` to keep cities with at least 2 delivered orders.
*/
select c.city, 
		avg(oi.quantity*oi.unit_price) as avg_order_value,
		count(*) as delivered_orders_count
from orders o
join order_items oi on oi.order_id=o.order_id
join customers c on c.customer_id=o.customer_id
where status='delivered'
group by c.city
having count(*)>=2
order by avg_order_value desc;


/*2. **Category Mix per Customer**
    - For each customer, list categories purchased and the **count of distinct orders** per category. Order by customer and count desc.
*/
select c.customer_id, c.full_name,
	p.category,
	count(distinct oi.order_id) as total_orders
from orders o
join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id =p.product_id 
join customers c on c.customer_id =o.customer_id 
group by c.customer_id , c.full_name , p.category
order by customer_id, total_orders desc;


/*3. **Set Ops: Overlapping Customers**
    - Split customers into two sets: those who bought `Electronics` and those who bought `Fitness`. Show:
      - `UNION` of both sets,
      - `INTERSECT` (bought both),
      - `EXCEPT` (bought Electronics but not Fitness).
*/
create table customer_bought_electronics as(
	select distinct c.customer_id, c.full_name, c.city, p.category
	from customers c
	join orders o on c.customer_id=o.customer_id
	join order_items oi on o.order_id=oi.order_id
	join products p on oi.product_id=p.product_id
	where p.category='Electronics'
);
select * from customer_bought_electronics;
create table customer_bought_fitness as(
	select distinct c.customer_id, c.full_name, c.city, p.category
	from customers c
	join orders o on c.customer_id=o.customer_id
	join order_items oi on o.order_id=oi.order_id
	join products p on oi.product_id=p.product_id
	where p.category='Fitness'
);
select * from customer_bought_fitness;


--union
select * from customer_bought_electronics 
union 
select * from customer_bought_fitness
order by customer_id;

--intersect
select * from customer_bought_electronics 
intersect 
select * from customer_bought_fitness
order by customer_id;

select * from customer_bought_electronics 
except 
select * from customer_bought_fitness
order by customer_id;