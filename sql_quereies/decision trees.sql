with revenue_by_country as (select c.country,
p.Product_Name,
p.Category,
s.Quantity * p.Unit_Price_USD * nullif(er.Exchange,0) as revenue
from sales s
left join Customers c
on s.CustomerKey = c.CustomerKey
left join products p
on p.ProductKey = s.ProductKey
left join Exchange_Rates er
on s.Currency_Code = er.Currency and s.Order_Date = er.Date
)

SELECT 
    Country,
    Category,
    SUM(revenue) AS total_revenue
FROM revenue_by_country
GROUP BY Country, Category
ORDER BY total_revenue DESC

