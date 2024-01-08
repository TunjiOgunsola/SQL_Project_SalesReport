
--This is a 2022 sales report of an Industrial Cable company using SQL scripts to analyse the data. There are two sets of table namely "Recline"
  --AND "Copper". Each table is analysed seperately and later joined together using union and substrings. 
----------------------------------------------------------------------------------------------------------------------------------------------

	Select * 
	From Recline

	--GALAXY RECLINE MONTHLY SALES TREND.
	--This shows the June has the highest revenue with revenue of N122.2M, cloesly followed by December and May with 121.3M and 86.8M respectively.	
	Select Month(Date) Month,Sum(Price) Revenue 
	From Recline
		Group by Month(Date)
		order by 2 DESC
-- Option 2
	Select  DatePart(MONTH,Date) Month,Sum(Price_naira) Revenue
	From Recline
		Group by DatePart(MONTH,Date)
	
	--SALES BY SIZE
	-- This depict that 16mm has the highest revenue with a sum of N349.1M from 696 units sold'	
	Select Coalesce(Convert(nvarchar, Size), 'Subtotal') As Size, Sum(Coils) UnitSold,Sum(Price_Naira) SumPrice
	From Recline
		Group by Rollup(Size)
		ORDER BY 3 Desc

	--RANKING OVERALL RECLINE CUSTOMERS
	-- This shows that Edwin is the highest rank customer with a total of N153M followed by Ndubuisi with N152M. 	
	Select Coalesce(Customer_Name, 'SubTotal') Customer_Name, Sum(Coils) Coils,Sum(Price) SumPrice
	From Recline
	Group by Rollup(Customer_Name)
		ORDER BY 3 DESC
		
--The cables come in different sizes, so it is necessary to categorize customers based on the sizes they most frequently purchase
		
	--RANKING 16MM RECLINE CUSTOMERS
	-- Edwin bought the most coils of 16mm (124), followed by Dennis and Ndu-favoured (115) each. 	
	Select Customer_Name, Sum(Price) SumPrice
	From Recline
	Where Size = 16
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 25MM RECLINE CUSTOMERS
	-- At the top is Dennis, who ordered 56 coils; following him is Chimaco with 41 coils, and then Sobitec with 34 coils.	
	Select Customer_Name, Sum(Coils) as Units,Sum(Price) SumPrice
	From Recline
	Where Size = 25
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 35MM RECLINE CUSTOMERS
	-- Ndufdavoured ordered 72 coils, closely followed by Edwin with 70 coils and Sobitec with 42 coils.	
	Select Customer_Name, Sum(Coils) as Units,Sum(Price) SumPrice
	From Recline
	Where Size = 35
	Group by Customer_Name
		ORDER BY 2 DESC

	
	--RANKING 50MM RECLINE CUSTOMERS
	--Edwin ordered 17 coils, closely followed by Ndufdavoured and Sobitec with 14 and 13 coils respectively.	
	Select Customer_Name, Sum(Coils) as Units, Sum(Price) SumPrice
	From Recline
	Where Size = 50
	Group by Customer_Name
		ORDER BY 2 DESC

	--RANKING 70MM RECLINE CUSTOMERS
	-- Ndufdavoured ordered 21 coils,  followed by Edwin with 17 coils and Sobitec in distant third with 5 coils.	
	Select Customer_Name, Sum(Coils) as Units, Sum(Price) SumPrice
	From Recline
	Where Size = 70
	Group by Customer_Name
		ORDER BY 2 DESC

	--SALES BY LOCATION
	-- Alaba market has the highest reclines sales with 758.6M, followed by Ipaja and Idumota with 34M and 33M respectively. 	
	Select Location, Sum(Coils) as Units, Sum(Price) SumPrice
	From Recline
	Group by Location
		ORDER BY 2 DESC

