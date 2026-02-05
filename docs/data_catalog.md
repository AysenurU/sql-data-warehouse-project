# **Data Catalog for Gold Layer**

## **Overview**

The Gold Layer represents the **business-ready data model** of the data warehouse.
It is designed to support **analytics, reporting, and decision-making** use cases.

The Gold Layer consists of:
- **Dimension views**: descriptive, slowly changing business entities
- **Fact views**: transactional business events
- **Analytics views**: aggregated, business-focused datasets derived from facts and dimensions

All analytics views are **read-only**, optimized for BI tools and analytical queries.

---

## **Dimensions**

### **1. gold.dim_customers**
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:**

| **Column Name**      | **Data Type**      | **Description**                                                                         |
|----------------------|--------------------|-----------------------------------------------------------------------------------------|
| customer_key         | INT                | Surrogate key uniquely identifying each customer record in the dimension table.         |
| customer_id          | INT                | Unique numerical identifier assigned to each customer.                                  |
| customer_number      | NVARCHAR(50)       | Alphanumeric identifier representing the customer, used for tracking and referencing.   |
| first_name           | NVARCHAR(50)       | The customer's first name, as recorded in the system.                                   |
| last_name            | NVARCHAR(50)       | The customer's last name or family name.                                                |
| country              | NVARCHAR(50)       | The country of residence for the customer (e.g., 'Australia').                          |
| marital_status       | NVARCHAR(50)       | The marital status of the customer (e.g., 'Married', 'Single').                         |
| gender               | NVARCHAR(50)       | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                             |
| birthdate            | DATE               | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).          |
| create_date          | DATE               | The date and time when the customer record was created in the system.                   |

---

### **2. gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| **Column Name**    | **Data Type**      | **Description**                                                                                   |
|--------------------|--------------------|-----------------------------------------------------------------------------------------------------|
| product_key         | INT                | Surrogate key uniquely identifying each product record in the product dimension table.               |
| product_id          | INT                | A unique identifier assigned to the product for internal tracking and referencing.                   |
| product_number      | NVARCHAR(50)       | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name           | NVARCHAR(50)       | Descriptive name of the product, including key details such as type, color, and size.             |
| category_id            | NVARCHAR(50)       | A unique identifier for the product's category, linking to its high-level classification.         |
| category              | NVARCHAR(50)       | The broader classification of the product (e.g., Bikes, Components) to group related items.        |
| subcategory       | NVARCHAR(50)       | A more detailed classification of the product within the category, such as product type.               |
| maintenance              | NVARCHAR(50)       | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                         |
| cost            | INT               | The cost or base price of the product, measured in monetary units.                                        |
| product_line          | NVARCHAR(50)               | The specific product line or series to which the product belongs (e.g., Road, Mountain).   |
| start_date | DATE | The date when the product became available for sale or use, stored in                                 |

---

### **3. gold.dim_date**
- **Purpose:** Centralized date dimension for time-based analytics.

| Column Name | Data Type | Description |
|------------|----------|-------------|
| date_key | INT | Date key in YYYYMMDD format |
| full_date | DATE | Calendar date |
| year | INT | Calendar year |
| month | INT | Month number (1–12) |
| month_name | VARCHAR | Month name (e.g., January) |
| day | INT | Day of month |
| day_of_week | VARCHAR | Name of weekday |

---

## **Fact**

### **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
  - order_date       → convenience column (readability)
  - order_date_key   → FK to dim_date (used for joins & performance) 
- **Columns:**

| **Column Name** | **Data Type** | **Description**            |
|----------------------|--------------------|-----------------------------------------------------------------------------------------|
| order_number  | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').   |
| product_key  | INT   | Surrogate key linking the order to the product dimension table.    |
| customer_key  | INT  | Surrogate key linking the order to the customer dimension table.   |
| order_date  | DATE | The date when the order was placed.     |
| order_date_key  | INT | FK to dim_date (YYYYMMDD)     |
| shipping_date  | DATE  | The date when the order was shipped to the customer.   |
| due_date  | DATE   | The date when the order payment was due.    |
| sales_amount  | INT | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |
| quantity  | INT  | The number of units of the product ordered for the line item (e.g., 1).    |
| price | INT  | The price per unit of the product for the line item, in whole currency units (e.g., 25).   |

---

## **Analytics Views**

Analytics views provide aggregated, business-focused metrics
They are derived from Gold fact and dimension views and are optimized for BI consumption.
Metric definitions follow a single-source-of-truth principle.
All monetary metrics are derived exclusively from `fact_sales.sales_amount`.
Time-based aggregations rely on `dim_date` to ensure calendar consistency.
In real production systems, monetary values should be stored as DECIMAL(p,s). INT is used here for simplicity.

---

### **1. gold.daily_sales**
- **Purpose:** Daily sales performance overview.
- **Grain:** One row per calendar day.
- **Key Metrics:** total_orders, total_quantity, total_revenue
- **Source:** gold.fact_sales, gold.dim_date

---

### **2. gold.monthly_sales**
- **Purpose:** Monthly sales trends with revenue growth analysis.
- **Grain:** One row per year-month.
- **Key Metrics:** total_revenue, revenue_growth_rate
- **Source:** gold.fact_sales, gold.dim_date

---

### **3. gold.product_sales**
- **Purpose:** Product-level sales performance analysis.
- **Grain:** One row per product.
- **Key Metrics:** total_orders, total_quantity, total_revenue, avg_unit_price
- **Source:** gold.fact_sales, gold.dim_products

---

### **4. gold.customer_sales**
- **Purpose:** Customer-level sales summary.
- **Grain:** One row per customer.
- **Key Metrics:** total_orders, total_revenue, avg_order_value, last_order_date
- **Source:** gold.fact_sales, gold.dim_customers, gold.dim_date

---

### **5. gold.customer_metrics**
- **Purpose:** Customer behavioral metrics supporting RFM-style analysis.
- **Grain:** One row per customer.
- **Key Metrics:** lifetime_revenue, first_order_date, last_order_date, days_since_last_order
- **Source:** gold.fact_sales, gold.dim_customers

---

### **6. gold.sales_kpis**
- **Purpose:** High-level sales KPIs for executive reporting.
- **Grain:** Single-row summary.
- **Key Metrics:** total_revenue, avg_order_value, revenue_per_item, active_customers
- **Source:** gold.fact_sales

---

### **7. gold.top_products**
- **Purpose:** Identifies top-performing products by revenue.
- **Grain:** One row per product.
- **Key Metrics:** total_revenue, revenue_rank
- **Source:** gold.fact_sales, gold.dim_products

---

### **8. gold.sales_by_category**
- **Purpose:** Category-level sales performance analysis.
- **Grain:** One row per product category.
- **Key Metrics:** total_revenue, avg_order_value
- **Source:** gold.fact_sales, gold.dim_products

---

### **9. gold.new_vs_returning_customers**
- **Purpose:** Tracks new versus returning customers over time.
- **Grain:** One row per calendar day.
- **Key Metrics:** new_customers, returning_customers
- **Source:** gold.fact_sales, gold.dim_date
