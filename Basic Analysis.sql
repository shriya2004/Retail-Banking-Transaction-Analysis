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
