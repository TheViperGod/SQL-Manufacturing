--SQL Advance Case Study
select * from DIM_CUSTOMER
select * from FACT_TRANSACTIONS
select * from DIM_LOCATION
select * from DIM_DATE
select * from DIM_MODEL
select * from DIM_MANUFACTURER

--Q1--BEGIN 
	
	select IDCustomer, [State], YEAR(b.date) as Years
	from DIM_LOCATION A
	inner join FACT_TRANSACTIONS B
	on a.IDLocation = b.IDLocation
	where YEAR(b.Date) >= 2005

--Q1--END

--Q2--BEGIN
	
	select top 1[State], count(IDCustomer) as Phn_count
	from DIM_LOCATION A
	inner join FACT_TRANSACTIONS B
	on A.IDLocation = B.IDLocation
	left join DIM_MODEL C
	on B.IDModel = C.IDModel
	where Country = 'US' and IDManufacturer = '12'
	group by [State]

--Q2--END

--Q3--BEGIN      
	
	Select distinct [state],ZipCode, Model_Name, COUNT(IDCustomer) as Trans_count
	from DIM_LOCATION A
	inner join FACT_TRANSACTIONS B on A.IDLocation = B.IDLocation
	left join DIM_MODEL C on B.IDModel = C.IDModel
	group by [state], ZipCode, Model_Name

--Q3--END

--Q4--BEGIN

select top 1 Model_Name, Unit_price
from DIM_MODEL
order by Unit_price 

--Q4--END

--Q5--BEGIN

select top 5 Manufacturer_Name, Model_Name, AVG(unit_price) as Avg_price
from FACT_TRANSACTIONS A
inner join DIM_MODEL B on A.IDModel = B.IDModel
inner join DIM_MANUFACTURER C on B.IDManufacturer = C.IDManufacturer
Group by Manufacturer_Name, Model_Name
order by MAX(quantity), AVG(unit_price) Desc

--Q5--END

--Q6--BEGIN

select Customer_Name, AVG(TotalPrice) as Avg_Amt
from DIM_CUSTOMER A
inner join FACT_TRANSACTIONS B on A.IDCustomer = B.IDCustomer
where YEAR(Date) = '2009'
Group by Customer_Name
having AVG(TotalPrice) > 500


--Q6--END
	
--Q7--BEGIN  
	
	select * from  (SELECT
    Top 5 Model_Name
    From Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON D1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2008' 
    group by Model_Name, Quantity 
    Order by  SUM(Quantity ) DESC  
    intersect
Select Top 5 Model_Name 
    From Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON D1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2009' 
    group by Model_Name, Quantity 
    Order by  SUM(Quantity ) DESC 
INTERSECT
Select Top 5 Model_Name
    From Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON D1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2010' 
    group by Model_Name, Quantity 
    Order by  SUM(Quantity ) DESC) as A


--Q7--END	
--Q8--BEGIN

WITH cte AS
(
SELECT Manufacturer_name, DATEPART(Year,date) as yr, sum(TotalPrice) as Sales,
DENSE_RANK() OVER (PARTITION BY DATEPART(Year,date) ORDER BY SUM(TotalPrice) DESC) AS Rank 
    FROM Fact_Transactions FT
    LEFT JOIN DIM_Model DM ON FT.IDModel = DM.IDModel
    LEFT JOIN DIM_MANUFACTURER MFC  ON MFC.IDManufacturer = DM.IDManufacturer
    group by Manufacturer_name,DATEPART(Year,date) 
),
cte2 AS(
SELECT Manufacturer_Name, yr, Sales
FROM cte WHERE rank = 2
AND yr IN ('2009','2010')
)
SELECT c.Manufacturer_Name AS Manufacturer_Name_2009
,t.Manufacturer_Name AS Manufacturer_Name_2010
FROM cte2 AS c, cte2 AS t
WHERE c.yr < t.yr

--Q8--END
--Q9--BEGIN
	
	select Manufacturer_Name from FACT_TRANSACTIONS A
	inner join DIM_MODEL B on A.IDModel = B.IDModel
	inner join DIM_MANUFACTURER C on B.IDManufacturer = C.IDManufacturer
	where DATEPART(year,[Date]) = '2010'
	except
	select Manufacturer_Name from FACT_TRANSACTIONS A
	inner join DIM_MODEL B on A.IDModel = B.IDModel
	inner join DIM_MANUFACTURER C on B.IDManufacturer = C.IDManufacturer
	where DATEPART(year,[Date]) = '2009'

--Q9--END

--Q10--BEGIN
	
	Select Top 100 YEAR([date]) as Years, Customer_Name, TotalPrice, AVG(totalPrice) as Avg_spend, Avg(Quantity) as Avg_Qty,
	(TotalPrice/AVG(totalPrice))*100 as Percent_change
	From FACT_TRANSACTIONS A 
	inner join DIM_CUSTOMER B on A.IDCustomer = B.IDCustomer
	Group by [Date], Customer_Name,TotalPrice
	order by TotalPrice Desc
















--Q10--END
	