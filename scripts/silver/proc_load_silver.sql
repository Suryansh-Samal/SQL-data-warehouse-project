Create or Alter Procedure silver.load_silver As
Begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime ;
	begin try
	set @batch_start_time = GETDATE();
	Print'----------------------------------------------------';
	Print'Loading Silver Layer';
	Print'----------------------------------------------------';

	Print'----------------------------------------------------';
	Print'Loading CRM Tables';
	Print'----------------------------------------------------';
	-- Loading silver.crm_cust_info
	Set @start_time= getdate();
	Print'>> Truncating Table silver.crm_cust_info'
	Truncate Table silver.crm_cust_info

	Print'>> Inserting Data into Table silver.crm_cust_info'
	Insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_maritial_status,
	cst_gndr,
	cst_create_date	)

	Select
	cst_id,

	cst_key,

	trim(cst_firstname) as cst_fullname,

	trim(cst_lastname) as cst_lastname,

	case when Upper(Trim(cst_maritial_status)) = 'M' Then 'Married'
		 when Upper(Trim(cst_maritial_status)) = 'S' Then 'Single'
		 Else 'n/a'
	end cst_maritial_status, --Normalize maritial status values to a readable format

	case when Upper(Trim(cst_gndr)) = 'F' Then 'Female'
		 when Upper(Trim(cst_maritial_status)) = 'M' Then 'Male'
		 Else 'n/a'
	end cst_gndr, --Normalize gndr status values to a readable format

	cst_create_date

	from(
	Select 
		*,
		ROW_NUMBER() Over (Partition by cst_id Order by cst_create_date desc) as Flag_last
	from bronze.crm_cust_info
	where cst_id is not null) t
	where Flag_last = 1 -- Select the most recent record per customer
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'

	-- Loading silver.crm_prd_info
	Set @start_time= getdate();
	Print'>> Truncating Table silver.crm_prd_info'
	Truncate Table silver.crm_prd_info
	Print'Inserting Data into Table silver.crm_prd_info'
	Insert into silver.crm_prd_info(
	prd_id,
	prd_key,
	prd_cat_id,
	prd_nm, 
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)

	Select 
		prd_id,
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key, -- Extract key
		Replace(SUBSTRING(prd_key,1,5), '-','_') as cat_id, -- Extract cat_id
		prd_nm,
		isnull (prd_cost,0) prd_cost, -- Converting all the null values to 0
		case upper(trim(prd_line))
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'M' then 'Mountains'
			when 'T' then 'Touring'
			else 'n/a'
			end as prd_line, -- Map product line codes to descriptive values
		cast(prd_start_dt as date) prd_start_dt,
		cast(
		lead(prd_start_dt) over (Partition by prd_key Order by prd_start_dt)-1 
		as date
		)As prd_end_dt --Calculate end date as one day before
	from bronze.crm_prd_info
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'

	-- Loading silver.crm_sales_details
	Set @start_time= getdate();
	Print'>> Truncating Table silver.crm_sales_details'
	Truncate Table silver.crm_sales_details
	Print'>> Inserting Data into Table silver.crm_sales_details'
	Insert into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)

	Select 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	Case when sls_order_dt = 0 or len(sls_order_dt) !=8 then Null
	else cast(cast( sls_order_dt as varchar) as date) -- handling invalid data
	end sls_order_dt,
	Case when sls_ship_dt = 0 or len(sls_ship_dt) !=8 then Null
	else cast(cast( sls_ship_dt as varchar) as date) 
	end sls_ship_dt,
	Case when sls_due_dt = 0 or len(sls_due_dt) !=8 then Null
	else cast(cast( sls_due_dt as varchar) as date) 
	end sls_due_dt,
	case when sls_sales is null or sls_sales <=0 or sls_sales != abs(sls_price)*sls_quantity
	then sls_quantity * abs(sls_price) 
	else sls_sales -- Recalculate sales if original value is missing 
	end sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price <=0
	then sls_sales/nullif(sls_quantity,0)
	else sls_price
	end sls_price -- Derive price if original value is invalid
	from bronze.crm_sales_details
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'

	-- Starting Loading ERP Table
	Print'----------------------------------------------------';
	Print'Loading ERP Tables';
	Print'----------------------------------------------------';

	-- Loading silver.erp_cust_az12
	Set @start_time= getdate();
	Print'>> Truncating Table silver.erp_cust_az12'
	Truncate Table silver.erp_cust_az12
	Print'>> Inserting Data into Table silver.erp_cust_az12'
	Insert into silver.erp_cust_az12(
	cid,
	bdate,
	gen
	)

	Select
	case when cid like 'NAS%' 
	then SUBSTRING(cid,4,len(cid)) -- Remove 'NAS' prrfix if present
	else cid
	end cid,
	case when bdate>=GETDATE()
	then null  -- Set future bdate to null
	else bdate
	end bdate,
	case
	when Upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
	when Upper(trim(gen)) in ('M', 'MALE') then 'Male'
	else 'n/a'
	end gen -- Normalize gender values and handle unknown
	from bronze.erp_cust_az12
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'

	-- Loading silver.erp_loc_a101
	Set @start_time= getdate();
	Print'>> Truncating Table silver.erp_loc_a101'
	Truncate Table silver.erp_loc_a101
	Print'>> Inserting Data into Table silver.erp_loc_a101'
	Insert into silver.erp_loc_a101(
	cid,
	cntry
	)

	Select 
		Replace (cid, '-','') as cid,
		Case 
			when Upper(trim(cntry)) = 'DE' then 'Germany'
			when Upper(trim(cntry)) in ('US', 'United States') then 'United States'
			when trim(cntry) = '' or cntry is null then 'n/a'
			else trim(cntry)
		end cntry -- Normalize and handle missing or blank values
	from bronze.erp_loc_a101
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'

	-- Loading silver.erp_px_cat_g1v2
	Set @start_time= getdate();
	Print'>> Truncating Table silver.erp_px_cat_g1v2'
	Truncate Table silver.erp_px_cat_g1v2
	Print'>> Inserting Data into Table silver.erp_px_cat_g1v2'
	Insert into silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
	)

	Select 
	id,
	cat,
	subcat,
	maintenance
	from bronze.erp_px_cat_g1v2
	set @end_time= GETDATE()
	Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
	Print'>>-----------------------------------------------------------------------------------------'
	set @batch_end_time = GETDATE();
	Print'============================================';
	Print'Loading Bronze Layer is Completed';
	Print'Total Load Duration: ' + cast(datediff(second, @batch_start_time,@batch_end_time) as nvarchar) + 'Seconds'
	Print'============================================';
	end try
	begin catch 
	Print'------------------------------------------'
	Print'Error Occured During Loading Bronze Layer'
	Print'Error Message' + Error_Message();
	Print'Error Message' + Cast( Error_Number() as Nvarchar);
	Print'Error Message' + Cast(Error_State() as Nvarchar);
	Print'------------------------------------------'
	end catch
End 



