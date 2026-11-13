-- Objective 1: Customer Segmentation
-- How many customers are there in each customer segment?
SELECT segment,COUNT(*) AS total_customers
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;

-- What is the average annual income for each customer segment?
SELECT segment,ROUND(AVG(annual_income), 2) AS average_annual_income
FROM customers
GROUP BY segment
ORDER BY average_annual_income DESC;

-- How many active and inactive customers are there?
SELECT is_active,COUNT(*) AS total_customers
FROM customers
GROUP BY is_active
ORDER BY total_customers DESC;

-- What is the gender distribution of customers?
SELECT gender,COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers),2) AS percentage
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Which cities have the highest number of customers?
SELECT city,COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Which states have the highest number of customers?
SELECT state,COUNT(*) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC;

-- What is the average credit score for each segment?
SELECT segment,ROUND(AVG(credit_score), 2) AS average_credit_score,
COUNT(credit_score) AS customers_with_credit_score
FROM customers
GROUP BY segment
ORDER BY average_credit_score DESC;

-- How are customers distributed across KYC statuses?
SELECT kyc_status,COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers),2) AS percentage
FROM customers
GROUP BY kyc_status
ORDER BY total_customers DESC;

-- Which segments have the highest proportion of active customers?
SELECT segment,COUNT(*) AS total_customers,
SUM(CASE WHEN is_active = 'Yes' THEN 1 ELSE 0 END) AS active_customers,
ROUND(SUM(CASE WHEN is_active = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS active_percentage
FROM customers
GROUP BY segment
ORDER BY active_percentage DESC;


-- How long have customers been with the bank, on average, by segment?
SELECT segment,ROUND(AVG(DATEDIFF(
                (SELECT MAX(customer_since) FROM customers),
                customer_since) / 365.25),2) AS average_tenure_years
FROM customers
WHERE customer_since IS NOT NULL
GROUP BY segment
ORDER BY average_tenure_years DESC;


SELECT c.segment,ROUND(AVG(DATEDIFF(
                (SELECT MAX(transaction_date)
				FROM transactions),c.customer_since) / 365.25),2) AS average_tenure_years
FROM customers c
WHERE c.customer_since IS NOT NULL
GROUP BY c.segment
ORDER BY average_tenure_years DESC;

