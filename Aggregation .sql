-- aggregating pattern for measuring overall performance of the data
with sales_product AS(select s.Order_Number,
s.Order_Date,
s.Delivery_Date,
c.Country,
s.CustomerKey,
p.productKey,
s.quantity,
p.Unit_Price_USD,
p.product_Name,
p.Brand,
p.category,
s.Currency_Code,
ER.Exchange
from sales s
left join Products p
on s.ProductKey  = p.ProductKey
left join Customers c
on c.CustomerKEy = s.CustomerKey
left join Exchange_Rates as ER
on s.Currency_Code = ER.Currency and s.Order_Date = Er.Date
) 

 select country,category, Year(Order_Date) date ,sum(Quantity) total_quantity,
 count(Distinct Order_Number) as total_orders,
sum(Quantity * Unit_Price_USD * Exchange) as  total_revenue,
sum(Quantity * Unit_Price_USD * Exchange)/count(*) as AOV
from sales_product  
group by country, category,Year(Order_Date) , country
order by total_revenue desc
