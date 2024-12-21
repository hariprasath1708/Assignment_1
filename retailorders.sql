create database retailorders;
use retailorders;
SHOW TABLES;
DESCRIBE retailorders;
select * from retailorders;

#Top-Selling Products
SELECT product_id, SUM(quantity * sale_price) AS total_revenue
FROM retailorders
GROUP BY product_id
ORDER BY total_revenue DESC;
#Monthly Sales Analysis: 
SELECT 
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    SUM(quantity * sale_price) AS total_sales
FROM retailorders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY sales_year, sales_month;

#Product Performance:Use functions like GROUP BY, HAVING, ROW_NUMBER(), and CASE WHEN to categorize and rank products by their revenue, profit margin, etc.

SHOW COLUMNS FROM retailorders;

WITH ProductPerformance AS (
    SELECT
        product_id,category,sub_category,
        SUM(quantity * sale_price) AS total_revenue,  -- Calculate total revenue
        SUM(quantity * (sale_price - cost_price)) AS total_profit,  -- Calculate total profit
        (SUM(quantity * (sale_price - cost_price)) / SUM(quantity * sale_price)) * 100 AS profit_margin,  -- Calculate profit margin percentage
        ROW_NUMBER() OVER (ORDER BY SUM(quantity * sale_price) DESC) AS revenue_rank,  -- Rank by total revenue
        ROW_NUMBER() OVER (ORDER BY (SUM(quantity * (sale_price - cost_price)) / SUM(quantity * sale_price)) DESC) AS profit_margin_rank  -- Rank by profit margin
    FROM retailorders
    GROUP BY product_id, category, sub_category
    HAVING SUM(quantity * sale_price) > 1000  -- Filter products with revenue greater than 1000
)
SELECT
    product_id,category,sub_category,total_revenue,total_profit,profit_margin,revenue_rank,
    profit_margin_rank,
    CASE
        WHEN profit_margin > 20 THEN 'High Profit Margin'
        WHEN profit_margin BETWEEN 10 AND 20 THEN 'Medium Profit Margin'
        ELSE 'Low Profit Margin'
    END AS profit_category
FROM ProductPerformance
ORDER BY revenue_rank;
#Regional Sales Analysis
SELECT 
    region,  -- Group by region
    SUM(quantity * sale_price) AS total_sales,  -- Calculate total sales for each region
    SUM(quantity * (sale_price - cost_price)) AS total_profit,  -- Calculate total profit for each region
    AVG(sale_price) AS average_sale_price,  -- Calculate the average sale price in the region
    COUNT(DISTINCT product_id) AS product_count  -- Count the number of unique products sold in the region
FROM retailorders
GROUP BY region  -- Group the data by region
HAVING SUM(quantity * sale_price) > 1000  -- Only include regions where total sales exceed 1000
ORDER BY total_sales DESC;  -- Sort by total sales in descending order (highest performing regions first)

#Discount Analysis
SELECT 
    product_id,  -- Identify the product
    category,  -- Product category (optional for more detailed analysis)
    discount_percent,  -- The discount applied to the product
    sale_price,  -- The sale price after discount
    cost_price,  -- The cost price of the product
    list_price,  -- The original price before any discount
    (list_price - sale_price) AS discount_impact,  -- Impact of the discount (how much the price was reduced)
    SUM(quantity * sale_price) AS total_sales,  -- Total sales after discount
    SUM(quantity * (sale_price - cost_price)) AS total_profit  -- Profit after discount
FROM retailorders
WHERE discount_percent < 20  -- Filter products with discounts greater than 20%
GROUP BY product_id, category, discount_percent, sale_price, cost_price, list_price
ORDER BY total_sales DESC;  -- Sort by total sales to identify highest-selling discounted products

# 1.Find top 10 highest revenue generating products
SELECT 
    product_id,  -- Product ID
    category,  -- Product category (optional)
    SUM(quantity * sale_price) AS total_revenue  -- Calculate total revenue
FROM retailorders  -- Table containing the sales data
GROUP BY product_id, category  -- Group by product ID and category (if needed)
ORDER BY total_revenue DESC  -- Order by total revenue in descending order
limit 10;
#2. Find the top 5 cities with the highest profit margins
SELECT 
    city,  -- City name
    SUM(profit) AS total_profit,  -- Total profit in each city
    SUM(quantity * sale_price) AS total_sales,  -- Total sales in each city
    (SUM(profit) / SUM(quantity * sale_price)) * 100 AS profit_margin  -- Profit margin in percentage
