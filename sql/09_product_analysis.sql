USE [SalesCustomerAnalytics];
GO

-- Sales by sub-category
SELECT
    p.[Category],
    p.[Sub-Category],
    SUM(f.[Sales]) AS [Total Sales],
    COUNT(DISTINCT f.[Order ID]) AS [Order Count]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimProduct] AS p
    ON f.[Product ID] = p.[Product ID]
GROUP BY
    p.[Category],
    p.[Sub-Category]
ORDER BY [Total Sales] DESC;
GO

-- Category performance comparison
;WITH CategorySales AS
(
    SELECT
        p.[Category],
        SUM(f.[Sales]) AS [Total Sales],
        COUNT(DISTINCT f.[Order ID]) AS [Order Count],
        COUNT(DISTINCT p.[Product ID]) AS [Product Count]
    FROM [dbo].[FactSales] AS f
    INNER JOIN [dbo].[DimProduct] AS p
        ON f.[Product ID] = p.[Product ID]
    GROUP BY p.[Category]
)
SELECT
    [Category],
    [Total Sales],
    [Order Count],
    [Product Count],
    CAST
    (
        100.0 * [Total Sales] / NULLIF(SUM([Total Sales]) OVER (), 0)
        AS DECIMAL(5, 2)
    ) AS [Sales Share Percent]
FROM CategorySales
ORDER BY [Total Sales] DESC;
GO
