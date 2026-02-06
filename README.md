# Data Warehouse Project – Sales Analytics (SQL Server)

## 🚀 Project Overview

This project is designed to closely resemble a **real-world enterprise implementation of a modern Data Warehouse (DWH)** with a strong focus on data modeling, data quality, and analytical usability using a **Bronze–Silver–Gold architecture**.

The data warehouse integrates **CRM and ERP source systems**, applies data cleansing and standardization, and delivers **business-ready analytical views** optimized for reporting and decision-making.

This project focuses on:
- Data modeling (Star Schema)
- ETL design using SQL
- Analytics view development
- Clear documentation and reproducibility

---

## 🏗️ Data Architecture

The data architecture for this project follows a Medallion Architecture with **Bronze**, **Silver**, and **Gold** layers:

![Data Architecture](diagrams/architecture.png)

### Layer Responsibilities

#### 🟤 Bronze Layer
- Raw ingestion from CRM and ERP CSV files
- No transformations applied
- Full load using truncate & insert
- Tables represent source data as-is

#### ⚪ Silver Layer
- Data cleansing and standardization
- Type conversions and validation
- Deduplication and integrity checks
- Enriched and normalized datasets
- Introduction of date dimension
- Business rule preparation for downstream analytics

#### 🟡 Gold Layer
- Business-ready semantic layer
- Star schema design (Facts & Dimensions)
- Analytics views for reporting and KPIs
- No physical data loads (views only)

📌 Detailed architecture diagrams are available in `/diagrams/` folder.

---

## 📦 Data Sources

### CRM
- Customer information
- Product information
- Sales transactions 

### ERP
- Additional customer attributes
- Location data
- Product category data

All source data is provided as CSV files and loaded into SQL Server.

---

## 🧱 Data Model (Gold Layer)

The Gold layer is designed as a Sales Data Mart using a Star Schema, optimized for analytical queries and BI consumption.

### Fact

- `gold.fact_sales`
  - Grain: one row per sales order line
  - Stores transactional sales data
  - Uses surrogate keys for dimensions

### Dimensions
- `gold.dim_customers`
- `gold.dim_products`
- `gold.dim_date`

This design enables efficient analytical queries and BI tool integration.

📌 The full data model and relationships are documented in `/diagrams/data_model.png`.

---

## 📈 Analytics Views

The Gold layer includes **analytics views** derived from fact and dimension views.
These views provide aggregated, business-focused metrics and serve as a **single source of truth** for reporting.

Analytics views are implemented as SQL views to ensure:
- Centralized business logic
- Consistent metric definitions
- No data duplication
- Reusability across dashboards and reports

### Available Analytics Views
- `gold.daily_sales`
- `gold.monthly_sales`
- `gold.product_sales`
- `gold.customer_sales`
- `gold.customer_metrics`
- `gold.sales_kpis`
- `gold.top_products`
- `gold.sales_by_category`
- `gold.new_vs_returning_customers`

Each analytics view includes:
- Clearly defined grain
- Business metrics
- Explicit source tables

📌 Detailed definitions are available in `/docs/data_catalog.md`.

---

## 🧪 Data Quality & Validation

Data quality is enforced primarily in the **Silver layer**, including:
- NULL handling
- Duplicate removal
- Referential integrity checks
- Invalid date detection
- Standardized data types

This ensures that the Gold layer operates on trusted, analytics-ready data.

Basic data quality checks are also implemented in the Gold layer to ensure referential integrity between fact and dimension views.

---

## 🛠️ Technologies Used

- **SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **CSV-based data ingestion**
- **draw.io** (architecture & data modeling diagrams)
- **Git & GitHub** for version control

---

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                                 # Raw datasets used for the project (ERP and CRM data)
│
├── diagrams/                                 # Project diagrams
│   ├── source/                         
|          ├── architecture.drawio            # Draw.io file shows the project's architecture
|          |── data_flow.drawio               # Draw.io file for the data flow diagram
|          |── data_mart_star_schema.drawio   # Draw.io file for data models (star schema)
|          |── integration_model.drawio       # Draw.io file for data integration model                                      
│   ├── architecture.png                          
│   ├── data_flow.png                 
│   ├── data_mart_star_schema.png               
│   ├── integration_model.png                     
|
├── docs/                                     # Project documentation and architecture details
│   ├── data_catalog.md                       # Catalog of datasets, including field descriptions and metadata
│   ├── naming-conventions.md                 # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                                  # SQL scripts for ETL and transformations
│   ├── bronze/                               # Scripts for extracting and loading raw data
│   ├── silver/                               # Scripts for cleaning and transforming data
│   ├── gold/                                 # Scripts for creating analytical models
|         |─── analytics/                     # Scripts for analytics views
|         |─── ddl_gold_core.sql              # Script for creating gold core 
│
├── tests/                                    # Test scripts and quality files
│
├── README.md                                 # Project overview and instructions
├── LICENSE                                   # License information for the repository
├── .gitignore                                # Files and directories to be ignored by Git
```

---

## 🎯 Key Learning Outcomes

This project demonstrates:
- Designing a layered Data Warehouse architecture
- Implementing a Star Schema for analytics
- Writing reusable and readable SQL transformations
- Creating analytics-ready views
- Documenting data models and business logic clearly

---

## 📌 Notes

- Monetary values are stored as INT for simplicity in this project. In production systems, DECIMAL(p,s) should be used.
- The project is designed for educational and portfolio purposes but follows real-world DWH best practices.

--- 

## 👤 Author

**Aysenur Ucar**

Aspiring Data Analyst | Data Engineer

Focused on SQL, Data Modeling, and Analytics Engineering

---

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/aysenuru)
