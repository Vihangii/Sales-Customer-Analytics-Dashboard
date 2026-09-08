USE [SalesCustomerAnalytics];
GO

CREATE TABLE [dbo].[DimCustomer]
(
    [Customer ID] NVARCHAR(50) NOT NULL,
    [Customer Name] NVARCHAR(200) NOT NULL,
    [Segment] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_DimCustomer] PRIMARY KEY ([Customer ID])
);
GO

CREATE TABLE [dbo].[DimProduct]
(
    [Product ID] NVARCHAR(50) NOT NULL,
    [Product Name] NVARCHAR(200) NOT NULL,
    [Category] NVARCHAR(100) NOT NULL,
    [Sub-Category] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_DimProduct] PRIMARY KEY ([Product ID])
);
GO

CREATE TABLE [dbo].[DimLocation]
(
    [Postal Code] NVARCHAR(20) NOT NULL,
    [City] NVARCHAR(100) NOT NULL,
    [State] NVARCHAR(100) NOT NULL,
    [Region] NVARCHAR(50) NOT NULL,
    [Country] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_DimLocation] PRIMARY KEY ([Postal Code])
);
GO

CREATE TABLE [dbo].[DimDate]
(
    [Date] DATE NOT NULL,
    [Year] SMALLINT NOT NULL,
    [Quarter] TINYINT NOT NULL,
    [Month] NVARCHAR(20) NOT NULL,
    [Month Number] TINYINT NOT NULL,
    [Year-Month] CHAR(7) NOT NULL,
    CONSTRAINT [PK_DimDate] PRIMARY KEY ([Date]),
    CONSTRAINT [CK_DimDate_Quarter] CHECK ([Quarter] BETWEEN 1 AND 4),
    CONSTRAINT [CK_DimDate_MonthNumber] CHECK ([Month Number] BETWEEN 1 AND 12)
);
GO

CREATE TABLE [dbo].[FactSales]
(
    [Order ID] NVARCHAR(50) NOT NULL,
    [Order Date] DATE NOT NULL,
    [Ship Date] DATE NOT NULL,
    [Customer ID] NVARCHAR(50) NOT NULL,
    [Product ID] NVARCHAR(50) NOT NULL,
    [Ship Mode] NVARCHAR(50) NOT NULL,
    [Postal Code] NVARCHAR(20) NULL,
    [Sales] DECIMAL(19, 4) NOT NULL,
    CONSTRAINT [PK_FactSales] PRIMARY KEY ([Order ID], [Product ID]),
    CONSTRAINT [FK_FactSales_DimCustomer] FOREIGN KEY ([Customer ID])
        REFERENCES [dbo].[DimCustomer] ([Customer ID]),
    CONSTRAINT [FK_FactSales_DimProduct] FOREIGN KEY ([Product ID])
        REFERENCES [dbo].[DimProduct] ([Product ID]),
    CONSTRAINT [FK_FactSales_DimLocation] FOREIGN KEY ([Postal Code])
        REFERENCES [dbo].[DimLocation] ([Postal Code]),
    CONSTRAINT [FK_FactSales_OrderDate] FOREIGN KEY ([Order Date])
        REFERENCES [dbo].[DimDate] ([Date]),
    CONSTRAINT [FK_FactSales_ShipDate] FOREIGN KEY ([Ship Date])
        REFERENCES [dbo].[DimDate] ([Date])
);
GO