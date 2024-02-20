USE OLIST;

 SELECT 
    CASE 
        WHEN DAYNAME(order_purchase_timestamp) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Weekday_Weekend
FROM 
    olist.olist_orders_dataset;
    
    
# created weekday/weekend column 
alter table olist.olist_orders_dataset 
add   `Weekday/Weekend` varchar(50);

# adding data to weekday/weekend 
set  sql_safe_updates=0;
update olist.olist_orders_dataset 
set `Weekday/Weekend` = 
 
   CASE 
        WHEN DAYNAME(order_purchase_timestamp) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END ;
    


select od.`Weekday/Weekend` as weekday_weekend, sum(pay.payment_value) as payment from olist.olist_orders_dataset od 
left join olist.olist_order_payments_dataset pay 
on od.order_id=pay.order_id group by weekday_weekend;

# 1> Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics


select  `Weekday/Weekend`,sum(payment_value) as Payment,sum(payment_value)/(select sum(payment_value)
 as pay from olist.olist_order_payments_dataset)*100
as "%age"
 from olist.olist_orders_dataset od join 
olist.olist_order_payments_dataset pa on od.order_id=pa.order_id group by `Weekday/Weekend`;

#---------------------------------------------------------------------------------------------------------------

# 2> Number of Orders with review score 5 and payment type as credit card.
use olist;
rename table olist.order_reviews to olist_order_reviews_dataset;


select od.review_score,pa.payment_type,count(od.order_id) as Count_Of_Orders 
from olist.olist_order_reviews_dataset od inner join 
olist.olist_order_payments_dataset pa on od.order_id=pa.order_id  where od.review_score=5 and pa.payment_type="credit_card"
 group by od.review_score,pa.payment_type;
 
 #--------------------------------------------------------------------------------------------------------
 
 
 # 3> Average number of days taken for order_delivered_customer_date for pet_shop
 select * from olist.olist_orders_dataset;
select * from olist.olist_products_dataset;

# lets us add a new column in order named days diff on the basis of order_purchase_timestamp n order_delivered_customer_date 
alter table olist.olist_orders_dataset 
add   Day_Diff integer; 


select 
 -datediff(order_purchase_timestamp,order_delivered_customer_date) as day_diff
from olist.olist_orders_dataset;


select order_delivered_customer_date from olist.olist_orders_dataset where order_delivered_customer_date ="";
select * from olist.olist_orders_dataset;


# deleted records where there was empty for order_delivered_customer_date

delete from olist.olist_orders_dataset where order_delivered_customer_date="";

set  sql_safe_updates=0;
update olist.olist_orders_dataset 
set Day_Diff = datediff(order_delivered_customer_date,order_purchase_timestamp);

select * from olist.olist_orders_dataset;
select * from olist.olist_order_items_dataset;
select * from olist.olist_products_dataset;

select pro.product_category_name,round(avg(od.Day_Diff),0) as Average_Days_Taken from olist.olist_orders_dataset od
join olist.olist_order_items_dataset oditems on od.order_id=oditems.order_id 
join olist.olist_products_dataset pro on oditems.product_id = pro.product_id where pro.product_category_name="pet_shop"
 group by pro.product_category_name;
 
 
 #------------------------------------------------------------------------------------------------------------------------
 
 # 4> Average price and payment values from customers of sao paulo city
 select * from olist.olist_customers_dataset;
 select * from olist.olist_order_payments_dataset;
 select * from olist.olist_order_items_dataset;
 select * from olist.olist_orders_dataset;
 
 select customer_city,avg(price) as Average_Price,avg(payment_value) as Average_Payment from
 olist.olist_customers_dataset cus 
 join olist.olist_orders_dataset od on od.customer_id=cus.customer_id 
 join olist.olist_order_items_dataset oditems on od.order_id=oditems.order_id 
 join olist.olist_order_payments_dataset pay on pay.order_id=oditems.order_id
 where customer_city="sao paulo"
 group by customer_city;
 
 #-------------------------------------------------------------------------------------------------------------------------
 
 # 5> Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
# creating daydiff bucket
# getting max of Day_Diff and min of Day_Diff
select max(Day_Diff),min(Day_Diff) from olist.olist_orders_dataset;
select * from olist.olist_orders_dataset;

# adding one more column DayDiff_Bucket

alter table olist.olist_orders_dataset 
add   DayDiff_Bucket varchar(50);
set  sql_safe_updates=0;
update olist.olist_orders_dataset 
set DayDiff_Bucket= 
case
 when Day_Diff between 0 and 39 then "0-39"
 when Day_Diff between 40 and 79 then "40-79"
 when Day_Diff between 80 and 119 then "80-119"
 when Day_Diff between 120 and 159 then "120-159"
 when Day_Diff between 160 and 199 then "160-199" 
 when Day_Diff between 200 and 239 then "200-239"
 else ""
 end;
 
select (DayDiff_Bucket), review_score,count(DayDiff_Bucket) from olist.olist_orders_dataset od join 
olist.olist_order_reviews_dataset re 
on od.order_id=re.order_id group by DayDiff_Bucket,review_score;
 
 select* from olist.olist_order_reviews_dataset;
 
 #--------------------------------------------------------------------------------------------------------------------------


 
 
 









 
  
    

















