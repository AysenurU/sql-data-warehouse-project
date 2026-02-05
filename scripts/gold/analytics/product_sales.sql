CREATE OR ALTER VIEW gold.product_sales
AS
SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,

    COUNT(DISTINCT f.order_number)   AS total_orders,
    SUM(f.quantity)                  AS total_quantity,
    SUM(f.sales_amount)              AS total_revenue,

    -- Average selling price
    ROUND(
        SUM(f.sales_amount) * 1.0 / NULLIF(SUM(f.quantity), 0),
        2
    ) AS avg_unit_price
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory;
GO
