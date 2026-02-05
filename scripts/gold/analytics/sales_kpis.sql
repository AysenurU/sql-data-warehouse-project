/*
View Purpose:
-------------
Provides high-level sales KPIs for executive dashboards.

Business Questions Answered:
- What is the total revenue and order volume?
- What is the average order value (AOV)?
- How much revenue is generated per item sold?

Grain:
------
Single-row summary (no dimensional breakdown).
*/

CREATE OR ALTER VIEW gold.sales_kpis
AS
SELECT 
	COUNT(DISTINCT f.order_number)  AS total_orders,
	SUM(f.quantity)					AS total_quantity,
	SUM(f.sales_amount)				AS total_revenue,
	-- Average Order Value (AOV)
	ROUND (
		SUM(f.sales_amount) * 1.0 / NULLIF( COUNT(DISTINCT f.order_number), 0),
	2
	) AS avg_order_value,
	-- Revenue per item
	ROUND (
		SUM(f.sales_amount) * 1.0 / NULLIF( SUM(f.quantity), 0),
	2
	) AS revenue_per_item,
	-- Active Customers
	COUNT(DISTINCT f.customer_key) AS active_customers
FROM gold.fact_sales f;
GO
