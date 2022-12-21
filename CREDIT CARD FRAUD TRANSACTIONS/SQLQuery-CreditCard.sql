/*

Credit Card - Data exploration

Skills used: Joins, Aggregate Functions, Windows functions

*/

use CreditCard

--Credit card level information (CardNumber, CardFamily, Cust_ID) -482 card holders
select * from CardBase

--Transaction information done on credit cards (TransactionID, TransactionDate, CreditCardID, TransactionValue, TransactionSegment)
select * from TransactionBase

--Transaction marked as fraud (TransactionID FraudFlag)
select * from FraudBase

-- Customer information (CustID, Age, CustomerSegment, CustomerVintageGroup)--5674 Bank Customers
select * from CustomerBase

-----------------------------------------------------
--Age Distribution of all customers
select CustomerBase.Age, count(CustomerBase.Cust_ID)
from CustomerBase
group by CustomerBase.Age
order by 1

-------------------------------------------------------
--Credit Limit Distribution
select CardBase.Credit_Limit, count(CardBase.Cust_ID) as numOfCustomers
from CardBase
group by Credit_Limit

-------------------------------------------------------
--Checking If There is a duplicate ID
select Cust_ID, count(Cust_ID)
from CustomerBase
group by Cust_ID
order by 2 desc

-------------------------------------------------------
--Looking at all The Company Customers
select *
from CustomerBase
full join CardBase
on CustomerBase.Cust_ID=CardBase.Cust_ID

-------------------------------------------------------
-- How Many Customers Have More Than 1 Card
SELECT CardBase.Cust_ID, COUNT(*) as NumberOfCards
FROM CardBase
GROUP BY Cust_ID
HAVING COUNT(*) > 1;

-------------------------------------------------------
--Number of Customers By Card Family
select CardBase.Card_Family,count(CardBase.Card_Number) as numOfCustomers
from CardBase
group by Card_Family
order by numOfCustomers desc

-------------------------------------------------------
--Looking at Top 10 Transactions
select Top 10 
	TransactionBase.Transaction_ID,
	TransactionBase.Transaction_Date,
	TransactionBase.Transaction_Value, 
	CardBase.Cust_ID,
	CardBase.Credit_Limit
from TransactionBase
join CardBase
on Credit_Card_ID=Card_Number
left join FraudBase
on TransactionBase.Transaction_ID = FraudBase.Transaction_ID
where FraudBase.Fraud_Flag is null
group by 
	TransactionBase.Transaction_ID, 
	TransactionBase.Transaction_Date,
	TransactionBase.Transaction_Value, 
	CardBase.Cust_ID,
	CardBase.Credit_Limit,
	FraudBase.Fraud_Flag
order by Transaction_Value desc
-------------------------------------------------------
--Fraud Transaction Per Segmnet
select 
	TransactionBase.Transaction_Segment,
	count(TransactionBase.Transaction_ID) as TotalTransactions,
	count(FraudBase.fraud_flag) as numOfFraudTransactions
from TransactionBase
left join FraudBase
on TransactionBase.Transaction_ID=FraudBase.Transaction_ID
group by Transaction_Segment
order by numOfFraudTransactions desc

-------------------------------------------------------
--Fraud Transactions Per Customer Segmnet
select 
	 CustomerBase.Customer_Segment,
	count(TransactionBase.Transaction_ID) as TotalTransactions,
	count(FraudBase.fraud_flag) as numOfFraudTransactions
from TransactionBase
left join FraudBase
on TransactionBase.Transaction_ID=FraudBase.Transaction_ID
left join CardBase
on TransactionBase.Credit_Card_ID = CardBase.Card_Number
join CustomerBase
on CardBase.Cust_ID = CustomerBase.Cust_ID
group by CustomerBase.Customer_Segment
order by numOfFraudTransactions desc

-------------------------------------------------------
--Fraud Transactions by Customer Vintage group
select 
	 CustomerBase.Customer_Vintage_Group,
	count(TransactionBase.Transaction_ID) as TotalTransactions,
	count(FraudBase.fraud_flag) as numOfFraudTransactions
from TransactionBase
left join FraudBase
on TransactionBase.Transaction_ID=FraudBase.Transaction_ID
left join CardBase
on TransactionBase.Credit_Card_ID = CardBase.Card_Number
join CustomerBase
on CardBase.Cust_ID = CustomerBase.Cust_ID
group by CustomerBase.Customer_Vintage_Group
order by numOfFraudTransactions desc

-------------------------------------------------------
--Looking at Fraud Transactions Value Distribution
select TransactionBase.Transaction_ID,Transaction_Date,Transaction_Value
from TransactionBase
join FraudBase
on TransactionBase.Transaction_ID = FraudBase.Transaction_ID
group by TransactionBase.Transaction_ID,Transaction_Date,TransactionBase.Transaction_Value
order by Transaction_Value desc

-------------------------------------------------------
--Looking at all Customers who have Fraud Transactions 
select Cust_ID, count(Cust_ID) as NumberOfFraudTransactions
from FraudBase
join TransactionBase
on FraudBase.Transaction_ID = TransactionBase.Transaction_ID
join CardBase
on Credit_Card_ID=Card_Number
group by Cust_ID
order by 2 desc
 
 -------------------------------------------------------
 --Sum Of Fraud Transactions Value
 select sum(transaction_value)
 from TransactionBase
 where Transaction_ID in (select Transaction_ID from FraudBase)

-------------------------------------------------------
--All transactions info
select
	TransactionBase.Transaction_ID,
	TransactionBase.Transaction_Date,
	TransactionBase.Credit_Card_ID,
	TransactionBase.Transaction_Value,
	TransactionBase.Transaction_Segment,
	FraudBase.Fraud_Flag,
	CardBase.Card_Family,
	CardBase.Credit_Limit,
	CardBase.Cust_ID,
	CustomerBase.Age,
	CustomerBase.Customer_Segment,
	CustomerBase.Customer_Vintage_Group
from TransactionBase
left join FraudBase
on TransactionBase.Transaction_ID=FraudBase.Transaction_ID
join CardBase
on TransactionBase.Credit_Card_ID = CardBase.Card_Number
join CustomerBase
on CardBase.Cust_ID = CustomerBase.Cust_ID
group by
	TransactionBase.Transaction_ID,
	TransactionBase.Transaction_Date,
	TransactionBase.Credit_Card_ID,
	TransactionBase.Transaction_Value,
	TransactionBase.Transaction_Segment,
	FraudBase.Fraud_Flag,
	CardBase.Card_Family,
	CardBase.Credit_Limit,
	CardBase.Cust_ID,
	CustomerBase.Age,
	CustomerBase.Customer_Segment,
	CustomerBase.Customer_Vintage_Group;