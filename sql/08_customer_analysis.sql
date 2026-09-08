USE [SalesCustomerAnalytics];
GO

-- Top 10 customers by total sales
SELECT TOP (10)
    c.[Customer ID],
    c.[Customer Name],
    SUM(f.[Sales]) AS [Total Sales]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimCustomer] AS c
    ON f.[Customer ID] = c.[Customer ID]
GROUP BY
    c.[Customer ID],
    c.[Customer Name]
ORDER BY [Total Sales] DESC;
GO

-- Sales by customer segment
SELECT
    c.[Segment],
    SUM(f.[Sales]) AS [Total Sales]
FROM [dbo].[FactSales] AS f
INNER JOIN [dbo].[DimCustomer] AS c
    ON f.[Customer ID] = c.[Customer ID]
GROUP BY c.[Segment]
ORDER BY [Total Sales] DESC;
GO

-- Repeat customer rate: customers with at least two distinct orders
;WITH CustomerOrderCounts AS
(
    SELECT
        c.[Customer ID],
        COUNT(DISTINCT f.[Order ID]) AS [Distinct Order Count]
    FROM [dbo].[FactSales] AS f
    INNER JOIN [dbo].[DimCustomer] AS c
        ON f.[Customer ID] = c.[Customer ID]
    GROUP BY c.[Customer ID]
)
SELECT
    COUNT(*) AS [Total Customers],
    SUM(CASE WHEN [Distinct Order Count] >= 2 THEN 1 ELSE 0 END) AS [Repeat Customers],
    CAST
    (
        100.0 * SUM(CASE WHEN [Distinct Order Count] >= 2 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5, 2)
    ) AS [Repeat Customer Rate Percent]
FROM CustomerOrderCounts;
GO
