/*
===============================================================================
Project      : SQL Data Warehouse
File         : 01_create_database.sql
Author       : Suryansh
Description  : Creates the DataWarehouse database and the Bronze, Silver,
               and Gold schemas. If the database already exists, it is
               dropped and recreated.
===============================================================================
*/

-- ============================================================================
-- Drop Existing Database (if it exists)
-- ============================================================================

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

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
