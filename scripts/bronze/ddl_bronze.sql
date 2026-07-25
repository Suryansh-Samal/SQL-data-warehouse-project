/*
================================================================================
DDL Scripts: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/

-- Create table of bronze layer

If object_id('bronze.crm_cust_info') is not null
	drop table bronze.crm_cust_info
Create Table bronze.crm_cust_info(
cst_id INT,
cst_key Nvarchar(50),
cst_fullname Nvarchar(50),
cst_lastname Nvarchar(50),
cst_material_status Nvarchar(50),
cst_gndr Nvarchar(50),
cst_create_date Date,
);

If object_id('bronze.crm_prd_info') is not null
	drop table bronze.crm_prd_info
Create Table bronze.crm_prd_info(
prd_id INT,
prd_key Nvarchar(50),
prd_nm Nvarchar(50),
prd_cost Nvarchar(50),
prd_line Nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime);

If object_id('bronze.crm_sales_details') is not null
	drop table bronze.crm_sales_details
Create Table bronze.crm_sales_details(
sls_ord_num Nvarchar(50),
sls_prd_key Nvarchar(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT);

If object_id('bronze.erp_cust_az12') is not null
	drop table bronze.erp_cust_az12
Create Table bronze.erp_cust_az12(
cid Nvarchar(50),
bdate date,
gen Nvarchar(50)
);

If object_id('bronze.erp_loc_a101') is not null
	drop table bronze.erp_loc_a101
Create Table bronze.erp_loc_a101(
cid Nvarchar(50),
cntry Nvarchar(50)
);

If object_id('bronze.erp_px_cat_g1v2') is not null
	drop table bronze.erp_px_cat_g1v2
Create Table bronze.erp_px_cat_g1v2(
id Nvarchar(50),
cat Nvarchar(50),
subcat Nvarchar(50),
maintenance Nvarchar(50)
);
