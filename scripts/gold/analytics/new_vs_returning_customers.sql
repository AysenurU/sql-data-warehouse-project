CREATE OR ALTER VIEW gold.new_vs_returning_customers
AS
WITH customer_first_order AS (
SELECT 
	customer_key,
	MIN(order_date) AS first_order_date
FROM gold.fact_sales
GROUP BY customer_key
)
SELECT 
	d.full_date AS sales_date,
	
	COUNT(DISTINCT CASE
						WHEN f.order_date = cfo.first_order_date
						THEN f.customer_key
					END
	) AS new_customers,

	COUNT(DISTINCT CASE
						WHEN f.order_date > cfo.first_order_date
						THEN f.customer_key
					END
	) AS returning_customers

FROM gold.fact_sales f
JOIN customer_first_order cfo
	ON cfo.customer_key = f.customer_key
JOIN gold.dim_date d
	ON f.order_date_key = d.date_key
GROUP BY d.full_date;
GO
