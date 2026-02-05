/*
View Purpose:
-------------
Analyzes sales performance at the product category level.

Business Questions Answered:
- Which product categories generate the most revenue?
- How does average order value differ by category?
- Which categories drive overall sales volume?

Grain:
------
One row per product category.
*/

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
