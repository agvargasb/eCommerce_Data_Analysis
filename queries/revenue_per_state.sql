-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 

WITH filtered_orders AS (
	SELECT
	    order_id,
		customer_id
	FROM olist_orders
	WHERE order_status = 'delivered' 
		AND order_delivered_customer_date IS NOT NULL
)
SELECT customer_state, SUM(payment_value) AS Revenue
FROM filtered_orders
INNER JOIN olist_customers USING(customer_id)
INNER JOIN olist_order_payments USING(order_id)
GROUP BY customer_state
ORDER BY Revenue DESC
LIMIT 10;
