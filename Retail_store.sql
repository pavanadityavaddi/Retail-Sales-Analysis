use retail_store;
CREATE TABLE retail_sales (
    Order_ID INT PRIMARY KEY,
    Order_Date VARCHAR(10),
    Customer_ID VARCHAR(20),
    City VARCHAR(50),
    Category VARCHAR(50),
    Product_Name VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Revenue DECIMAL(10,2),
    Cost DECIMAL(10,2),
    Profit DECIMAL(10,2),
    Payment_Method VARCHAR(30),
    Sales_Channel VARCHAR(30),
    Customer_Rating DECIMAL(3,2),
    Marketing_Campaign VARCHAR(50),
    Customer_Type VARCHAR(20),
    discount_percentage DECIMAL(5,2),
    cost_validation VARCHAR(10),
    Month VARCHAR(20),
    Month_number INT
);
LOAD DATA LOCAL INFILE 'E:/Mock/Retail store/Cleaned data/DA-1(Retail) - Sheet1 (1).csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select sum(Revenue) as Total_revenue
from retail_sales;
select sum(Profit) as Total_profit
from retail_sales;
select avg(Customer_Rating) as average_rating
from retail_sales;
select count(Customer_ID) as total_customers
from retail_sales;

#Revenue Analysis
select Category,sum(Revenue) as Total_revenue
from retail_sales
group by Category
order by Total_revenue desc;
select avg(Revenue)
from retail_sales;

#Customer Analysis
select City,sum(Revenue) as Total_revenue
from retail_sales
group by City
having sum(Revenue) >(
select avg(city_revenue)
from (
select sum(Revenue) as city_revenue 
from retail_sales
group by City
) as t
);

#Profitability Analysis
select Product_Name
from retail_sales
group by Product_Name
having sum(Profit) > (
select avg(Profit)
from(
select sum(Profit) as Product_profit
from retail_sales
) as t
);

#Customer Segmentation
select Customer_ID,sum(Revenue) as Total_revenue,case
	when sum(Revenue)>=5000 then "High value"
    when sum(Revenue)>=2000 then "Medium value"
    else "Low value"
end as customer_segment
from retail_sales
group by Customer_ID;

#Product ranking
select Product_Name,Category,sum(Revenue) as total_revenue,rank()
over(partition by Category order by sum(Revenue) desc) as product_rank
from retail_sales
group by Product_Name,Category;

#CTE
with city as(
select City,sum(Revenue) as total_revenue,sum(Profit) as total_profit,count(Order_ID) as total_orders
from retail_sales
group by City)
select * from city;
