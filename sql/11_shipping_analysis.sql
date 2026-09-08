USE [SalesCustomerAnalytics];
GO

-- Average shipping days by ship mode
SELECT
    f.[Ship Mode],
    CAST(AVG(CAST(DATEDIFF(DAY, f.[Order Date], f.[Ship Date]) AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS [Average Shipping Days]
FROM [dbo].[FactSales] AS f
GROUP BY f.[Ship Mode]
ORDER BY [Average Shipping Days];
GO

-- Order counts by ship mode
SELECT
    f.[Ship Mode],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
GROUP BY f.[Ship Mode]
ORDER BY [Order Count] DESC;
GO

-- Region by ship mode average shipping days
SELECT
    l.[Region],
    f.[Ship Mode],
    CAST(AVG(CAST(DATEDIFF(DAY, f.[Order Date], f.[Ship Date]) AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS [Average Shipping Days],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimLocation] AS l
    ON f.[Postal Code] = l.[Postal Code]
GROUP BY
    l.[Region],
    f.[Ship Mode]
ORDER BY
    l.[Region],
    [Average Shipping Days];
GO
