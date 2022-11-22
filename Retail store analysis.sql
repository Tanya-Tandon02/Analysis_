create database Retail

-- DATA PREPARATION AND UNDERSTANDING--

--Q1 begins--
select count(*)[Total_Rows] from Customer
select count(*) [Total_Rows] from prod_cat_info
select count(*) [Total_Rows] from [Transaction]

--Q1 end--

--Q2 begins--
select total_amt from [Transaction]
where total_amt like '-%'

--Q2 end--

--Q3 begin--
select convert(date,tran_date,105) from [Transaction]
select convert(date,DOB,105) from customer

--Q3 end--

--Q4 begin--
select DATEDIFF(DAY, min(convert(date,tran_date,105)), max(convert(date,tran_date,105)))[Days], 
 DATEDIFF(MONTH, min(convert(date,tran_date,105)), max(convert(date,tran_date,105)))[Month],
 DATEDIFF(YEAR, min(convert(date,tran_date,105)), max(convert(date,tran_date,105)))[Year]  
from [Transaction]

--Q4 end--

--Q5 begins--
select prod_cat from prod_cat_info
where prod_subcat = 'DIY'

--Q5 end--


--DATA ANALYSIS--

--Q1 begins--
select* from [Transaction]
select top 1 Store_type, COUNT(transaction_id)[COUNT_OF_TRANSACTION]  from [Transaction]
group by Store_type
order by COUNT(transaction_id) desc

--Q1 end--

--Q2 begin--
select gender, count(gender)[COUNT_OF_GENDER] from customer
where Gender in ('M','F')
group by Gender

--Q2 end--

--Q3 begins--
select top 1 city_code, count(customer_id)[Number_of_customers] from customer
group by city_code
order by count(customer_id) desc

--Q3 end--

--Q4 begins--
select prod_subcat, count(prod_subcat)[Number_of_sub-category] from prod_cat_info
where prod_cat = 'Books'
group by prod_subcat
order by count(prod_subcat)

--Q4 end--

--Q5 begin--
select* from [Transaction]
select top 1 Qty, COUNT( Qty)[Count] from [Transaction]
group by Qty
order by sum(Qty) desc

--Q5 end--

--Q6 begins--
select* from [transaction]
select SUM(total_amt) from [Transaction] T1 
inner join prod_cat_info T2 on T1.prod_cat_code = T2.prod_cat_code and prod_sub_cat_code= prod_sub_cat_code
where prod_cat in ('Books','Electronics')

--Q6 end--

--Q7 begins--
select  count(customer_id)[Count of customer] from customer
where customer_Id in (
select  cust_id from [Transaction]T1
inner join customer T2 on T1.cust_id=T2.customer_Id
where total_amt not like '-%'
group by cust_id
having COUNT(transaction_id) > 10)

--Q7 end--

--Q8 begin--
select SUM(total_amt)[Revenue] from [Transaction] T1 
inner join prod_cat_info T2 on T1.prod_cat_code=T2.prod_cat_code and prod_sub_cat_code=prod_sub_cat_code
where prod_cat in ('electronics','Clothing') and Store_type = 'Flagship store'

--Q8 end--

--Q9 begin--
select prod_subcat, SUM(TOTAL_AMT) [Revenue]
from [Transaction]t1
left join customer t2 on t1.CUST_ID=t2.CUSTOMER_ID
left join prod_cat_info t3 ON t3.prod_sub_cat_code= t1.prod_subcat_code AND t3.prod_cat_code=t1.prod_cat_code
where t3.prod_cat_code ='3' AND GENDER = 'M'
group by prod_sub_cat_code,prod_subcat

--Q9 end--

--Q10 begin--
select top 5 
prod_subcat, (SUM(total_amt)/(select SUM(TOTAL_AMT) from [Transaction]))*100 [PERCANTAGE_OF_SALES], 
(COUNT(case when Qty< 0 then Qty else null end)/SUM(Qty))*100 [PERCENTAGE_OF_RETURN]
FROM [TRANSACTION]T1
inner join prod_cat_info T2 on T1.prod_cat_code = T2.prod_cat_code and prod_sub_cat_code= prod_sub_cat_code
group by prod_subcat
order by sum(total_amt)desc

--Q10 end--

--Q11 begin--
SELECT CUST_ID,SUM(TOTAL_AMT) [REVENUE] FROM [TRANSACTION]
WHERE CUST_ID IN (SELECT customer_Id FROM CUSTOMER
  WHERE DATEDIFF(YEAR,CONVERT(DATE,DOB,103),GETDATE()) BETWEEN 25 AND 35)
  AND CONVERT(DATE,tran_date,103) BETWEEN DATEADD(DAY,-30,(SELECT MAX(CONVERT(DATE,tran_date,103)) FROM [Transaction]))
  AND (SELECT MAX(CONVERT(DATE,tran_date,103)) FROM [TRANSACTION])
GROUP BY CUST_ID

--Q11 end--

--Q12 begins--

select top 1 prod_cat, SUM(TOTAL_AMT)[Returns] from [Transaction] T1
inner join prod_cat_info T2 on T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
where TOTAL_AMT < 0 AND 
CONVERT(date, tran_date, 103) BETWEEN DATEADD(MONTH,-3,(SELECT MAX(CONVERT(DATE,tran_date,103)) FROM [Transaction])) AND (SELECT MAX(CONVERT(DATE,tran_date,103)) FROM [Transaction])
GROUP BY prod_cat
ORDER BY sum(total_amt) DESC

--Q12 end--

--Q13 begins--

select Store_type, SUM(total_amt) [TOTAL_SALES], SUM(Qty) [TOTAl_QTY]
FROM [Transaction]
group by Store_type
having sum(total_amt) >=ALL (select SUM(total_amt) FROM [Transaction]
group by Store_type)
and SUM(Qty) >=ALL (select SUM(Qty) from [Transaction]
group by store_type)
 
--Q13 end--

--Q14 begin--
select prod_cat, AVG(total_amt) [AVERAGE]
from [Transaction]T1
inner join prod_cat_info T2 on T1.prod_cat_code=T2.prod_cat_code and prod_sub_cat_code=prod_subcat_code
group by prod_cat
having AVG(total_amt)> (select AVG(total_amt) FROM [Transaction])

--Q14 end--

--Q15 begin--
SELECT PROD_CAT, PROD_SUBCAT, AVG(TOTAL_AMT) AS AVERAGE_REV, SUM(TOTAL_AMT) AS REVENUE
FROM [Transaction]T3
INNER JOIN prod_cat_info T4 ON T3.prod_cat_code=T4.prod_cat_code and prod_sub_cat_code=prod_sub_cat_code
WHERE PROD_CAT IN
(SELECT TOP 5 PROD_CAT from [Transaction]T1
inner join prod_cat_info T2 on T1.prod_cat_code= t2.prod_cat_code and prod_sub_cat_code = prod_sub_cat_code
group by prod_cat
ORDER by SUM(Qty) DESC
)
group by prod_cat,prod_subcat

--Q15 end--
--CASE STUDY END---