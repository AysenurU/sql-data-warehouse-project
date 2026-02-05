CREATE OR ALTER VIEW gold.top_products
AS
SELECT 
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,

	COUNT(DISTINCT f.order_number)  AS total_orders,
	SUM(f.quantity)					AS total_quantity,
	SUM(f.sales_amount)				AS total_revenue,

	-- Revenue rank (overal)
	RANK() OVER (
		ORDER BY SUM(f.sales_amount) DESC
	) AS revenue_rank

FROM gold.fact_sales f
JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.product_key,
		p.product_name,
		p.category,
		p.subcategory;
GO
