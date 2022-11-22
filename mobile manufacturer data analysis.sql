select* from DIM_CUSTOMER
select* from DIM_DATE
select* from DIM_LOCATION
select* from DIM_MANUFACTURER
select* from DIM_MODEL
select* from FACT_TRANSACTIONS

--Q1 begins--
select state, year(date)[Year] from FACT_TRANSACTIONS T1 inner join DIM_LOCATION T2 on T1.IDLocation= T2.IDLocation
where year(Date) between '2005' and getdate()

--Q1 end--

--Q2 begins--
select state from DIM_LOCATION T1
inner join FACT_TRANSACTIONS T2 on T1.IDLocation= T2.IDLocation
inner join  DIM_MODEL T3 ON T3.IDModel= T2.IDModel
inner join DIM_MANUFACTURER T4 ON T4.IDManufacturer= T3.IDManufacturer
where MANUFACTURER_NAME = 'Samsung'
group by STATE
order by SUM(QUANTITY) desc

--Q2 end--


---Q3 begins-- 
select state, zipcode,model_name, count(idcustomer) [Number of transaction]
 from DIM_LOCATION T1 inner join FACT_TRANSACTIONS T2 on T2.IDLocation= T1.IDLocation
 inner join dim_model T3 on T3.IDMODEL = T2.IDMODEL
 group by state,ZipCode,model_name

 --Q3 end--
 
 
 ---Q4 begin--
 select top 1 IDModel, TotalPrice from FACT_TRANSACTIONS
 order by TotalPrice asc

 --Q4 end--
 

 ----Q5 begin--
 select top 5 Manufacturer_Name, AVG(TotalPrice)[Avg_price], SUM(Quantity) [Sales_Quantity]
from FACT_TRANSACTIONS T1 left join DIM_MODEL T2 ON T2.IDModel= T1.IDModel
inner join  DIM_MANUFACTURER T3 on  T3.IDManufacturer=T2.IDManufacturer
group by Manufacturer_Name
order by Sales_Quantity desc
 
 --Q5 end--


 ---Q6 begins--
 select T1.IDCustomer,Customer_Name,AVG(totalprice) [Avg amount] from DIM_CUSTOMER T1
  inner join FACT_TRANSACTIONS T2 on T1.IDCustomer= T2.IDCustomer
 where year(date) = 2009
 group by T1.IDCustomer,Customer_Name
 having AVG(totalprice) > 500

 --Q6 end--


 --Q7 begins--

 select IdModel from (select IdModel, ROW_NUMBER() over (partition by YEAR([Date]) 
 order by Quantity DESC) [rank]
 from FACT_TRANSACTIONS
 where YEAR([Date]) in (2008, 2009, 2010))a
 where [rank] <= 5
group by IdModel
having COUNT(*) = 3

--Q7 end--

--Q8 begin--
select top 1 * from
(select top 2 manufacturer_name,sum(totalprice) [sales_2009] from fact_transactions T1
 left join dim_model T2 on T1.idmodel = T2.idmodel
 left join dim_manufacturer T3  on T3.idmanufacturer = T2.idmanufacturer
 where datepart(year,date)='2009' 
 group by manufacturer_name, quantity 
 order by  sum(totalprice ) desc) as a,
(select top 2 manufacturer_name,sum(totalprice)[sales_2010] from fact_transactions T1
 left join dim_model T2 on T1.idmodel = T2.idmodel
 left join dim_manufacturer T3  on T3.idmanufacturer = T2.idmanufacturer
 where datepart(year,date)='2010' 
 group by manufacturer_name,quantity
 order by  sum(totalprice )desc) b

 --Q8 end--

--Q9 begins--

select Manufacturer_Name, YEAR(Date) [YEAR] from DIM_MODEL T1
inner join DIM_MANUFACTURER T2 ON T1.IDMANUFACTURER= T2.IDMANUFACTURER
inner join FACT_TRANSACTIONS T3 ON T3.IDMODEL= T1.IDModel
where YEAR(DATE) = 2010 
except 
select Manufacturer_Name, YEAR(DATE) [YEAR] from DIM_MODEL T1
inner join DIM_MANUFACTURER T2 ON T1.IDMANUFACTURER= T2.IDMANUFACTURER
inner join FACT_TRANSACTIONS T3 ON T3.IDMODEL= T1.IDMODEL
where YEAR(DATE) = 2009

--Q9 end--

--Q10 begin--
select top 100 T1.Customer_Name, T1.Year, T1.Avg_Price,T1.Avg_Qty,
    CASE WHEN T2.Year IS NOT NULL
    THEN FORMAT(CONVERT(DECIMAL(8,2),(T1.Avg_Price-T2.Avg_Price))/CONVERT(DECIMAL(8,2),T2.Avg_Price),'p') ELSE NULL 
    END [YEARLY_%_CHANGE] FROM
 (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
  left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
  where t1.IDCustomer in (select top 10 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
  group by t2.Customer_Name, YEAR(t1.Date))T1
  left join
   (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
   left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
   where t1.IDCustomer in (select top 10 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
   group by t2.Customer_Name, YEAR(t1.Date))T2
   on T1.Customer_Name=T2.Customer_Name and T2.YEAR=T1.YEAR-1 

   --Q10 end--

   --CASE STUDY END--

  