FROM retailorders  -- Table containing the sales data
GROUP BY city  -- Group by city to calculate profit margin for each city
ORDER BY profit_margin DESC  -- Order by profit margin in descending order
LIMIT 5;  -- Limit to top 5 cities with the highest profit margins

#3.Calculate the total discount given for each category
SELECT 
    category,  -- Product category
    SUM(quantity * discount) AS total_discount  -- Total discount for each category
FROM retailorders  -- Table containing the sales data
GROUP BY category  -- Group by category
ORDER BY total_discount DESC;  -- Optionally, order by total discount in descending order

#4.Calculate the total discount given for each category
SELECT 
    category,  -- Product category
    AVG(sale_price) AS avg_sale_price  -- Average sale price per category
FROM retailorders  -- Table containing the sales data
GROUP BY category  -- Group by product category
ORDER BY avg_sale_price DESC;  -- Optionally, order by average sale price in descending order
    
#5.Find the region with the highest average sale price   
 SELECT 
    region,  -- Region where the product was sold
    AVG(sale_price) AS avg_sale_price  -- Average sale price in each region
FROM retailorders  -- Table containing the sales data
GROUP BY region  -- Group by region
ORDER BY avg_sale_price DESC;  -- Order the results by average sale price in descending order
#6.Find the total profit per category    
SELECT 
    category,  -- Product category
    SUM(profit) AS total_profit  -- Total profit for each category
FROM retailorders  -- Table containing the sales data
GROUP BY category  -- Group by product category
ORDER BY total_profit DESC;  -- Optionally, order by total profit in descending order

#7.Identify the top 3 segments with the highest quantity of orders
SELECT 
    segment,  -- Customer segment (e.g., Consumer, Corporate, Home Office)
    SUM(quantity) AS total_quantity  -- Total quantity of orders in each segment
FROM retailorders  -- Table containing the sales data
GROUP BY segment  -- Group by customer segment
ORDER BY total_quantity DESC  -- Order the results by total quantity in descending order
LIMIT 3;  -- Limit the result to the top 3 segments
#8.Identify the top 3 segments with the highest quantity of orders
SELECT 
    region,  -- The region (e.g., North, South, East, West)
    AVG(discount_percent) AS average_discount  -- Average discount percentage for each region
FROM retailorders  -- Table containing the sales data
GROUP BY region  -- Group by region
ORDER BY average_discount DESC;  -- Optionally, order by average discount in descending order

#9. Find the product category with the highest total profit
SELECT 
    category,  -- The product category (e.g., Technology, Furniture, Office Supplies)
    SUM(profit) AS total_profit  -- Calculate the total profit for each product category
FROM retailorders  -- Table containing the sales data
GROUP BY category  -- Group the data by product category
ORDER BY total_profit DESC;  -- Order the results by total profit in descending order

#10. Calculate the total revenue generated per year
SELECT 
    YEAR(order_date) AS sales_year,  -- Extract the year from the order date
    SUM(quantity * sale_price) AS total_revenue  -- Calculate the total revenue per year
FROM retailorders  -- Table containing the sales data
GROUP BY YEAR(order_date)  -- Group the data by year
ORDER BY sales_year;  -- Order the results by year in ascending order
    
#11.create ordersview
CREATE VIEW OrdersView AS
SELECT 
    order_id,order_date,ship_mode,segment,country,city,state,postal_code,region
FROM retailorders;
SELECT * FROM OrdersView;

#12.create Productsview
CREATE VIEW ProductsView AS
SELECT 
    order_id,product_id,category,sub_category,cost_price,list_price,quantity,discount_percent,discount,sale_price,profit
FROM retailorders;
SELECT * FROM ProductsView;
DESCRIBE retailorders;
DESCRIBE Products;
ALTER TABLE Products MODIFY product_id VARCHAR(255);


#13.create primarykey and foreign key
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50)
);
INSERT INTO Orders (order_id, order_date, ship_mode, segment, country, city, state, postal_code, region)
SELECT order_id, order_date, ship_mode, segment, country, city, state, postal_code, region
FROM retailorders;
select*from orders;
DESCRIBE Products;

