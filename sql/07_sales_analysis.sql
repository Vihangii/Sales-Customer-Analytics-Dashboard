USE SalesCustomerAnalytics;
GO

-- Total Sales
SELECT SUM(Sales) AS TotalSales FROM FactSales;

-- Sales by Year
SELECT d.[Year], SUM(f.Sales) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.OrderDate = d.[Date]
GROUP BY d.[Year]
ORDER BY d.[Year];

-- Sales by Category
SELECT p.Category, SUM(f.Sales) AS TotalSales
FROM FactSales f
JOIN DimProduct p ON f.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;

-- Top 10 Products
SELECT TOP 10 p.ProductName, SUM(f.Sales) AS TotalSales
FROM FactSales f
JOIN DimProduct p ON f.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC;
GO