/** escribe the entire dataset**/
DESCRIBE sales_database.`synthetic online retail`

/** Outputs the content of the data in the table **/
SELECT * FROM sales_database.`synthetic online retail`; 

/** This will return rows where review_score is either NULL, an empty string, or a placeholder value.**/
SELECT review_score, payment_method, city, gender, age, price, quantity, product_id, category_id, category_name, order_date
FROM sales_database.`synthetic online retail`
WHERE review_score IS NULL OR review_score = '' OR review_score = 'NULL';

/** This will return rows where gender is either NULL, an empty string, or a placeholder value.**/
SELECT review_score, payment_method, city, gender, age, price, quantity, product_id, category_id, category_name, order_date
FROM sales_database.`synthetic online retail`
WHERE gender IS NULL OR gender = '' OR gender = 'NULL';

/** CASE statement to check if the value is an empty string and replace it with 0**/
SELECT 
    CASE 
        WHEN review_score = '' THEN 0
        ELSE review_score
    END AS review_score
FROM sales_database.`synthetic online retail`;

/** CASE statement to check if the value is an empty string and replace it with Not stated**/
SELECT 
    CASE 
        WHEN gender = '' THEN 'Not stated'
        ELSE gender
    END AS gender
FROM sales_database.`synthetic online retail`;

/** Calculates the Total Revenue generated **/
SELECT SUM(price) AS Total_Amount_of_Sales FROM sales_database.`synthetic online retail`; 

/** This add the total quantity sold per product and sort it from biggest to the smallest value**/
SELECT product_name, SUM(quantity) AS sales_per_product FROM sales_database.`synthetic online retail`
GROUP BY product_name
ORDER BY sales_per_product DESC; 

/** Calculates the Total revenue,Total quantity for each Category name
**/
WITH Total_sales_per_year AS (
    SELECT 
        category_name,
        ROUND(SUM(price), 2) AS Total_Revenue,  -- Round to 2 decimal places
        ROUND(SUM(quantity), 2) AS Total_Quantity  -- Round to 2 decimal places
    FROM sales_database.`synthetic online retail`
    GROUP BY category_name, YEAR(order_date)  
)
SELECT * 
FROM Total_sales_per_year
ORDER BY Total_Revenue DESC;

/** Calculates the average sales per city**/
WITH 
Average_revenue_per_city AS (
    SELECT 
        city, 
        SUM(price) AS Total_Revenue, 
        SUM(quantity) AS Total_Quantity
    FROM sales_database.`synthetic online retail`
    GROUP BY city
    ORDER BY Total_Revenue DESC
)
SELECT 
    city,
    ROUND(Total_Revenue / Total_Quantity, 2) AS Average_Revenue  -- Calculate average revenue and round to 2 decimal places
FROM Average_revenue_per_city  -- Referencing CTE here
ORDER BY Average_Revenue DESC;

WITH Average_sales_per_Category AS (
    SELECT 
        category_name,
        ROUND(SUM(price), 2) AS Total_Revenue,  -- Round to 2 decimal places
        ROUND(SUM(quantity), 2) AS Total_Quantity,  -- Round to 2 decimal places
        COUNT(DISTINCT city) AS No_of_cities
    FROM sales_database.`synthetic online retail`
    GROUP BY category_name, YEAR(order_date)  -- Grouping by category_name and year
)
SELECT 
    category_name, 
    Total_Revenue, 
    No_of_cities, 
    Total_Revenue / NULLIF(Total_Quantity, 0) AS Average_Sales
FROM Average_sales_per_Category
ORDER BY Total_Revenue DESC;


/**Calculates the Total Quantity Sold by Gender and where there is an empty string or null value, it returns as not stated**/
SELECT 
    CASE 
        WHEN gender = '' THEN 'Not stated'
        ELSE gender
    END AS gender, 
    SUM(price) AS Total_Revenue
FROM sales_database.`synthetic online retail`
GROUP BY 
    CASE 
        WHEN gender = '' THEN 'Not stated'
        ELSE gender
    END;
