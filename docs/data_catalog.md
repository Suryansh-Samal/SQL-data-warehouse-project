Data Catalog – Gold Layer
Overview

The Gold Layer represents the final, business-ready data model of the warehouse. It contains cleaned, standardized, and integrated data organized into dimension and fact tables using a star schema. These tables are optimized for business intelligence, reporting, dashboards, and analytical queries.

1. gold.dim_customers
Purpose

Stores customer information enriched with demographic and geographic details. Each record represents a unique customer and serves as the customer dimension for analytical reporting.
| Column Name       | Data Type    | Description                                                                   |
| ----------------- | ------------ | ----------------------------------------------------------------------------- |
| `customer_key`    | INT          | Surrogate key uniquely identifying each customer in the dimension table.      |
| `customer_id`     | INT          | Original customer identifier from the source CRM system.                      |
| `customer_number` | NVARCHAR(50) | Business identifier used to uniquely identify customers (e.g., `AW00011000`). |
| `first_name`      | NVARCHAR(50) | Customer's first name.                                                        |
| `last_name`       | NVARCHAR(50) | Customer's last name.                                                         |
| `country`         | NVARCHAR(50) | Country where the customer resides.                                           |
| `marital_status`  | NVARCHAR(50) | Customer's marital status (e.g., *Married*, *Single*, *n/a*).                 |
| `gender`          | NVARCHAR(50) | Standardized customer gender (e.g., *Male*, *Female*, *n/a*).                 |
| `birthdate`       | DATE         | Customer's date of birth in `YYYY-MM-DD` format.                              |
| `create_date`     | DATE         | Date the customer record was originally created in the source system.         |

2. gold.dim_products
Purpose

Contains product master data including categories, pricing, maintenance information, and product hierarchy. Each record represents one unique product.
| Column Name            | Data Type     | Description                                                                        |
| ---------------------- | ------------- | ---------------------------------------------------------------------------------- |
| `product_key`          | INT           | Surrogate key uniquely identifying each product.                                   |
| `product_id`           | INT           | Original product identifier from the source ERP system.                            |
| `product_number`       | NVARCHAR(50)  | Unique business product code used for identification.                              |
| `product_name`         | NVARCHAR(100) | Descriptive name of the product including model, size, and color where applicable. |
| `category_id`          | NVARCHAR(50)  | Identifier representing the product category.                                      |
| `category`             | NVARCHAR(50)  | High-level product category (e.g., **Bikes**, **Components**, **Accessories**).    |
| `subcategory`          | NVARCHAR(50)  | More detailed product classification within a category.                            |
| `maintenance_required` | NVARCHAR(10)  | Indicates whether the product requires maintenance (*Yes* or *No*).                |
| `cost`                 | DECIMAL(10,2) | Standard manufacturing or purchasing cost of the product.                          |
| `product_line`         | NVARCHAR(50)  | Product series or business line (e.g., *Road*, *Mountain*, *Touring*).             |
| `start_date`           | DATE          | Date the product became available for sale.                                        |

3. gold.fact_sales
Purpose

Stores transactional sales records. Each row represents a single sales order line and links customers and products through surrogate keys for analytical reporting.
| Column Name     | Data Type     | Description                                     |
| --------------- | ------------- | ----------------------------------------------- |
| `order_number`  | NVARCHAR(50)  | Unique identifier assigned to each sales order. |
| `product_key`   | INT           | Foreign key referencing `gold.dim_products`.    |
| `customer_key`  | INT           | Foreign key referencing `gold.dim_customers`.   |
| `order_date`    | DATE          | Date the order was placed.                      |
| `shipping_date` | DATE          | Date the order was shipped.                     |
| `due_date`      | DATE          | Payment due date for the order.                 |
| `sales_amount`  | DECIMAL(10,2) | Total sales amount for the order line.          |
| `quantity`      | INT           | Number of product units sold.                   |
| `price`         | DECIMAL(10,2) | Selling price per unit of the product.          |

 Relationship Summary
| Fact Table        | Dimension            | Join Key       |
| ----------------- | -------------------- | -------------- |
| `gold.fact_sales` | `gold.dim_customers` | `customer_key` |
| `gold.fact_sales` | `gold.dim_products`  | `product_key`  |
