USE UK_Train_Rides;
GO

-- =============================================
-- 1. Revenue & Overall KPIs
-- =============================================

-- Q1: Total Journeys, Total Revenue, and Average Ticket Price
SELECT 
    COUNT([Transaction ID]) AS Total_Journeys,
    ROUND(SUM([Price]), 2) AS Total_Revenue,
    ROUND(AVG([Price]), 2) AS Avg_Ticket_Price
FROM dbo.FactRailway;
GO

-- Q2: Journey Status Breakdown (On-Time, Delayed, Cancelled %)
SELECT 
    [Journey Status],
    COUNT([Transaction ID]) AS Total_Journeys,
    ROUND(COUNT([Transaction ID]) * 100.0 / SUM(COUNT([Transaction ID])) OVER(), 2) AS Percentage
FROM dbo.FactRailway
GROUP BY [Journey Status]
ORDER BY Total_Journeys DESC;
GO

-- Q3: Revenue Lost on Cancelled Journeys & Refund Requests
SELECT 
    [Journey Status],
    [Refund Request],
    COUNT([Transaction ID]) AS Total_Journeys,
    ROUND(SUM([Price]), 2) AS Total_Amount
FROM dbo.railway
WHERE [Journey Status] = 'Cancelled' OR [Refund Request] = 'Yes'
GROUP BY [Journey Status], [Refund Request]
ORDER BY Total_Amount DESC;
GO

-- =============================================
-- 2. Passenger Behavior & Ticketing
-- =============================================

-- Q4: Sales & Revenue by Ticket Class and Ticket Type
SELECT 
    [Ticket Class],
    [Ticket Type],
    COUNT([Transaction ID]) AS Total_Tickets,
    ROUND(SUM([Price]), 2) AS Total_Revenue,
    ROUND(AVG([Price]), 2) AS Avg_Price
FROM dbo.railway
GROUP BY [Ticket Class], [Ticket Type]
ORDER BY Total_Revenue DESC;
GO

-- Q5: Purchase Channels & Payment Methods Performance
SELECT 
    [Purchase Type],
    [Payment Method],
    COUNT([Transaction ID]) AS Total_Transactions,
    ROUND(SUM([Price]), 2) AS Total_Revenue
FROM dbo.railway
GROUP BY [Purchase Type], [Payment Method]
ORDER BY Total_Transactions DESC;
GO

-- Q6: Impact of Railcards on Ticket Sales & Revenue (Using Star Schema JOIN)
SELECT 
    t.[Railcard],
    COUNT(f.[Transaction ID]) AS Total_Tickets,
    ROUND(SUM(f.[Price]), 2) AS Total_Revenue,
    ROUND(AVG(f.[Price]), 2) AS Avg_Ticket_Price
FROM dbo.FactRailway f
JOIN dbo.DimTicket t ON f.[Transaction ID] = t.[Transaction ID]
GROUP BY t.[Railcard]
ORDER BY Total_Tickets DESC;
GO

-- =============================================
-- 3. Stations & Routes Analysis
-- =============================================

-- Q7A: Top 5 Busiest Departure Stations
SELECT TOP 5
    d.[Departure Station],
    COUNT(f.[Transaction ID]) AS Total_Departures,
    ROUND(SUM(f.[Price]), 2) AS Total_Revenue
FROM dbo.FactRailway f
JOIN dbo.DimDepartureStation d ON f.[Departure Station] = d.[Departure Station]
GROUP BY d.[Departure Station]
ORDER BY Total_Departures DESC;
GO

-- Q7B: Top 5 Busiest Arrival Destinations
SELECT TOP 5
    a.[Arrival Destination],
    COUNT(f.[Transaction ID]) AS Total_Arrivals,
    ROUND(SUM(f.[Price]), 2) AS Total_Revenue
FROM dbo.FactRailway f
JOIN dbo.DimArrivalStation a ON f.[Arrival Destination] = a.[Arrival Destination]
GROUP BY a.[Arrival Destination]
ORDER BY Total_Arrivals DESC;
GO

-- Q8: Top 10 Highest-Revenue Routes
SELECT TOP 10
    [Departure Station],
    [Arrival Destination],
    COUNT([Transaction ID]) AS Total_Journeys,
    ROUND(SUM([Price]), 2) AS Total_Revenue
FROM dbo.FactRailway
GROUP BY [Departure Station], [Arrival Destination]
ORDER BY Total_Revenue DESC;
GO

-- =============================================
-- 4. Delays & Operational Efficiency
-- =============================================

-- Q9: Main Reasons for Delay & Affected Journeys
SELECT 
    [Reason for Delay],
    COUNT([Transaction ID]) AS Delayed_Journeys,
    ROUND(AVG([Delay_Minutes]), 1) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE [Journey Status] = 'Delayed'
GROUP BY [Reason for Delay]
ORDER BY Delayed_Journeys DESC;
GO

-- Q10: Top 10 Routes with Highest Average Delay Minutes
SELECT TOP 10
    [Departure Station],
    [Arrival Destination],
    COUNT([Transaction ID]) AS Delayed_Journeys,
    ROUND(AVG([Delay_Minutes]), 1) AS Avg_Delay_Minutes
FROM dbo.FactRailway
WHERE [Journey Status] = 'Delayed'
GROUP BY [Departure Station], [Arrival Destination]
HAVING COUNT([Transaction ID]) >= 10
ORDER BY Avg_Delay_Minutes DESC;
GO

-- =============================================
-- 5. Time & Trend Analysis
-- =============================================

-- Q11A: Monthly Revenue & Journey Trends (Using DimDate JOIN)
SELECT 
    dt.[Year],
    dt.[Month Number],
    dt.[Month],
    COUNT(f.[Transaction ID]) AS Total_Journeys,
    ROUND(SUM(f.[Price]), 2) AS Total_Revenue
FROM dbo.FactRailway f
JOIN dbo.DimDate dt ON CAST(f.[Date of Purchase] AS DATE) = CAST(dt.[Date] AS DATE)
GROUP BY dt.[Year], dt.[Month Number], dt.[Month]
ORDER BY dt.[Year], dt.[Month Number];
GO

-- Q11B: Journeys & Revenue by Day of Week
SELECT 
    dt.[Day Number],
    dt.[Day Name],
    COUNT(f.[Transaction ID]) AS Total_Journeys,
    ROUND(SUM(f.[Price]), 2) AS Total_Revenue
FROM dbo.FactRailway f
JOIN dbo.DimDate dt ON CAST(f.[Date of Purchase] AS DATE) = CAST(dt.[Date] AS DATE)
GROUP BY dt.[Day Number], dt.[Day Name]
ORDER BY dt.[Day Number];
GO

-- Q12: Peak Hours for Ticket Purchases
SELECT 
    DATEPART(HOUR, [Time of Purchase]) AS Purchase_Hour,
    COUNT([Transaction ID]) AS Total_Tickets,
    ROUND(SUM([Price]), 2) AS Total_Revenue
FROM dbo.FactRailway
GROUP BY DATEPART(HOUR, [Time of Purchase])
ORDER BY Purchase_Hour;
GO