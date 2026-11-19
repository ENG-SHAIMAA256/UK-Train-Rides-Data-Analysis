USE UK_Train_Rides;
GO

-- =============================================
-- 1. Check Row Counts Across All Tables
-- =============================================
SELECT 'FactRailway' AS TableName, COUNT(*) AS Total_Rows FROM dbo.FactRailway
UNION ALL
SELECT 'DimDate', COUNT(*) FROM dbo.DimDate
UNION ALL
SELECT 'DimTicket', COUNT(*) FROM dbo.DimTicket
UNION ALL
SELECT 'DimJourney', COUNT(*) FROM dbo.DimJourney
UNION ALL
SELECT 'DimPurchases', COUNT(*) FROM dbo.DimPurchases
UNION ALL
SELECT 'DimDepartureStation', COUNT(*) FROM dbo.DimDepartureStation
UNION ALL
SELECT 'DimArrivalStation', COUNT(*) FROM dbo.DimArrivalStation
UNION ALL
SELECT 'railway', COUNT(*) FROM dbo.railway;
GO

-- =============================================
-- 2. Preview Sample Rows from Main Tables
-- =============================================
SELECT TOP 5 * FROM dbo.FactRailway;
SELECT TOP 5 * FROM dbo.DimTicket;
SELECT TOP 5 * FROM dbo.DimJourney;
SELECT TOP 5 * FROM dbo.DimDate;
SELECT TOP 5 * FROM dbo.railway;
GO

-- =============================================
-- 3. Inspect Table Columns & Data Types
-- =============================================
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'FactRailway', 'DimDate', 'DimTicket', 
    'DimJourney', 'DimPurchases', 
    'DimDepartureStation', 'DimArrivalStation', 'railway'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO