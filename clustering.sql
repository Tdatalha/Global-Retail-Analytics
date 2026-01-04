--3 clustering customer segment
with customer_segment as (select c.Country,
year(s.Order_Date) as order_year,
sum(s.Quantity * p.Unit_Price_USD * Er.Exchange) as total_revenue,
count(s.Order_Number) as total_orders
 from sales s
left join Products p
on s.ProductKey = p.ProductKey
left join Exchange_Rates Er
on s.Currency_Code = Er.Currency and s.Order_Date = Er.Date
left join Customers c
on s.CustomerKey = c.CustomerKey
group by c.Country, year(s.Order_Date)
),
Growth_rate as (select Country,
total_revenue,
total_orders,
order_year,
round(LAG(total_revenue) over (partition by country order by order_year),2) previous ,
100.0*((total_revenue -LAG(total_revenue) over (partition by country order by order_year asc)) / LAG(total_revenue) over (partition by country order by order_year)) growth_rate
from customer_segment
)
select
*,
CASE
	when growth_rate is null then 'New market'
    WHEN growth_rate >= 30 THEN 'Explosive Growth'
    WHEN growth_rate >= 15 THEN 'Strong Growth'
    WHEN growth_rate >= 5 THEN 'Moderate Growth'
    WHEN growth_rate >= -5 AND growth_rate < 5 THEN 'Flat / Stable'
    WHEN growth_rate >= -15 THEN 'Mild Decline'
    WHEN growth_rate >= -30 THEN 'Significant Decline'
    ELSE 'Severe Decline / Loss'
END AS growth_segment,
Round(sum(total_revenue)over(partition by country order by order_year rows unbounded preceding),2) as cumulative_revenue
from Growth_rate
order by country,order_year