-- Objective 3: Transaction Analysis
-- sprint4.3
-- What is the overall transaction volume and value?
SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_amount,
    ROUND(AVG(amount), 2) AS average_transaction_amount,
    ROUND(MIN(amount), 2) AS minimum_transaction_amount,
    ROUND(MAX(amount), 2) AS maximum_transaction_amount
FROM transactions;

-- How many transactions are there for each transaction type?
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- What is the status of the transactions?
SELECT status,
COUNT(*) AS total_transactions,
ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM transactions),2) AS percentage
FROM transactions
GROUP BY status
ORDER BY total_transactions DESC;

-- Which transaction channels are used most often?
SELECT
    channel,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY channel
ORDER BY total_transactions DESC;

-- How do transaction statuses vary by transaction type?
SELECT transaction_type,status,COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_type, status
ORDER BY transaction_type, total_transactions DESC;

-- What is the value of completed transactions by type?
SELECT
    transaction_type,
    COUNT(*) AS completed_transactions,
    ROUND(SUM(amount), 2) AS completed_amount,
    ROUND(AVG(amount), 2) AS average_completed_amount
FROM transactions
WHERE status = 'Completed'
GROUP BY transaction_type
ORDER BY completed_amount DESC;

-- Which transaction types have the highest failure rates?
SELECT transaction_type,
COUNT(*) AS total_transactions,
SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END)
        AS failed_transactions,
    ROUND(100.0 * SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END)
        / COUNT(*),2) AS failure_rate_percentage
FROM transactions
GROUP BY transaction_type
ORDER BY failure_rate_percentage DESC;

-- How does transaction activity change by month?
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

-- Which customers generate the highest transaction value?
SELECT c.customer_id,c.first_name,c.last_name,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount), 2) AS total_transaction_amount
FROM customers c
JOIN accounts a
ON c.customer_id = a.customer_id
JOIN transactions t
ON a.account_id = t.account_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_transaction_amount DESC
LIMIT 10;


-- identify the channels with the highest failure rates
SELECT channel,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END)
        AS failed_transactions,
    ROUND(100.0 * SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END)
        / COUNT(*),2) AS failure_rate_percentage
FROM transactions
GROUP BY channel
ORDER BY failure_rate_percentage DESC;