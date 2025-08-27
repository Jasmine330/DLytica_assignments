--TASK C: FUNCTIONS

/*1. **Scalar Function: `fn_customer_lifetime_value(customer_id)`**
    - Return total **paid** amount for the customer's delivered/shipped/placed (non-cancelled) orders.
*/
create function fn_customer_lifetime_value(p_customer_id int)
returns numeric
language plpgsql
as $$
declare
	revenue numeric = 0;
begin
	select sum(oi.quantity*oi.unit_price) into revenue
	from orders o
	join order_items oi on o.order_id = oi.order_id
	where o.customer_id=p_customer_id and o.status in ('delivered', 'shipped', 'placed');

	return revenue;
end;
$$;

select fn_customer_lifetime_value(customer_id ) from customers;



/*2. **Table Function: `fn_recent_orders(p_days INT)`**
    - Return `order_id, customer_id, order_date, status, order_total` for orders in the last `p_days` days.
*/
create or replace function fn_recent_orders(p_days int)
returns table( 
		order_id int,
		customer_id int,
		order_date timestamp,
		status varchar,
		order_total numeric)
language plpgsql
as
$$
begin
	return query
	select o.order_id, o.customer_id, o.order_date, o.status,
		sum(oi.quantity*oi.unit_price) as order_total
	from orders o
	join order_items oi on o.order_id=oi.order_id
	where current_date - p_days <= o.order_date
	group by o.order_id, o.customer_id, o.order_date, o.status
	order by o.order_date desc;
end;
$$;

select * from fn_recent_orders(7); 


/*3. **Utility Function: `fn_title_case_city(text)`**
    - Return city name with first letter of each word capitalized (hint: split/upper/lower or use `initcap()` in PostgreSQL).
*/
create or replace function fn_title_case_city(p_city text)
returns text
language plpgsql
as
$$
begin 
	return initcap(p_city);
end;
$$;

select fn_title_case_city(city) as city_name from customers group by city_name order by city_name;
