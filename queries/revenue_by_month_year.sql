-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

WITH filtered_orders AS (
	SELECT
	    order_id,
		strftime('%Y', order_delivered_customer_date) AS year_no,
		strftime('%m', order_delivered_customer_date) AS month_no
	FROM olist_orders
	WHERE order_status = 'delivered' 
		AND order_delivered_customer_date IS NOT NULL 
	    AND order_purchase_timestamp IS NOT NULL
),
orders_with_payment AS (
	SELECT order_id, year_no, month_no, payment_value
	FROM filtered_orders INNER JOIN olist_order_payments USING(order_id)
	GROUP BY order_id
)
SELECT
    month_no,
    CASE
        WHEN month_no = "01" THEN "Jan"
        WHEN month_no = "02" THEN "Feb"
        WHEN month_no = "03" THEN "Mar"
        WHEN month_no = "04" THEN "Apr"
        WHEN month_no = "05" THEN "May"
        WHEN month_no = "06" THEN "Jun"
        WHEN month_no = "07" THEN "Jul"
        WHEN month_no = "08" THEN "Aug"
        WHEN month_no = "09" THEN "Sep"
        WHEN month_no = "10" THEN "Oct"
        WHEN month_no = "11" THEN "Nov"
        WHEN month_no = "12" THEN "Dec"
    END AS "month",
    SUM(CASE WHEN year_no = '2016' THEN (payment_value) ELSE 0.0 END) AS 'Year2016',
    SUM(CASE WHEN year_no = '2017' THEN (payment_value) ELSE 0.0 END) AS 'Year2017',
    SUM(CASE WHEN year_no = '2018' THEN (payment_value) ELSE 0.0 END) AS 'Year2018'
FROM orders_with_payment
GROUP BY month_no
ORDER BY month_no;
