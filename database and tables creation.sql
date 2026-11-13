
CREATE DATABASE IF NOT EXISTS retail_banking;

USE retail_banking;


CREATE TABLE branches (
    branch_id VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(30),
    region VARCHAR(30),
    opening_date DATE,
    employee_count INT
);



CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(30),
    customer_since DATE,
    kyc_status VARCHAR(20),
    segment VARCHAR(30),
    annual_income DECIMAL(12,2),
    credit_score INT,
    is_active VARCHAR(3)
);



CREATE TABLE accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    account_type VARCHAR(30),
    open_date DATE,
    close_date DATE,
    current_balance DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    overdraft_limit DECIMAL(12,2),
    status VARCHAR(20),

    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_accounts_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);



CREATE TABLE loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    loan_type VARCHAR(30),
    principal_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    disbursement_date DATE,
    maturity_date DATE,
    emi_amount DECIMAL(12,2),
    outstanding_balance DECIMAL(15,2),
    loan_status VARCHAR(30),
    purpose VARCHAR(50),

    CONSTRAINT fk_loans_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_loans_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);




CREATE TABLE cards (
    card_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    card_type VARCHAR(20),
    issue_date DATE,
    expiry_date DATE,
    credit_limit DECIMAL(12,2),
    outstanding_balance DECIMAL(12,2),
    reward_points INT,
    is_active VARCHAR(3),
    network VARCHAR(20),

    CONSTRAINT fk_cards_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);



CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    transaction_date DATE,
    transaction_time TIME,
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2),
    channel VARCHAR(30),
    description VARCHAR(50),
    balance_after DECIMAL(15,2),
    status VARCHAR(20),

    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);



CREATE TABLE loan_payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date DATE,
    scheduled_amount DECIMAL(12,2),
    paid_amount DECIMAL(12,2),
    principal_paid DECIMAL(12,2),
    interest_paid DECIMAL(12,2),
    penalty DECIMAL(12,2),
    days_late INT,
    payment_method VARCHAR(30),
    status VARCHAR(20),

    CONSTRAINT fk_loan_payments_loan
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);


SHOW TABLES;


DESCRIBE branches;
DESCRIBE customers;
DESCRIBE accounts;
DESCRIBE loans;
DESCRIBE cards;
DESCRIBE transactions;
DESCRIBE loan_payments;


USE retail_banking;

SELECT COUNT(*) AS total_branches
FROM branches;

SELECT COUNT(*) AS total_customers
FROM customers;

USE retail_banking;

SELECT COUNT(*) AS total_accounts
FROM accounts;

USE retail_banking;

SELECT COUNT(*) AS total_accounts
FROM accounts;

SELECT *
FROM accounts
LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    COUNT(close_date) AS non_null_close_dates,
    COUNT(*) - COUNT(close_date) AS null_close_dates
FROM accounts;

SELECT account_id, close_date
FROM accounts
LIMIT 10;

-- Sprint3
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_customers FROM accounts;
SELECT DISTINCT account_type FROM accounts;
SELECT COUNT(*) AS active_customers FROM customers where is_active="Yes";
SELECT DISTINCT transaction_type FROM transactions;
SELECT sum(amount) as total_transactions FROM transactions where status="Completed";
SELECT DISTINCT loan_type FROM loans;
SELECT COUNT(*) AS total_loans FROM loans;
SELECT DISTINCT card_type FROM cards;
SELECT SUM(outstanding_balance) AS total_outstanding_loan_balance FROM loans;
USE retail_banking;


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

