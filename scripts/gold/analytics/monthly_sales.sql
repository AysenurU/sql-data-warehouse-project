/*
View Purpose:
-------------
Provides monthly aggregated sales metrics with month-over-month revenue growth.

Business Questions Answered:
- What is the total revenue per month?
- How does revenue change compared to the previous month?
- Are sales increasing or declining over time?

Grain:
------
One row per year-month.
*/

CREATE OR ALTER VIEW gold.monthly_sales
AS
WITH monthly_base AS (
    SELECT
        d.year                                   AS sales_year,
        d.month                                  AS sales_month,
        d.month_name                             AS month_name,
        COUNT(DISTINCT f.order_number)           AS total_orders,
        SUM(f.quantity)                          AS total_quantity,
        SUM(f.sales_amount)                     AS total_revenue
    FROM gold.fact_sales f
    JOIN gold.dim_date d
        ON d.date_key = f.order_date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
)
SELECT
    sales_year,
    sales_month,
    month_name,
    total_orders,
    total_quantity,
    total_revenue,

    -- Month-over-Month Revenue Growth Rate
    ROUND(
        (total_revenue 
         - LAG(total_revenue) OVER (ORDER BY sales_year, sales_month))
        * 1.0
        / NULLIF(LAG(total_revenue) OVER (ORDER BY sales_year, sales_month), 0),
        4
    ) AS revenue_growth_rate
FROM monthly_base;
GO
