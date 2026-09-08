USE SalesCustomerAnalytics;
GO

-- Step 1: Widen the Year-Month column so it can hold values like '2017-Jan' (8 chars)
ALTER TABLE DimDate
ALTER COLUMN [Year-Month] VARCHAR(10) NOT NULL;
GO

-- Step 2: Clear out any previous (failed) rows
DELETE FROM DimDate;
GO

-- Step 3: Populate DimDate with one row per day from 2015-01-01 to 2018-12-31
DECLARE @CurrentDate DATE = '2015-01-01';
DECLARE @EndDate DATE = '2018-12-31';

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO DimDate ([Date], [Year], [Quarter], [Month], [Month Number], [Year-Month])
    VALUES (
        @CurrentDate,
        YEAR(@CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        MONTH(@CurrentDate),
        FORMAT(@CurrentDate, 'yyyy-MMM')
    );