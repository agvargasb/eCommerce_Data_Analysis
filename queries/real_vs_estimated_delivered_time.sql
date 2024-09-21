-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

WITH filtered_orders AS (
	SELECT
	    order_id,
		strftime('%Y', order_purchase_timestamp) AS year_no,
		strftime('%m', order_purchase_timestamp) AS month_no,
		--JULIANDAY(STRFTIME('%Y-%m-%d', order_delivered_customer_date)) - JULIANDAY(STRFTIME('%Y-%m-%d', order_purchase_timestamp)) AS Real_Difference,
		--CAST(JULIANDAY(STRFTIME('%Y-%m-%d', order_estimated_delivery_date)) - JULIANDAY(STRFTIME('%Y-%m-%d', order_purchase_timestamp)) AS INT) AS Estimated_Difference
		JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS Real_Difference,
		JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS Estimated_Difference
	FROM olist_orders
	WHERE order_status = 'delivered' 
		AND order_delivered_customer_date IS NOT NULL 
	    AND order_purchase_timestamp IS NOT NULL
)
--select * from filtered_orders;
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
    AVG(CASE WHEN year_no = '2016' THEN (Real_Difference) ELSE NULL END) AS 'Year2016_real_time',
    AVG(CASE WHEN year_no = '2017' THEN (Real_Difference) ELSE NULL END) AS 'Year2017_real_time',
    AVG(CASE WHEN year_no = '2018' THEN (Real_Difference) ELSE NULL END) AS 'Year2018_real_time',
    AVG(CASE WHEN year_no = '2016' THEN (Estimated_Difference) ELSE NULL END) AS 'Year2016_estimated_time',
    AVG(CASE WHEN year_no = '2017' THEN (Estimated_Difference) ELSE NULL END) AS 'Year2017_estimated_time',
    AVG(CASE WHEN year_no = '2018' THEN (Estimated_Difference) ELSE NULL END) AS 'Year2018_estimated_time'
FROM filtered_orders
GROUP BY month_no
ORDER BY month_no;
