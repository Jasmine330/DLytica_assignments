set search_path to training_ecom;
--TASK A. WINDOW FUNCTIONS

--1. monthly customer rank by spend
select 
	month,
	customer_id,
	total_monthly_spend,
	rank() over (partition by month order by total_monthly_spend desc) as rank_in_month
from(
	select to_char(o.order_date, 'YYYY-MM') as month,
		o.customer_id,
		sum(oi.quantity*oi.unit_price) as total_monthly_spend
	from orders o
	join order_items oi on o.order_id = oi.order_id
	group by month, o.customer_id
	) as monthly_spend
order by month, rank_in_month;


--2. Share of Basket per Item
select 
    order_id,
    product_id,
    quantity,
    unit_price,
    (quantity * unit_price) as item_revenue,
    sum(quantity * unit_price) over (partition by order_id) as order_total,
    round((quantity * unit_price) / sum(quantity * unit_price) over (partition by order_id) * 100, 2) as revenue_share
from order_items
order by order_id, product_id;


--3. time between orders(per Customer)
select 
	customer_id, 
	order_id, 
	order_date,
	status,
	lag(order_date) over (partition by customer_id order by order_id) as previous_order,
    age(order_date, lag(order_date) over (partition by customer_id order by order_date)) as time_between_orders
from orders;


--4.Product Revenue Quartiles
with product_revenue as(
	select 
		p.product_id,
		p.product_name,
		p.unit_price,
		sum(oi.unit_price * oi.quantity) as total_revenue
	from products p
	join order_items oi on p.product_id=oi.product_id
	group by p.product_id, p.product_name, p.unit_price
)
select 
	product_id,
	product_name,
	unit_price,
	total_revenue,
	ntile(4) over (order by total_revenue) as revenue_quartile
from product_revenue
order by total_revenue;


--first and last purchase category per customer
with customer_purchase as(
	select 
		o.customer_id,
		first_value(p.category) over (partition by o.customer_id order by o.order_date) as first_purchase,
		last_value(p.category) over (partition by o.customer_id order by o.order_date rows between unbounded preceding and unbounded following) as recent_purchase
	from orders o
	join order_items oi on o.order_id=oi.order_id 
	join products p on oi.product_id=p.product_id
)
select distinct
	cp.customer_id,
	c.full_name,
	cp.first_purchase,
	cp.recent_purchase
from customer_purchase cp
join customers c on cp.customer_id=c.customer_id
order by customer_id;