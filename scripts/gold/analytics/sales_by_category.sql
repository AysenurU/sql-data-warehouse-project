CREATE OR ALTER VIEW gold.sales_by_category
AS
SELECT 
	p.category,

	COUNT(DISTINCT f.order_number) AS total_orders,
	SUM(f.quantity)					AS total_quantity,
	SUM(f.sales_amount)				AS total_revenue,

	ROUND(
		SUM(f.sales_amount) * 1.0 / NULLIF(COUNT(DISTINCT f.order_number), 0),
		2
	) AS avg_order_value
FROM gold.fact_sales f
JOIN gold.dim_products p
	ON f.product_key = p.product_key
GROUP BY p.category;
GO
