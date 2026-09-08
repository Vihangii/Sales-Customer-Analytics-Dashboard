USE SalesCustomerAnalytics;
GO

BULK INSERT StagingSales
FROM 'C:\Projects\Sales & Customer Analytics Dashboard\Sales-Customer-Analytics-Dashboard\data\cleaned\train_cleaned.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001',
    FORMAT = 'CSV',
    FIELDQUOTE = '"'
);
GO

SELECT COUNT(*) AS RowsLoaded FROM StagingSales;
GO