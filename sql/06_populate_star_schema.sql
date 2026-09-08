USE [SalesCustomerAnalytics];
GO

INSERT INTO [dbo].[DimCustomer] ([Customer ID], [Customer Name], [Segment])
SELECT DISTINCT s.CustomerID, s.CustomerName, s.Segment
FROM [dbo].[StagingSales] AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM [dbo].[DimCustomer] AS d
    WHERE d.[Customer ID] = s.CustomerID
);
GO

;WITH ProductRows AS
(
    SELECT
        s.ProductID,
        s.ProductName,
        s.Category,
        s.SubCategory,
        ROW_NUMBER() OVER (PARTITION BY s.ProductID ORDER BY s.RowID) AS RowNumber
    FROM [dbo].[StagingSales] AS s
)
INSERT INTO [dbo].[DimProduct] ([Product ID], [Product Name], [Category], [Sub-Category])
SELECT p.ProductID, p.ProductName, p.Category, p.SubCategory
FROM ProductRows AS p
WHERE p.RowNumber = 1
  AND NOT EXISTS
(
    SELECT 1
    FROM [dbo].[DimProduct] AS d
    WHERE d.[Product ID] = p.ProductID
);
GO

;WITH LocationRows AS
(
    SELECT
        s.PostalCode,
        s.City,
        s.State,
        s.Region,
        s.Country,
        ROW_NUMBER() OVER (PARTITION BY s.PostalCode ORDER BY s.RowID) AS RowNumber
    FROM [dbo].[StagingSales] AS s
    WHERE s.PostalCode IS NOT NULL
)
INSERT INTO [dbo].[DimLocation] ([Postal Code], [City], [State], [Region], [Country])
SELECT l.PostalCode, l.City, l.State, l.Region, l.Country
FROM LocationRows AS l
WHERE l.RowNumber = 1
  AND NOT EXISTS
(
      SELECT 1
      FROM [dbo].[DimLocation] AS d
      WHERE d.[Postal Code] = l.PostalCode
  );
GO

;WITH FactRows AS
(
    SELECT
        s.OrderID,
        s.OrderDate,
        s.ShipDate,
        s.CustomerID,
        s.ProductID,
        s.ShipMode,
        s.PostalCode,
        s.Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY s.OrderID, s.ProductID
            ORDER BY s.RowID
        ) AS RowNumber
    FROM [dbo].[StagingSales] AS s
)
INSERT INTO [dbo].[FactSales]
(
    [Order ID],
    [Order Date],
    [Ship Date],
    [Customer ID],
    [Product ID],
    [Ship Mode],
    [Postal Code],
    [Sales]
)
SELECT
    s.OrderID,
    s.OrderDate,
    s.ShipDate,
    s.CustomerID,
    s.ProductID,
    s.ShipMode,
    s.PostalCode,
    s.Sales
FROM FactRows AS s
WHERE s.RowNumber = 1
    AND NOT EXISTS
(
    SELECT 1
    FROM [dbo].[FactSales] AS f
    WHERE f.[Order ID] = s.OrderID
      AND f.[Product ID] = s.ProductID
);
GO

SELECT 'DimCustomer' AS [TableName], COUNT(*) AS [RowCount] FROM [dbo].[DimCustomer]
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM [dbo].[DimProduct]
UNION ALL
SELECT 'DimLocation', COUNT(*) FROM [dbo].[DimLocation]
UNION ALL
SELECT 'DimDate', COUNT(*) FROM [dbo].[DimDate]
UNION ALL
SELECT 'FactSales', COUNT(*) FROM [dbo].[FactSales]
UNION ALL
SELECT 'StagingSales', COUNT(*) FROM [dbo].[StagingSales];
GO
