USE SalesCustomerAnalytics;
GO

IF OBJECT_ID('StagingSales', 'U') IS NOT NULL
    DROP TABLE StagingSales;
GO

CREATE TABLE StagingSales (
    RowID           INT,
    OrderID         VARCHAR(20),
    OrderDate       DATE,
    ShipDate        DATE,
    ShipMode        VARCHAR(50),
    CustomerID      VARCHAR(20),
    CustomerName    VARCHAR(100),
    Segment         VARCHAR(50),
    Country         VARCHAR(50),
    City            VARCHAR(100),
    State           VARCHAR(100),
    PostalCode      VARCHAR(10),
    Region          VARCHAR(50),
    ProductID       VARCHAR(20),
    Category        VARCHAR(50),
    SubCategory     VARCHAR(50),
    ProductName     VARCHAR(255),
    Sales           DECIMAL(12,2),
    Year            INT,
    Quarter         VARCHAR(2),
    Month           VARCHAR(20),
    MonthNumber     INT,
    YearMonth       VARCHAR(10),
    ShippingDays    INT
);
GO