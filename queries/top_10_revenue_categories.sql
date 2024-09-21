-- TODO: This query will return a table with the top 10 revenue categories in 
-- English, the number of orders and their total revenue. The first column will 
-- be Category, that will contain the top 10 revenue categories; the second one 
-- will be Num_order, with the total amount of orders of each category; and the 
-- last one will be Revenue, with the total revenue of each catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.

WITH orders_delivered AS(
    SELECT order_id 
    FROM olist_orders
    WHERE order_status = 'delivered' 
    AND order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
),
table_order_product AS(
    SELECT order_id, product_id
    FROM olist_order_items
    WHERE order_id IN orders_delivered
),
table_order_payment AS(
    SELECT order_id, payment_value
    FROM olist_order_payments
),
table_product_payment AS (
    SELECT a.order_id, a.product_id, b.payment_value
    FROM table_order_product a
    INNER JOIN table_order_payment b USING(order_id)
),
table_category_payment AS (
    SELECT a.order_id, a.product_id, a.payment_value, b.product_category_name
    FROM table_product_payment a	
    INNER JOIN (SELECT * FROM olist_products bb WHERE bb.product_category_name IS NOT NULL) b USING(product_id)
),
table_category_payment_english AS (	
    SELECT a.order_id, a.product_id, a.payment_value, b.product_category_name_english AS Category
    FROM table_category_payment a
    INNER JOIN product_category_name_translation b USING(product_category_name)
)
select Category, COUNT(DISTINCT order_id) AS Num_order, SUM(payment_value) AS Revenue
from table_category_payment_english
GROUP by Category
ORDER BY Revenue DESC
LIMIT 10;
