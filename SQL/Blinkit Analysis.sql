---------------------------Blinkit Analysis---------------

use blinkitdb
select * from blinkit_data;


-----------DATA CLEANING---------------

select count(*) from blinkit_data;

Update blinkit_data
set Item_Fat_Content = 
case 
when Item_Fat_Content in ('LF', 'low fat' ) then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end

SELECT DISTINCT Item_Fat_Content FROM blinkit_data;

-----A. KPI's-------------------
--1.Total sales
select cast(sum(Sales)/1000000 As decimal(10,2)) as Total_Sales_Millions from blinkit_data;

--2.Average sales
select cast(avg(Sales) as decimal(10,0)) as Avg_Sales from blinkit_data

--3.Number of Items
 select count(*) as No_of_Items from blinkit_data
 
--4.Average Rating
 select cast(Avg(Rating) as decimal(10,2)) as Avg_Rating from blinkit_data


---- B. Total Sales by Fat Content:
SELECT Item_Fat_Content, CAST(SUM(Sales)as DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content

	
---C. Total Sales by Item Type
SELECT Item_Type, CAST(SUM(Sales)as  DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC



---D. Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--E. Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year



---F. Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


---G. Sales by Outlet Location
SELECT Outlet_Location_Type, CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC


---H. All Metrics by Outlet Type:
SELECT Outlet_Type, 
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

