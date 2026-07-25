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

-- Ingesting the data from file

Create or Alter Procedure bronze.load_bronze As
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime ;
	begin try
		set @batch_start_time = GETDATE();
		Print'----------------------------------------------------';
		Print'Loading Bronze Layer';
		Print'----------------------------------------------------';

		Print'----------------------------------------------------';
		Print'Loading CRM Tables';
		Print'----------------------------------------------------';

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.crm_cust_info'
		Truncate table bronze.crm_cust_info;

		Print'>> Inserting Data into Table: bronze.crm_cust_info'
		Bulk Insert bronze.crm_cust_info
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.crm_prd_info'
		Truncate table bronze.crm_prd_info;

		Print'>> Inserting Data into Table: bronze.crm_prd_info'
		Bulk Insert bronze.crm_prd_info
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.crm_sales_details'
		Truncate table bronze.crm_sales_details;

		Print'>> Inserting Data into Table: bronze.crm_sales_details'
		Bulk Insert bronze.crm_sales_details
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

		Print'----------------------------------------------------';
		Print'Loading ERP Tables';
		Print'----------------------------------------------------';

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.erp_cust_az12'
		Truncate table bronze.erp_cust_az12;

		Print'>> Inserting Data into Table: bronze.erp_cust_az12'
		Bulk Insert bronze.erp_cust_az12
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.erp_loc_a101'
		Truncate table bronze.erp_loc_a101;

		Print'>> Inserting Data into Table: bronze.erp_loc_a101'
		Bulk Insert bronze.erp_loc_a101
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

		Set @start_time= getdate();
		Print'>> Truncating Table: bronze.erp_px_cat_g1v2'
		Truncate table bronze.erp_px_cat_g1v2;

		Print'>> Inserting Data into Table: bronze.erp_px_cat_g1v2'
		Bulk Insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Suryansh\Documents\gitsql\SQL- Data-Warehouse\Project DW\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time= GETDATE()
		Print'>>Load Duration: ' + Cast(datediff(second,@start_time, @end_time) as nvarchar) + 'seconds';
		Print'>>--------------'

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
end