-------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
	-- COPPER CABLES SALES REPORT 2022

	Select * 
	From Copper

	--Sum of Copper Annual Sales 
	-- The total revenue genrated from copper is N586.1M for the year 2022.	
	Select  DatePart(YEAR,Date) Year,Sum(Price) Revenue
	From Copper
	Group by YEAR(Date)

	--COPPER MONTHLY SALES
	-- February has the highest sales with N131.7M followed by January and June with N95.9M and N77.2M respectively. 	
	Select (Month(Date)) Month,Sum(Price) Revenue
	From Copper
		Group by  (Month(Date))
		order by 2 DESC	

	--Breakdown of units sold per sizes monthly
	Select Month(Date) Month, Size,Sum(Drum)  UnitSold,Sum(Price_naira) Price 
	From Copper
		Group by Rollup (Month(Date)),Size
		
	
	
	--SHOWING SALES BY SIZE IN SUM TOTAL AND PERCENTAGE
	Select Coalesce(Convert(nvarchar (255),Size), 'Subtotal') Size, Sum (Drum) Drum,Sum(Price) SumPrice,
		Sum(Price) * 1.0 / 586108350 * 100 AS TotalSalesPercentage
	From Copper
		Group by Rollup(Size)
		ORDER BY 3 ASC
--Using CTE 
With PerCTE
 (Size, Drum, SumPrice) AS
( Select Coalesce(Convert(nvarchar (255),Size), 'Subtotal') Size, Sum (Drum) Drum,Sum(Price) SumPrice
	From Copper
		Group by Rollup(Size))
		
	Select *,  SumPrice * 1.0 / 586108350 * 100
	From PerCTE
		
	--RANKING OVERALL COPPER CUSTOMERS
-- Ambrose top the list with 25 drums followed by MC Global with 21 drums and Richard in third with 15 drums.
	Select Customer_Name, Sum(Drum) Drums,Sum(Price) SumPrice
	From Copper
	Group by Rollup(Customer_Name)
		ORDER BY 3 DESC

	-- REVENUE BY COPPER BRAND
-- Afrigold generated about 58% of of the total revenue followed by Marino with 26% and Deltasil with 16%. 		
	Select Coalesce(BRAND, 'SubTotal'), Sum(Drum) Drums,Sum(Price) SumPrice,
		Sum(Price) * 1.0 / 586108350 * 100 AS TotalSalesPercentage
	From Copper
	Group by Rollup(BRAND)
		ORDER BY 3 ASC


	--SALES BY LOCATION
--Over 32% of the copper cables was sold at Lagos Island, followed by Alaba with 30% while Kano, Port Harcourt, Abuja, and Ipaja shared 28%.		
	Select Coalesce(Location, 'SubTotal') Location, Sum(Price_Naira) SumPrice, 
	Sum(Price_Naira) / 586108350 * 100 AS TotalSalesPercentage
	From Copper
	Group by Rollup(Location)
		ORDER BY 2 
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- OVERALL RANKING CUSTOMERS FOR COPPER AND RECLINE 2022
-- Edwin top the ranking with N161.3M, Ndufavoured N152.3M followed by Sobitec with N126.0M.
	SELECT
    Customer_name, 
    SUM(Price) AS Total_Price
FROM
    (SELECT customer_name, Price FROM Recline
        UNION ALL
        SELECT customer_name, Price FROM Copper
    ) CombinedTable
Group By rollup
    (customer_name)
	Order by 2 DESC

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
P.S --While trying to show the sales by location, I noticed that one location was given two different names "Idumota" and "Lagos Island" in  
  --  Copper Table So I merged them together and chose "Idumota" as the name.

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

-- GROSS RANKING LOCATION FOR RECLINE AND COPPER
SELECT
    Coalesce(Location, 'SubTotal') Location,
    SUM(Price_Naira) AS Total_Price
FROM
    (SELECT Location, Price_Naira FROM Recline
        UNION ALL
        SELECT Location, Price_Naira FROM Copper
    ) CombinedTable
Group By Rollup
    (Location)
	Order by 1 

-- GROSS RANKING BY MONTH FOR RECLINE AND COPPER
SELECT
    Month(Date) Month,SUM(Price) AS Total_Price
FROM
    (SELECT Date, Price FROM Recline
        UNION ALL
        SELECT Date, Price FROM Copper
    ) CombinedTable
Group By Rollup
   (Month(Date))
	Order by 1 


