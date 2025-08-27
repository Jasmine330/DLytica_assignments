set search_path to training_ecom;
--VIEWS & SUBQUERIES

/***Create View: `vw_recent_orders_30d`**
   - View of orders placed in the **last 30 days** from `CURRENT_DATE`, excluding `cancelled`.
   - Columns: order_id, customer_id, order_date, status, order_total (sum of items).
*/
create or replace view vw_recent_orders_30d as
	select
		o.order_id,
		o.customer_id,
		o.order_date,
		o.status,
		sum(oi.quantity) as order_total
	from orders o
	join order_items oi on o.order_id=oi.order_id
	where ((current_date - o.order_date::date) <= 30) and (lower(o.status) != 'cancelled')
	group by o.order_id, o.customer_id, o.order_date,o.status;

select order_id,
	customer_id, 
	order_date,
	status,
	order_total
from vw_recent_orders_30d
order by order_id ;

--above query returned blank table so checking, worked
SELECT MIN(o.order_date), MAX(o.order_date) FROM orders o;
select order_id, order_date, current_date - order_date as interval
from orders
order by order_id;
insert into orders (customer_id, order_date, status) values
(1, '2025-08-05 10:15', 'delivered');
select * from orders;
insert into order_items(order_id,product_id, quantity, unit_price) values 
	(14,1,1,1999.00);

/***Products Never Ordered**
   - Using a subquery, list products that **never** appear in `order_items`.
*/
select product_id, product_name,category
from products
where product_id not in (select product_id from order_items);

select product_id from products;
select product_id from order_items group by product_id order by product_id;


/**Top Category by City**
   - For each `city`, find the **single category** with the highest total revenue. Use an inner subquery or a view plus a filter on rank.
*/
select city, category, product_revenue
from (
    select 
        c.city,
        p.category,
        sum(oi.quantity * oi.unit_price) as product_revenue,
        rank() over (
            partition by c.city 
            order by sum(oi.quantity * oi.unit_price) desc
        ) as rank_by_revenue
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    join customers c on o.customer_id = c.customer_id
    group by c.city, p.category
) ranked
where rank_by_revenue = 1;

/**Customers Without Delivered Orders**
   - Using `NOT EXISTS`, list customers who have **no orders** with status `delivered`.
*/
select customer_id, full_name, city, signup_date, email
from customers
where not exists (select order_id, customer_id, order_date, status 
				  from orders
				  where orders.customer_id = customers.customer_id and status='delivered')