CREATE TABLE Products (
    order_id INT NOT NULL PRIMARY KEY,-- Foreign key referencing the Orders table
    product_id VARCHAR(2),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    cost_price DECIMAL(10,2),
    list_price DECIMAL(10,2),
    quantity INT,
    discount_percent DECIMAL(5,2),
    discount DECIMAL(10,2),
    sale_price DECIMAL(10,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)  -- Assuming Orders table exists
);
INSERT IGNORE INTO Products (
    product_id, order_id, category, sub_category, cost_price, list_price, quantity, discount_percent, discount, sale_price, profit
)
SELECT 
    Product_ID, order_id, category, sub_category, cost_price, list_price, quantity, discount_percent, discount, sale_price, profit
FROM retailorders;

select * from products;
select * from retailorders;


#14. Arrange asc order in order_id
SELECT *FROM Products
ORDER BY order_id ASC;

#15.Drop the unknown col
ALTER TABLE retailorders
DROP COLUMN MyUnknownColumn;
select*from retailorders;

#16.UPDATE retailorders SET CONCAT in the city and state column
ALTER TABLE retailorders
ADD COLUMN City_State VARCHAR(100);
UPDATE retailorders
SET City_State = CONCAT(city, ' - ', State);
SELECT 
    order_id, order_date, ship_mode, segment, country, 
    CONCAT(city, ' - ', state) AS city_state, postal_code, region, category, sub_category, 
    product_id, cost_price, list_price, quantity, discount_percent, discount, sale_price, 
    profit
FROM retailorders;

#17.To Filter Data by Specific Conditions:Where:region AND category :Furniture
 SELECT 
    p.product_id,p.category,p.sub_category,p.sale_price,p.quantity,
    o.order_id,o.order_date,o.region
FROM Products p
JOIN Orders o ON p.order_id = o.order_id
WHERE o.region = 'East' AND p.category = 'Furniture';

#18.innerJOIN    
SELECT  o.order_id, o.order_date, p.product_id, p.sale_price
FROM Orders o INNER JOIN Products p
ON o.order_id = p.order_id;
    
#19.join product table to orders table
SELECT 
p.product_id,p.category,p.sub_category,p.sale_price,p.quantity,
o.order_id,o.order_date,o.ship_mode,o.city,o.region
FROM Products p
JOIN Orders o ON p.order_id = o.order_id;

#20.First and Last Sale Price in Each Category
SELECT product_id,category,sale_price,
    FIRST_VALUE(sale_price) OVER (PARTITION BY category ORDER BY sale_price ASC) AS first_price,
    LAST_VALUE(sale_price) OVER (PARTITION BY category ORDER BY sale_price ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_price
    FROM Products;
    
#21.Total Sales and Average Price by Category
SELECT product_id,category,sale_price,
    SUM(sale_price) OVER (PARTITION BY category) AS total_sales_by_category,
    AVG(sale_price) OVER (PARTITION BY category) AS avg_price_by_category
FROM Products;
    
#22 a).Find min & max profit from retailorders
SELECT 
    MIN(profit) AS min_profit, 
    MAX(profit) AS max_profit
FROM retailorders;

#22 b)Find min & max sale_price from retailorders
SELECT 
    MIN(sale_price) AS min_sale_price, 
    MAX(sale_price) AS max_sale_price
FROM retailorders;

#23.Combines the two using union join
SELECT 
 o.order_id,o.order_date,o.ship_mode,o.segment,o.country,o.city,o.state,o.postal_code,o.region,
 p.product_id,p.category,p.sub_category,p.cost_price,p.list_price,p.quantity,
 p.discount_percent,p.discount,p.sale_price,p.profit
FROM Orders o
LEFT JOIN Products p 
ON o.order_id = p.order_id
UNION
SELECT 
    o.order_id,o.order_date,o.ship_mode,o.segment,o.country,o.city,o.state,o.postal_code,o.region,
    p.product_id,p.category,p.sub_category,p.cost_price,p.list_price,p.quantity,
    p.discount_percent,p.discount,p.sale_price,p.profit
FROM Products p
RIGHT JOIN Orders o ON p.order_id = o.order_id;
describe orders;
describe products;