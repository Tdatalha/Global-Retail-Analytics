--2 funneling for online oreder

with funnel as (select s.Order_Number,
s.Order_Date,
s.productKey,
s.Delivery_Date,
s.Quantity * p.Unit_price_USD * er.Exchange as revenue,
case when s.storeKey = 0 then 'Online' 
when s.storeKey > 0 then 'offline' End as channel
from sales s
left join Stores as st
on s.StoreKey = st.StoreKey
left join Products p
on s.ProductKey  = p.ProductKey 
left join Exchange_Rates er
on s.Currency_Code = er.currency and s.Order_Date = er.Date
),

total_rev_orders as (select channel,
count(Order_Number) as total_orders,
sum(revenue) as total_revenue,
Avg(nullif(DATEDIFF (day, Order_Date,Delivery_Date),null)) as avg_delivery_days
from funnel
group by channel
)

select channel ,
total_orders,
total_revenue,
100.0*total_orders/sum(total_orders) over () as pct_orders,
100.0*total_revenue/sum(total_revenue) over () as pct_revenue,
avg_delivery_days

from total_rev_orders
