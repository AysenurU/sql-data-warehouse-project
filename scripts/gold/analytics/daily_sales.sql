CREATE OR ALTER VIEW gold.daily_sales
AS
SELECT
    d.full_date                      AS sales_date,
    COUNT(DISTINCT f.order_number)   AS total_orders,
    SUM(f.quantity)                  AS total_quantity,
    SUM(f.sales_amount)              AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_date d
    ON d.date_key = f.order_date_key
GROUP BY
    d.full_date;
GO
