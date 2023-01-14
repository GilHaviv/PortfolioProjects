/*
Mexico Toy sales Data exploration
Skills used: Joins, CTE, Aggregate Functions, Windows functions
*/
use Toys

select * from products
select * from stores
select * from sales
select * from inventory

------------------------------------------
-------------DATA EXPLORATION-------------
------------------------------------------
-----------------products-----------------

--Looking at Num Of Products for each Products Category
select products.Product_Category, count(product_id) as NumOfProducts
from products
group by Product_Category
order by 2 desc

------------------------------------------
--Looking at Products and their prices
select products.Product_Name,products.Product_Price
from products
order by 2 desc

------------------------------------------
--Looking at Products and their Cost
select products.Product_Name,products.Product_Cost
from products
order by 2 desc

------------------------------------------
--Calculating the Net Income for each product
select products.Product_Name,products.Product_Price,products.Product_Cost, sum(Product_Price-Product_Cost) as NetIncome
from products
Group by Product_Name,products.Product_Price,products.Product_Cost
order by 4 desc

------------------------------------------
--Calculating the Net Income for each product category
select products.Product_Category, sum((products.Product_Price*sales.Units)-(products.Product_Cost*sales.Units)) as NetIncome
from products
join sales
on products.Product_ID=sales.Product_ID
Group by products.Product_Category
order by 2 desc

-----------------stores-------------------
------------------------------------------
--Looking at stores by City
select stores.store_name,stores.Store_City
from stores
order by 2

------------------------------------------
--Looking at number of stores by City
select stores.Store_City,count(stores.Store_ID) as NumOfStores
from stores
group by Store_City
order by 2 desc

------------------------------------------
--Looking at number of stores by Location
select stores.Store_Location,count(stores.Store_ID) as NumOfStores
from stores
group by Store_Location
order by 2 desc

------------------------------------------
--Looking at NetIncome by Store Location
select stores.Store_Location, sum((products.Product_Price*sales.Units)-(products.Product_Cost*sales.Units)) as NetIncome
from stores
join sales
on stores.Store_ID=sales.Store_ID
left join products
on sales.Product_ID=products.Product_ID
Group by stores.Store_Location
order by 2 desc

------------------------------------------
--Checking How many years the store is open
select stores.Store_Name,Store_Open_Date, DATEDIFF(year, Store_Open_Date, GETDATE()) AS NumOfYears
from stores
order by 2 

-----------------sales--------------------
------------------------------------------
--Looking at Top5 stores By sales
select top 5 Store_Name,count(Sale_ID) as NumOfSales
from sales
join stores
on sales.Store_ID=stores.Store_ID
group by Store_Name
order by 2 desc

------------------------------------------
--Looking at stores by sales and net income using dense_rank
select
	stores.Store_Name,
	stores.Store_City,
	stores.Store_Open_Date,
	count(sale_id) as numOfSales,
	sum((products.Product_Price*sales.Units)-(products.Product_Cost*sales.Units)) as NetIncome,
	DENSE_RANK()OVER(ORDER BY count(sale_id) desc) as numOfSales_dense_rank,
	DENSE_RANK()OVER(ORDER BY sum((products.Product_Price*sales.Units)-(products.Product_Cost*sales.Units)) desc) as NetIncome_dense_rank
from stores
join sales
on stores.Store_ID=sales.Store_ID
join products
on sales.Product_ID=products.Product_ID
group by
	stores.Store_Name,
	stores.Store_City,
	stores.Store_Open_Date

------------------------------------------
-----------------Inventory----------------
--Checking the potential_net_income from the inventory
with "cte" as (
select distinct inventory.Product_ID,products.Product_Name,products.Product_Cost,products.Product_Price,sum(inventory.stock_on_hand) as stock_on_hand
from inventory
join products
on inventory.Product_ID=products.Product_ID
group by inventory.Product_ID,products.Product_Name,products.Product_Cost,products.Product_Price
)
select *,sum((Product_Price*stock_on_hand)-(Product_Cost*stock_on_hand)) as potential_net_income
from cte
group by Product_ID,Product_Name,Product_Cost,Product_Price,stock_on_hand
order by 6 desc

------------------------------------------
--Looking at The messing products for each store_id  
select Store_id,products.Product_Name
from inventory
join products
on inventory.Product_ID=products.Product_ID
where inventory.Stock_On_Hand = '0'
order by 1
------------------------------------------
--Looking at The number Of Missing Products
select products.Product_Name ,count(inventory.Product_ID) as numberOfMissingProducts
from products
join inventory
on products.Product_ID=inventory.Product_ID
where inventory.Stock_On_Hand = '0'
group by Product_Name
order by 2 desc 

------------------------------------------
--Generate a dataset
select
	sales.Sale_ID,
	sales.Date,
	sales.Store_ID,
	sales.Product_ID,
	sales.Units,
	products.Product_Name,
	products.Product_Category,
	products.Product_Cost,
	products.Product_Price,
	sum(products.Product_Price*sales.Units) as revenue,
	sum((products.Product_Price*sales.Units)-(products.Product_Cost*sales.Units)) as NetIncome,
	stores.Store_Name,
	stores.Store_City,
	stores.Store_Location,
	stores.Store_Open_Date
from sales
join products
on sales.Product_ID=products.Product_ID
join stores
on sales.Store_ID=stores.Store_ID
group by
	sales.Sale_ID,
	sales.Date,
	sales.Store_ID,
	sales.Product_ID,
	sales.Units,
	products.Product_Name,
	products.Product_Category,
	products.Product_Cost,
	products.Product_Price,
	stores.Store_Name,
	stores.Store_City,
	stores.Store_Location,
	stores.Store_Open_Date



