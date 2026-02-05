CREATE OR ALTER VIEW gold.customer_sales
AS
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	c.country,
	COUNT(DISTINCT f.order_number)	AS total_orders,
	SUM(f.quantity)					AS total_quantity,
	SUM(f.sales_amount)				AS total_revenue,
	-- Average Order Value (AOV)
	ROUND(
		SUM(f.sales_amount) * 1.0 / NULLIF( COUNT(DISTINCT f.order_number), 0),
		2
	) AS avg_order_value,
	-- Last Purchase Date (Recency base)
	MAX(d.full_date) AS last_order_date
FROM gold.fact_sales f
JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
JOIN gold.dim_date d
	ON d.date_key = f.order_date_key
GROUP BY c.customer_key,
		c.first_name,
		c.last_name,
		c.country
GO
