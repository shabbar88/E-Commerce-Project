# Olist Store Sales Analytics 💥
---
## Table of Contents:-
 - [Excel Dashboard Screenshot](#excel-dashboard-screenshot) 📷
 - [PowerBi Dahboard Screenshot](#powerbi-dashboard-screenshot) 📷
 - [Tableau Dashboard Screenshot](#tableau-dashboard-screenshot) 📷
 - [Project Overview](#project-overview) 🧑‍💻
 - [Data Sources](#data-sources) 📁
 - [Problem Statement](#problem-statement) ❓
 - [Tools](#Tools) 🛠️
 - [Data CLeaning](#data-cleaning) 🔨 
 - [Data Analysis](#data-analysis)  🧮
 - [Results](#results)  :suspect:
 - [Recommendation](#recommendation)  :basecamp:
 - [Project Files Location Links](#project-files-location-links)  📂
---
### Excel Dashboard Screenshot
![EXCEL DASHBOARD FINAL](https://github.com/shabbar88/E-Commerce-Project/assets/68353026/d026a014-4e69-46d1-9cc1-21ad7d8b845e)
---


## PowerBi Dashboard Screenshot
![POWERBI_DASHBOARD_SCREENSHOT_CURRENT](https://github.com/shabbar88/E-Commerce-Project/assets/68353026/f7ac4b32-14f0-4f0e-b1b4-b9342e573d13)


---
## Tableau Dashboard Screenshot
![e-comm-tableau-latest](https://github.com/shabbar88/E-Commerce-Project/assets/68353026/a441de60-7140-4fce-8ad1-9a673fbd5127)



---


### **Project Overview**
---
This Data Analytics Project aims to provide insights into the sales performance of an e-commerce olist store over the last few years. By analyzing various aspect of Sales Data , we seek to identify trends, make data driven recommendation
and gain a deeper understanding of Companies Performance. In this Project I solved the various business related questions.
---

### Data Sources
Primary Dataset used for this project Analysis is Olist store data containing detailed information about the sales in the company.
[Olist Data](https://drive.google.com/drive/u/0/folders/1uyEM3rM_bb7ljbkOmVwD9Ytof-hBYjZr)

## **Problem Statement**


 * 1>Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
 * 2>Number of Orders with review score 5 and payment type as credit card.
 * 3>Average number of days taken for order_delivered_customer_date for pet_shop
 * 4>Average price and payment values from customers of sao paulo city
 * 5>Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
 * 6>Top 5 Product Category By Payment Value
 * 7>Bottom 5 Product Category By Payment Value
---
## Tools
 * Microsoft Excel
 * Microsoft PowerBi
 * Mysql
 * Tableau
---

 ## Data Cleaning
 
 ##Data Cleaning done on Power Query Editor on both Excel and PowerBi
 In the initial data preparation phase we performed the following tasks:
 * Data loading and inspection.
 * Handling missing values.
 * Data Cleaning and Formatting.
 * Removing Blank Rows.
---
## Data Analysis 
 🧑‍🔧 Include some code features worked with sql - 
 ``` sql
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
 
 
 #--------------------------------------------------------------------------------------------------------------
 
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
 
 #---------------------------------------------------------------------------------------------------------------
 
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
 
 
 ```
---
### Results
Analysis results are summarized as follows:-
  * 1> Payment on Weekdays is 11.91 million dollars (77.21%) and Payment on Weekends is 3.51 million dollars (22.79%).
  * 2> Number of Orders with review score 5 and payment type as credit is 44k.
  * 3> Average number of days taken for order_delivered_customer_date for pet_shop is 11 days
  * 4> Average price and payment values from customers of sao paulo are 107 dollar and 134 dollar.
  * 5> Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp):- Count of maximum number of review score is generated when (Day Diff Bucket) is 0-39. As the (Day Diff Bucket) increases count of review scores decreases. So we can infer that (Day Diff Bucket) is inversely proportional to count of review scores.
---

## Recommendation
Based on the analysis we recommend the following actions:-
  * 1> (Day Diff Bucket) should be 0-39 to provide customer satisfaction as maximum number of review score is genereated in this window only.
  * 2> Company should provide some sort of scheme for debit card customers in order to target the debit card customer to increase the sales.
---
## Project Files Location Links
 * E-Commerce Project.zip [Excel Files Here](https://drive.google.com/file/d/1w7Zxu1dSz9CZeqTtWzY_KDh2RpaQwlSE/view?usp=drive_link)
 * E-Commerce Data Analytics.pbix [PowerBi Files Here](https://drive.google.com/drive/u/0/folders/1uyEM3rM_bb7ljbkOmVwD9Ytof-hBYjZr)
 * [All files relevant to this project available here](https://drive.google.com/drive/u/0/folders/1uyEM3rM_bb7ljbkOmVwD9Ytof-hBYjZr)
 * [E Commerce Project1 Tableau Dashboard Here](https://public.tableau.com/views/E-CommerceProject1/Dashboard1?:language=en-GB&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)
    
    
















