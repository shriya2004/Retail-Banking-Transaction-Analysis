USE retail_banking;

-- Objective 2: Account and Branch Activity
-- How many accounts are there for each account type?

SELECT account_type,COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

-- How many accounts are there for each account status?
SELECT status,COUNT(*) AS total_accounts
FROM accounts
GROUP BY status
ORDER BY total_accounts DESC;

-- What is the average current balance for each account type?
SELECT account_type,ROUND(AVG(current_balance), 2) AS average_balance,
SUM(current_balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY average_balance DESC;


-- Do active and closed accounts have different balances?
SELECT status,COUNT(*) AS total_accounts,
ROUND(AVG(current_balance), 2) AS average_balance,
ROUND(SUM(current_balance), 2) AS total_balance
FROM accounts
GROUP BY status
ORDER BY total_balance DESC;

-- Which account types have the most closed accounts?
SELECT account_type,status,COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type, status
ORDER BY account_type, total_accounts DESC;

-- Which branches manage the most accounts and balances?
SELECT b.branch_id,b.branch_name,b.city,b.region,
COUNT(a.account_id) AS total_accounts,
ROUND(AVG(a.current_balance), 2) AS average_balance,  
ROUND(SUM(a.current_balance), 2) AS total_balance
FROM branches b
LEFT JOIN accounts a
ON b.branch_id = a.branch_id
GROUP BY b.branch_id,b.branch_name,b.city,b.region
ORDER BY total_accounts DESC;

-- Which account types offer the highest interest rates?
SELECT account_type,
COUNT(*) AS total_accounts,
ROUND(AVG(interest_rate), 2) AS average_interest_rate,
ROUND(MIN(interest_rate), 2) AS minimum_interest_rate,
ROUND(MAX(interest_rate), 2) AS maximum_interest_rate
FROM accounts
GROUP BY account_type
ORDER BY average_interest_rate DESC;

-- Which account types have the highest closure rate?
SELECT account_type,COUNT(*) AS total_accounts,
SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END)
AS closed_accounts,ROUND(100.0 * SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS closure_rate_percentage
FROM accounts
GROUP BY account_type
ORDER BY closure_rate_percentage DESC;

-- Which regions manage the highest number of accounts and total balances?
SELECT b.region,
COUNT(a.account_id) AS total_accounts,
ROUND(AVG(a.current_balance), 2) AS average_balance,
ROUND(SUM(a.current_balance), 2) AS total_balance
FROM branches b
LEFT JOIN accounts a
ON b.branch_id = a.branch_id
GROUP BY b.region
ORDER BY total_balance DESC;

-- Which customers hold the most accounts?
SELECT c.customer_id,c.first_name,c.last_name,
COUNT(a.account_id) AS total_accounts,
ROUND(SUM(a.current_balance), 2) AS total_balance
FROM customers c
LEFT JOIN accounts a
ON c.customer_id = a.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_accounts DESC, total_balance DESC
LIMIT 10;


-- data-quality check
SELECT status,COUNT(*) AS total_accounts,
SUM(CASE WHEN close_date IS NULL THEN 1 ELSE 0 END)  AS missing_close_dates,
SUM(CASE WHEN close_date IS NOT NULL THEN 1 ELSE 0 END) AS recorded_close_dates
FROM accounts
GROUP BY status;
