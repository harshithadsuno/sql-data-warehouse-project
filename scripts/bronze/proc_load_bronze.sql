/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/



CREATE or ALTER PROCEDURE bronze.load_bronze AS

BEGIN

    DECLARE @batch_start_time DATETIME, @start_time DATETIME, @end_time DATETIME, @batch_end_time DATETIME;

    SET @batch_start_time = GETDATE();

    BEGIN TRY

        PRINT '========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================================';

        PRINT '----------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '----------------------------------------';


        SET @start_time = GETDATE();

        PRINT ' >> Truncating Table: bronze.crm_cust_info '
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT ' >> Inserting Data Into: bronze.crm_cust_info ';
        BULK INSERT bronze.crm_cust_info
        from '/datasets/source_crm/cust_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';


        SET @start_time = GETDATE();
        PRINT ' >> Truncating Table: bronze.crm_prd_info ';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT  '>> Inserting Data Into: bronze.crm_prd_info ';
        BULK INSERT bronze.crm_prd_info
        from '/datasets/source_crm/prd_info.csv' 
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';


        SET @start_time = GETDATE();
        PRINT ' >> Truncating Table: bronze.crm_sales_details ';
        TRUNCATE TABLE bronze.crm_sales_details;

        
        PRINT ' >> Inserting Data Into: bronze.crm_sales_details ';
        BULK INSERT bronze.crm_sales_details
        from '/datasets/source_crm/sales_details.csv' 
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';

        PRINT '----------------------------------------';
        PRINT ' Loading ERP Tables';
        PRINT '----------------------------------------';

        SET @start_time = GETDATE();
        PRINT ' >> Truncating Table: bronze.erp_loc_a101 ';
        TRUNCATE TABLE bronze.erp_loc_a101;

        
        PRINT ' >> Inserting Data Into: bronze.erp_loc_a101 ';
        BULK INSERT bronze.erp_loc_a101
        from '/datasets/source_erp/LOC_A101.csv' 
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';

        SET @start_time = GETDATE();
        PRINT ' >> Truncating Table: bronze.erp_cust_az12 ';
        TRUNCATE TABLE bronze.erp_cust_az12;

        
        PRINT ' >> Inserting Data Into: bronze.erp_cust_az12 ';
        BULK INSERT bronze.erp_cust_az12
        from '/datasets/source_erp/CUST_AZ12.csv' 
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';

        SET @start_time = GETDATE();
        PRINT ' >> Truncating Table: bronze.erp_px_cat_g1v2 ';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT ' >> Inserting Data Into: bronze.erp_px_cat_g1v2 ';
        BULK INSERT bronze.erp_px_cat_g1v2
        from '/datasets/source_erp/PX_CAT_G1V2.csv' 
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT ' >> Load Duration:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + 'seconds';

    SET @batch_end_time = GETDATE();
    PRINT '========================================';
    PRINT 'Loading Bronze Layer is completed';
    PRINT ' >>  Total Bronze Layer Load Duration:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR) + 'seconds';
    PRINT '========================================';

    END TRY

    BEGIN CATCH

        PRINT '========================================';
        PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER'
        PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
        PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '========================================';

    END CATCH

END
