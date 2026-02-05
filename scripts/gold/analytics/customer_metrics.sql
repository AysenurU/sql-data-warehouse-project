/*
View Purpose:
-------------
Provides customer-level metrics to support RFM-style analysis.

Business Questions Answered:
- How valuable is each customer over time?
- When was the customer's first and last purchase?
- How long has it been since the last order?

Grain:
------
One row per customer.
*/

CREATE OR ALTER VIEW gold.customer_metrics
AS
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	c.country,

	COUNT(DISTINCT f.order_number) AS total_orders,
	SUM(f.sales_amount)				AS lifetime_revenue,
	-- Average Order Value (AOV)
	ROUND(
		SUM(f.sales_amount) * 1.0 / NULLIF( COUNT(DISTINCT f.order_number), 0),
		2
	) AS avg_order_value,

	MIN(f.order_date)				AS first_order_date,
	MAX(f.order_date)				AS last_order_date,

	DATEDIFF(
		DAY,
		MAX(f.order_date),
		GETDATE()
	) AS days_since_last_order
FROM gold.fact_sales f
JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.customer_key,
		c.first_name,
		c.last_name,
		c.country
GO
