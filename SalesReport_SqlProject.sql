
--This is a 2022 sales report of an Industrial Cable company using SQL scripts to analyse the data. There are two sets of table namely "Recline"
  --AND "Copper". Each table is analysed seperately and later joined together using union and substrings. 
----------------------------------------------------------------------------------------------------------------------------------------------

	Select * 
	From Recline

	--GALAXY RECLINE MONTHLY SALES TREND
	Select Month(Date) Month,Size,Sum(Price_naira) Sales 
	From Recline
		Group by Month(Date),Size
		order by 1

	Select  DatePart(MONTH,Date) Month,Sum(Price_naira) Sales
	From Recline
		Group by DatePart(MONTH,Date)
	
	--SALES BY SIZE
	Select Coalesce(Convert(nvarchar, Size), 'Subtotal') As Size, Sum(Coils) UnitSold,Sum(Price_Naira) SumPrice
	From Recline
		Group by Rollup(Size)
		ORDER BY 1 Asc

	--RANKING OVERALL RECLINE CUSTOMERS
	Select Coalesce(Customer_Name, 'SubTotal') Customer_Name, Sum(Coils) Coils,Sum(Price_Naira) SumPrice
	From Recline
	Group by Rollup(Customer_Name)
		ORDER BY 3 ASC

	--RANKING 16MM RECLINE CUSTOMERS
	Select Customer_Name, Sum(Price_Naira) SumPrice
	From Recline
	Where Size = 16
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 25MM RECLINE CUSTOMERS
	Select Customer_Name, Sum(Price_Naira) SumPrice
	From Recline
	Where Size = 25
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 35MM RECLINE CUSTOMERS
	Select Customer_Name, Sum(Price_Naira) SumPrice
	From Recline
	Where Size = 35
	Group by Customer_Name
		ORDER BY 2 DESC

	
	--RANKING 50MM RECLINE CUSTOMERS
	Select Customer_Name, Sum(Price_Naira) SumPrice
	From Recline
	Where Size = 50
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 70MM RECLINE CUSTOMERS
	Select Customer_Name, Sum(Price_Naira) SumPrice
	From Recline
	Where Size = 70
	Group by Customer_Name
		ORDER BY 2 DESC

	--SALES BY LOCATION
	Select Location, Sum(Price_Naira) SumPrice
	From Recline
	Group by Location
		ORDER BY 2 DESC

-------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
	-- COPPER CABLES SALES REPORT 2022

	Select * 
	From Copper

	--COPPER MONTHLY SALES 

	--Sum of Copper Annual Sales 
	Select  DatePart(YEAR,Date) Month,Sum(Price_naira) Sales
	From Copper
	Group by YEAR(Date)

	--Breakdown of units sold per sizes monthly
	Select Month(Date) Month, Size,Sum(Drum)  UnitSold,Sum(Price_naira) Price 
	From Copper
		Group by Rollup (Month(Date)),Size
		
	
	
	--SHOWING SALES BY SIZE IN SUM TOTAL AND PERCENTAGE
	Select Coalesce(Convert(nvarchar (255),Size), 'Subtotal') Size, Sum (Drum) Drum,Sum(Price_Naira) SumPrice,
		Sum(Price_Naira) / 586108350 * 100 AS TotalSalesPercentage
	From Copper
		Group by Rollup(Size)
		ORDER BY 3 ASC

	--RANKING OVERALL COPPER CUSTOMERS
	Select Customer_Name, Sum(Drum) Drums,Sum(Price_Naira) SumPrice
	From Copper
	Group by Rollup(Customer_Name)
		ORDER BY 3 DESC

	-- REVENUE BY COPPER BRAND
	Select Coalesce(BRAND, 'SubTotal'), Sum(Drum) Drums,Sum(Price_Naira) SumPrice,
		Sum(Price_Naira) / 586108350 * 100 AS TotalSalesPercentage
	From Copper
	Group by Rollup(BRAND)
		ORDER BY 3 ASC


	--SALES BY LOCATION
	Select Coalesce(Location, 'SubTotal') Location, Sum(Price_Naira) SumPrice, 
	Sum(Price_Naira) / 586108350 * 100 AS TotalSalesPercentage
	From Copper
	Group by Rollup(Location)
		ORDER BY 2 
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- OVERALL RANKING CUSTOMERS FOR COPPER AND RECLINE 2022

	SELECT
    Customer_name, 
    SUM(Price_Naira) AS Total_Price_Naira
FROM
    (SELECT customer_name, Price_Naira FROM Recline
        UNION ALL
        SELECT customer_name, Price_Naira FROM Copper
    ) CombinedTable
Group By rollup
    (customer_name)
	Order by 2 

--While trying to show the sales by location, I noticed that one location was given tow different names "Idumota" and "Lagos Island" in  
  --Copper TableSo I merged them together and chose "Idumota" as the name.

	Select Location,
	Case 
	When Location = 'Lagos Island' Then 'Idumota'
	Else Location  
	End As Changedname
	From Copper

Update Copper
	Set Location = Case 
			When Location = 'Lagos Island' Then 'Idumota'
			Else Location  
			End 
			From Copper


SELECT
    Coalesce(Location, 'SubTotal') Location,
    SUM(Price_Naira) AS Total_Price_Naira
FROM
    (SELECT Location, Price_Naira FROM Recline
        UNION ALL
        SELECT Location, Price_Naira FROM Copper
    ) CombinedTable
Group By Rollup
    (Location)
	Order by 1 


	SELECT
    Month(Date) Month,SUM(Price_Naira) AS Total_Price_Naira
FROM
    (SELECT Date, Price_Naira FROM Recline
        UNION ALL
        SELECT Date, Price_Naira FROM Copper
    ) CombinedTable
Group By Rollup
   (Month(Date))
	Order by 1 

