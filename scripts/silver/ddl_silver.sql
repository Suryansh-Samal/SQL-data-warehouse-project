-- Create table of silver layer

If object_id('silver.crm_cust_info') is not null
	drop table silver.crm_cust_info
Create Table silver.crm_cust_info(
cst_id INT,
cst_key Nvarchar(50),
cst_firstname Nvarchar(50),
cst_lastname Nvarchar(50),
cst_maritial_status Nvarchar(50),
cst_gndr Nvarchar(50),
cst_create_date Date,
dwh_create_date Datetime2 Default GETDATE()
);

If object_id('silver.crm_prd_info') is not null
	drop table silver.crm_prd_info
Create Table silver.crm_prd_info(
prd_id INT,
prd_key Nvarchar(50),
prd_cat_id Nvarchar(50),
prd_nm Nvarchar(50),
prd_cost Nvarchar(50),
prd_line Nvarchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date Datetime2 Default GETDATE()
);

If object_id('silver.crm_sales_details') is not null
	drop table silver.crm_sales_details
Create Table silver.crm_sales_details(
sls_ord_num Nvarchar(50),
sls_prd_key Nvarchar(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date Datetime2 Default GETDATE()
);

If object_id('silver.erp_cust_az12') is not null
	drop table silver.erp_cust_az12
Create Table silver.erp_cust_az12(
cid Nvarchar(50),
bdate date,
gen Nvarchar(50),
dwh_create_date Datetime2 Default GETDATE()
);

If object_id('silver.erp_loc_a101') is not null
	drop table silver.erp_loc_a101
Create Table silver.erp_loc_a101(
cid Nvarchar(50),
cntry Nvarchar(50),
dwh_create_date Datetime2 Default GETDATE()
);

If object_id('silver.erp_px_cat_g1v2') is not null
	drop table silver.erp_px_cat_g1v2
Create Table silver.erp_px_cat_g1v2(
id Nvarchar(50),
cat Nvarchar(50),
subcat Nvarchar(50),
maintenance Nvarchar(50),
dwh_create_date Datetime2 Default GETDATE()
);
