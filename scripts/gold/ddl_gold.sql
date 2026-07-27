/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

Create view gold.dim_customers As
Select 
ROW_NUMBER() Over (Order by cst_id) as customer_key
ci.cst_id customer_id,
ci.cst_key customer_number,
ci.cst_firstname first_name,
ci.cst_lastname last_name,
la.cntry as country,
ci.cst_marital_status marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr
else coalesce(ca.gen, 'n/a')
end  gender,
ca.bdate birthdate,
ci.cst_create_date create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

Create view gold.dim_products AS
Select 
ROW_NUMBER() over (Order by prd_start_dt, prd_key) as product_key,
pn.prd_id product_id,
pn.prd_key product_number,
pn.prd_nm product_name,
pn.prd_cat_id category_id,
pcg.cat category,
pcg.subcat subcategory,
pcg.maintenance,
pn.prd_cost cost,
pn.prd_line product_line,
pn.prd_start_dt start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pcg
on pn.prd_cat_id = pcg.id
where prd_end_dt is null

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

Create view gold.fact_sales As
Select 
sd.sls_ord_num order_number,
dp.product_key,
dc.customer_key,
sd.sls_order_dt order_date,
sd.sls_ship_dt shipping_date,
sd.sls_due_dt due_date,
sd.sls_sales sales_amount,
sd.sls_quantity quantity, 
sd.sls_price price
from silver.crm_sales_details sd
left join gold.dim_products dp
on sd.sls_prd_key = dp.product_number
left join gold.dim_customers dc
on sd.sls_cust_id = dc.customer_id

