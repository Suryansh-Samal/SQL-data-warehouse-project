/*
===============================================================================
Project      : SQL Data Warehouse
File         : 01_create_database.sql
Author       : Suryansh
Description  : Creates the SQL Data Warehouse database and the required schemas
               following the Medallion Architecture (Bronze, Silver, Gold).

Schemas:
    • Bronze - Stores raw data imported from source systems.
    • Silver - Stores cleaned and transformed data.
    • Gold   - Stores business-ready data for reporting and analytics.
===============================================================================
*/

-- ============================================================================
-- Create Database
-- ============================================================================

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- ============================================================================
-- Create Schemas
-- ============================================================================

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
