USE [SalesCustomerAnalytics];
GO

-- Sales by region
SELECT
    l.[Region],
    SUM(f.[Sales]) AS [Total Sales],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimLocation] AS l
    ON f.[Postal Code] = l.[Postal Code]
GROUP BY l.[Region]
ORDER BY [Total Sales] DESC;
GO

-- Sales by state
SELECT
    l.[State],
    l.[Region],
    SUM(f.[Sales]) AS [Total Sales],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimLocation] AS l
    ON f.[Postal Code] = l.[Postal Code]
GROUP BY
    l.[State],
    l.[Region]
ORDER BY [Total Sales] DESC;
GO

-- Sales by city
SELECT
    l.[City],
    l.[State],
    l.[Region],
    SUM(f.[Sales]) AS [Total Sales],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimLocation] AS l
    ON f.[Postal Code] = l.[Postal Code]
GROUP BY
    l.[City],
    l.[State],
    l.[Region]
ORDER BY [Total Sales] DESC;
GO
