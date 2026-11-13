-- Business Objective 4 — Loan Analysis
-- Objective sprint-4.4
-- Understand loan distribution by loan type

SELECT loan_type,
    COUNT(*) AS total_loans,
    ROUND(SUM(principal_amount), 2) AS total_principal,
    ROUND(AVG(principal_amount), 2) AS average_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;

-- Loan status analysis

SELECT
    loan_status,
    COUNT(*) AS total_loans,
    ROUND(SUM(principal_amount), 2) AS total_principal,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding
FROM loans
GROUP BY loan_status
ORDER BY total_loans DESC;

-- Loan distribution by loan type and status

SELECT loan_type,loan_status,COUNT(*) AS total_loans,
ROUND(SUM(outstanding_balance), 2) AS total_outstanding
FROM loans
GROUP BY loan_type, loan_status
ORDER BY loan_type, total_loans DESC;

-- Outstanding balance by loan type

SELECT loan_type,
    COUNT(*) AS total_loans,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding DESC;

-- Loan status by branch

SELECT b.branch_id,b.branch_name,b.city,
COUNT(l.loan_id) AS total_loans,
ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding
FROM branches b
JOIN loans l
ON b.branch_id = l.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_outstanding DESC;

-- Average interest rate by loan type

SELECT
    loan_type,
    COUNT(*) AS total_loans,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(MIN(interest_rate), 2) AS minimum_interest_rate,
    ROUND(MAX(interest_rate), 2) AS maximum_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY average_interest_rate DESC;

-- Average loan tenure by loan type

SELECT
    loan_type,
    COUNT(*) AS total_loans,
    ROUND(AVG(tenure_months), 2) AS average_tenure_months,
    MIN(tenure_months) AS minimum_tenure_months,
    MAX(tenure_months) AS maximum_tenure_months
FROM loans
GROUP BY loan_type
ORDER BY average_tenure_months DESC;

-- Loan repayment performance

SELECT
    status,
    COUNT(*) AS total_payments,
    ROUND(SUM(scheduled_amount), 2) AS total_scheduled,
    ROUND(SUM(paid_amount), 2) AS total_paid,
    ROUND(AVG(days_late), 2) AS average_days_late
FROM loan_payments
GROUP BY status
ORDER BY total_payments DESC;

-- Late payments and penalties by payment status

SELECT
    status,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN days_late > 0 THEN 1 ELSE 0 END)
        AS late_payments,
    ROUND(
        100.0 * SUM(CASE WHEN days_late > 0 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS late_payment_percentage,
    ROUND(SUM(penalty), 2) AS total_penalties
FROM loan_payments
GROUP BY status
ORDER BY late_payment_percentage DESC;

-- Loan repayment performance by loan type

SELECT l.loan_type,
COUNT(lp.payment_id) AS total_payments,
SUM(CASE WHEN lp.days_late > 0 THEN 1 ELSE 0 END)AS late_payments,
ROUND(100.0 * SUM(CASE WHEN lp.days_late > 0 THEN 1 ELSE 0 END)
/ COUNT(lp.payment_id), 2) AS late_payment_percentage,
ROUND(SUM(lp.penalty), 2) AS total_penalties
FROM loans l
JOIN loan_payments lp
ON l.loan_id = lp.loan_id
GROUP BY l.loan_type
ORDER BY late_payment_percentage DESC;

-- Top 10 loans by outstanding balance

SELECT l.loan_id,c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
l.loan_type,l.loan_status,
ROUND(l.principal_amount, 2) AS principal_amount,
ROUND(l.outstanding_balance, 2) AS outstanding_balance
FROM loans l
JOIN customers c
ON l.customer_id = c.customer_id
ORDER BY l.outstanding_balance DESC
LIMIT 10;

-- Loan status percentages

SELECT
    loan_status,
    COUNT(*) AS total_loans,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM loans), 2) AS percentage_of_loans
FROM loans
GROUP BY loan_status
ORDER BY percentage_of_loans DESC;

-- Outstanding loan balance by customer segment

SELECT c.segment,COUNT(l.loan_id) AS total_loans,
ROUND(SUM(l.principal_amount), 2) AS total_principal,
ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(l.outstanding_balance), 2) AS average_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.segment
ORDER BY total_outstanding DESC;

-- Customers with multiple loans

SELECT c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(l.loan_id) > 1
ORDER BY total_loans DESC, total_outstanding DESC;

