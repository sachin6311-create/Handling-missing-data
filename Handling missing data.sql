create database handling_missing_data;
use handling_missing_data;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    monthly_sales INT,
    income INT,
    region VARCHAR(50)
);

INSERT INTO customers (customer_id, name, city, monthly_sales, income, region) VALUES
(101, 'Rahul Mehta', 'Mumbai', 12000, 65000, 'West'),
(102, 'Anjali Rao', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh Iyer', 'Chennai', 15000, 72000, 'South'),
(104, 'Neha Singh', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit Verma', 'Hyderabad', 18000, 80000, NULL),
(106, 'Karan Shah', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja Das', 'Kolkata', 14000, NULL, 'East'),
(108, 'Riya Kapoor', 'Jaipur', 16000, 69000, 'North');


# Q8. Listwise Deletion 
-- Remove all rows where Region is missing.

select * from customers
where region is null;     -- check rows with null value in region

delete from customers
where region is null;  

-- Tasks: Identify affected rows
# Affected row no. is 105

-- Records Lost: Total before: 8 Deleted: 1  Remaining: 7

-- Show the dataset after deletion

select * from customers;

-- Mention how many records were lost

# Total records lost = 1

# Q9. Imputation 
-- Handle missing values in Monthly_Sales using:
-- Forward Fill
-- Tasks:
-- Apply forward fill
-- Show before vs after values
-- Explain why forward fill is suitable here
 
WITH RECURSIVE filled_data AS (
    
    -- Anchor row (first row)
    SELECT 
        customer_id,
        monthly_sales,
        monthly_sales AS filled_sales
    FROM customers
    WHERE customer_id = (SELECT MIN(customer_id) FROM customers)

    UNION ALL

    -- Recursive part
    SELECT 
        c.customer_id,
        c.monthly_sales,
        IF(c.monthly_sales IS NULL, f.filled_sales, c.monthly_sales) AS filled_sales
    FROM customers c
    JOIN filled_data f 
        ON c.customer_id = f.customer_id + 1
)
SELECT * FROM filled_data;
 
 SELECT customer_id , monthly_sales 
 FROM CUSTOMERS 
 ORDER BY customer_id;   -- Data after forward filling


# Q10. Flagging Missing Data
-- Create a flag column for missing Income.
-- Tasks:
-- Create  (0 = present, 1 = missing)

ALTER TABLE customers
ADD COLUMN Income_missing_flag int;  -- create a new column Income_Missing_Flag

UPDATE customers
SET Income_missing_flag = CASE WHEN 
              income is null THEN 1 ELSE 0
	END;

-- Show updated dataset

SELECT * FROM customers;

-- Count how many customers have missing income

SELECT COUNT(customer_id) AS missing_income
from customers
WHERE Income_missing_flag = 1;




