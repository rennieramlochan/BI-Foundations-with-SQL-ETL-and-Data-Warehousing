-- Update Car Dimension
INSERT INTO Car_dim (CarId, Model, Engine, Transmission, Color, Price, Body_Style, Company)
SELECT DISTINCT
    s.Car_id,
    s.Model,
    s.Engine,
    s.Transmission,
    s.Color,
    s.Price,
    s.[Body Style],
    s.Company
FROM
    staging s
WHERE NOT EXISTS (
    SELECT 1
    FROM Car_dim cd
    WHERE cd.CarId = s.Car_id
);


-- Update Dealer Dimension
INSERT INTO Dealer_dim (DealerNo, Dealer_Name, Dealer_Region)
SELECT DISTINCT
    s.Dealer_No,
    s.Dealer_Name,
    s.Dealer_Region
FROM
    staging s
WHERE NOT EXISTS (
    SELECT 1
    FROM Dealer_dim dd
    WHERE dd.[DealerNo] = s.Dealer_No AND dd.[Dealer_Name] = s.[Dealer_Name] AND dd.[Dealer_Region] = s.[Dealer_Region]
);



-- Update Customer Dimension
INSERT INTO Customer_dim (Customer_Name, Gender, Annual_Income)
SELECT DISTINCT
    s.[Customer Name],
    s.Gender,
    s.[Annual Income]
FROM
    staging s
WHERE NOT EXISTS (
    SELECT 1
    FROM Customer_dim cd
    WHERE cd.Customer_Name = s.[Customer Name] AND cd.Annual_Income = s.[Annual Income]
);

-- Update Date Dimension
INSERT INTO Date_dim (label_date)
SELECT DISTINCT
    s.Date
FROM
    staging s
WHERE NOT EXISTS (
    SELECT 1
    FROM Date_Dim dd
    WHERE dd.label_date = s.Date
);



  -- Update CarSalesFact Table
INSERT INTO CarSalesFact
SELECT [Date_dim].DateId AS [Date], 
[Car_dim].CarId AS [Car], 
[Customer_dim].CustomerId AS [Customer],
[Dealer_dim].DealerId AS [Dealer],
[staging].[Phone]
FROM staging
INNER JOIN [Date_dim] on [staging].[Date] = [Date_dim].[label_date]
INNER JOIN [Car_dim] 
on [staging].[Model] = [Car_dim].[Model] AND [staging].[Engine] = [Car_dim].[Engine] AND [staging].[Transmission] = [Car_dim].[Transmission] 
AND [staging].[Color] = [Car_dim].[Color] AND [staging].[Price] = [Car_dim].[Price] AND [staging].[Body Style] = [Car_dim].[Body_Style] 
AND [staging].[Company] = [Car_dim].[Company]
INNER JOIN [Customer_dim] on [staging].[Customer Name] = [Customer_dim].[Customer_Name]	AND [staging].[Gender] = [Customer_dim].[Gender] 
AND [staging].[Annual Income] = [Customer_dim].[Annual_Income]
INNER JOIN [Dealer_dim] on [staging].[Dealer_Name] = [Dealer_dim].[Dealer_Name] AND [staging].[Dealer_Region] = [Dealer_dim].[Dealer_Region] 
AND [staging].[Dealer_No] = [Dealer_dim].[DealerNo]
WHERE NOT EXISTS (
    SELECT 1
    FROM CarSalesFact csf
    WHERE [Date_dim].DateId = csf.[Date]
      AND [Car_dim].CarId = csf.[Car]
      AND [Customer_dim].CustomerId = csf.[Customer]
      AND [Dealer_dim].DealerId = csf.[Dealer]
      AND [staging].[Phone] = csf.[Phone]
);

TRUNCATE TABLE [CarSales].[dbo].[staging];
TRUNCATE TABLE Date_dim;
TRUNCATE TABLE Customer_dim;
TRUNCATE TABLE Dealer_dim;
TRUNCATE TABLE Car_dim;