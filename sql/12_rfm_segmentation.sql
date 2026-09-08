USE [SalesCustomerAnalytics];
GO

;WITH AnalysisDate AS
(
    SELECT MAX([Order Date]) AS [Analysis Date]
    FROM [dbo].[FactSales]
),
CustomerRFM AS
(
    SELECT
        c.[Customer ID],
        c.[Customer Name],
        c.[Segment],
        DATEDIFF(DAY, MAX(f.[Order Date]), a.[Analysis Date]) AS [Recency Days],
        COUNT(DISTINCT f.[Order ID]) AS [Frequency],
        SUM(f.[Sales]) AS [Monetary],
        a.[Analysis Date]
    FROM [dbo].[FactSales] AS f
    INNER JOIN [dbo].[DimCustomer] AS c
        ON f.[Customer ID] = c.[Customer ID]
    CROSS JOIN AnalysisDate AS a
    GROUP BY
        c.[Customer ID],
        c.[Customer Name],
        c.[Segment],
        a.[Analysis Date]
),
RFMScores AS
(
    SELECT
        r.*,
        6 - NTILE(5) OVER
        (
            ORDER BY r.[Recency Days] ASC, r.[Customer ID]
        ) AS [Recency Score],
        6 - NTILE(5) OVER
        (
            ORDER BY r.[Frequency] DESC, r.[Customer ID]
        ) AS [Frequency Score],
        6 - NTILE(5) OVER
        (
            ORDER BY r.[Monetary] DESC, r.[Customer ID]
        ) AS [Monetary Score]
    FROM CustomerRFM AS r
),
RFMSegments AS
(
    SELECT
        s.*,
        CASE
            WHEN s.[Recency Score] >= 4
             AND s.[Frequency Score] >= 4
             AND s.[Monetary Score] >= 4
                THEN 'Champions'
            WHEN s.[Frequency Score] >= 4
             OR (s.[Recency Score] >= 4 AND s.[Frequency Score] >= 3)
                THEN 'Loyal'
            WHEN s.[Monetary Score] >= 4
                THEN 'Big Spenders'
            WHEN s.[Recency Score] <= 2
             AND s.[Frequency Score] >= 3
                THEN 'At Risk'
            ELSE 'Lost'
        END AS [RFM Segment]
    FROM RFMScores AS s
)
SELECT
    [Customer ID],
    [Customer Name],
    [Segment],
    [Analysis Date],
    [Recency Days],
    [Frequency],
    [Monetary],
    [Recency Score],
    [Frequency Score],
    [Monetary Score],
    [RFM Segment]
FROM RFMSegments
ORDER BY
    [RFM Segment],
    [Monetary] DESC;
GO

-- Customer count by RFM segment
;WITH AnalysisDate AS
(
    SELECT MAX([Order Date]) AS [Analysis Date]
    FROM [dbo].[FactSales]
),
CustomerRFM AS
(
    SELECT
        c.[Customer ID],
        DATEDIFF(DAY, MAX(f.[Order Date]), a.[Analysis Date]) AS [Recency Days],
        COUNT(DISTINCT f.[Order ID]) AS [Frequency],
        SUM(f.[Sales]) AS [Monetary]
    FROM [dbo].[FactSales] AS f
    INNER JOIN [dbo].[DimCustomer] AS c
        ON f.[Customer ID] = c.[Customer ID]
    CROSS JOIN AnalysisDate AS a
    GROUP BY c.[Customer ID], a.[Analysis Date]
),
RFMScores AS
(
    SELECT
        r.*,
        6 - NTILE(5) OVER (ORDER BY r.[Recency Days] ASC, r.[Customer ID]) AS [Recency Score],
        6 - NTILE(5) OVER (ORDER BY r.[Frequency] DESC, r.[Customer ID]) AS [Frequency Score],
        6 - NTILE(5) OVER (ORDER BY r.[Monetary] DESC, r.[Customer ID]) AS [Monetary Score]
    FROM CustomerRFM AS r
)
SELECT
    CASE
        WHEN [Recency Score] >= 4 AND [Frequency Score] >= 4 AND [Monetary Score] >= 4 THEN 'Champions'
        WHEN [Frequency Score] >= 4 OR ([Recency Score] >= 4 AND [Frequency Score] >= 3) THEN 'Loyal'
        WHEN [Monetary Score] >= 4 THEN 'Big Spenders'
        WHEN [Recency Score] <= 2 AND [Frequency Score] >= 3 THEN 'At Risk'
        ELSE 'Lost'
    END AS [RFM Segment],
    COUNT(*) AS [Customer Count]
FROM RFMScores
GROUP BY
    CASE
        WHEN [Recency Score] >= 4 AND [Frequency Score] >= 4 AND [Monetary Score] >= 4 THEN 'Champions'
        WHEN [Frequency Score] >= 4 OR ([Recency Score] >= 4 AND [Frequency Score] >= 3) THEN 'Loyal'
        WHEN [Monetary Score] >= 4 THEN 'Big Spenders'
        WHEN [Recency Score] <= 2 AND [Frequency Score] >= 3 THEN 'At Risk'
        ELSE 'Lost'
    END
ORDER BY [Customer Count] DESC;
GO
