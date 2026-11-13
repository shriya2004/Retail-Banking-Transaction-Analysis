-- objective -6 Customer and Banking Risk Analysis

USE retail_banking;

-- Customer relationship overview
-- Find how many accounts, loans, and cards customers have.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.segment,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT cd.card_id) AS total_cards
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN loans l
    ON c.customer_id = l.customer_id
LEFT JOIN cards cd
    ON a.account_id = cd.account_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.segment
ORDER BY total_accounts DESC, total_loans DESC
LIMIT 20;



-- Query 2 — Customers with both loans and credit cards

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT cd.card_id) AS total_cards,
    ROUND(SUM(DISTINCT l.outstanding_balance), 2)
        AS loan_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN cards cd
    ON a.account_id = cd.account_id
WHERE cd.card_type = 'Credit'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY loan_outstanding DESC
LIMIT 20;




-- Query 3 — Customer account balances and loan exposure

SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    ROUND(SUM(DISTINCT a.current_balance), 2)
        AS balance_sum_check
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.segment
ORDER BY total_accounts DESC;



SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(a.account_id) AS total_accounts,
    ROUND(SUM(a.current_balance), 2) AS total_balance,
    ROUND(AVG(a.current_balance), 2) AS average_balance
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.segment
ORDER BY total_balance DESC;

-- Query 4 — Customers with defaulted or overdue loans

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.segment,
    COUNT(l.loan_id) AS total_problem_loans,
    ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
WHERE l.loan_status IN ('Defaulted', 'In Arrears')
GROUP BY c.customer_id, c.first_name, c.last_name, c.segment
ORDER BY total_outstanding DESC
LIMIT 20;



-- Query 5 — Customer KYC and loan-status comparison

SELECT
    c.kyc_status,
    l.loan_status,
    COUNT(*) AS total_loans,
    ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.kyc_status, l.loan_status
ORDER BY c.kyc_status, total_loans DESC;  




SELECT
    c.kyc_status,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE
        WHEN l.loan_status = 'Defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE
            WHEN l.loan_status = 'Defaulted' THEN 1
            ELSE 0
        END) / COUNT(l.loan_id),
        2
    ) AS default_rate_percent,
    SUM(CASE
        WHEN l.loan_status = 'In Arrears' THEN 1
        ELSE 0
    END) AS loans_in_arrears
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.kyc_status
ORDER BY default_rate_percent DESC;