SELECT * FROM sales_database.`synthetic online retail`; /** Outputs the content of the data in the table **/

SELECT SUM(price) AS Total_Amount_of_Sales FROM sales_database.`synthetic online retail`; /** Outpute Total Revenue Made **/

SELECT product_name, SUM(quantity) AS sales_per_product FROM sales_database.`synthetic online retail`
GROUP BY product_name
ORDER BY sales_per_product DESC; /** This add the total quantity sold per product and sort it from biggest to the smallest value**/

WITH 
Total_sales_per_year AS (
SELECT category_name, SUM(price) AS Total_Revenue, SUM(quantity) AS total_quantity, COUNT(DISTINCT city) AS No_of_cities
FROM sales_database.`synthetic online retail`
GROUP BY category_name
ORDER BY Total_Revenue DESC 
)/** larger CTE that contains the main query **/
SELECT category_name, Total_Revenue, No_of_cities, Total_Revenue/total_quantity AS Average_Sales

FROM Total_sales_per_year
ORDER BY Total_Revenue DESC  ; /** CTE definition which depends on the main CTE, #it outputs the total revenue per category and total number of cities and average sales**/

SELECT product_name, 
price,
AVG(age) OVER (PARTITION BY product_name) AS Average_age /** partition by is to group the products, like a group by**/
FROM sales_database.`synthetic online retail`; /** outputs the average age of customers that purchase a product**/