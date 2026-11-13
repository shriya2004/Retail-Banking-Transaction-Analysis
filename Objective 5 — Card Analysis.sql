-- Objective 5 — Card Analysis
USE retail_banking;

-- Card distribution by type
SELECT card_type,
COUNT(*) AS total_cards,
SUM(CASE WHEN is_active = 'Yes' THEN 1 ELSE 0 END) AS active_cards,
SUM(CASE WHEN is_active = 'No' THEN 1 ELSE 0 END) AS inactive_cards
FROM cards
GROUP BY card_type
ORDER BY total_cards DESC;

-- Card distribution by network

SELECT network,COUNT(*) AS total_cards,
SUM(CASE WHEN is_active = 'Yes' THEN 1 ELSE 0 END)AS active_cards
FROM cards
GROUP BY network
ORDER BY total_cards DESC;

-- Credit limits and outstanding balances by card type

SELECT
    card_type,
    COUNT(*) AS total_cards,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit,
    ROUND(SUM(credit_limit), 2) AS total_credit_limit,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding
FROM cards
GROUP BY card_type
ORDER BY total_outstanding DESC;

-- Active versus inactive card balances

SELECT
    is_active,
    COUNT(*) AS total_cards,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding
FROM cards
GROUP BY is_active;

-- Credit utilization by card type

SELECT card_type,COUNT(*) AS total_cards,
    ROUND(SUM(credit_limit), 2) AS total_credit_limit,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,
    ROUND(100.0 * SUM(outstanding_balance)
        / NULLIF(SUM(credit_limit), 0),2) AS utilization_percentage
FROM cards
WHERE is_active = 'Yes'
GROUP BY card_type
ORDER BY utilization_percentage DESC;

-- Reward points by card type

SELECT
    card_type,
    COUNT(*) AS total_cards,
    ROUND(AVG(reward_points), 2) AS average_reward_points,
    SUM(reward_points) AS total_reward_points
FROM cards
GROUP BY card_type
ORDER BY total_reward_points DESC;

-- Cards issued by year

SELECT YEAR(issue_date) AS issue_year,COUNT(*) AS cards_issued
FROM cards
GROUP BY YEAR(issue_date)
ORDER BY issue_year;

-- Cards nearing expiry

SELECT
    card_type,
    COUNT(*) AS cards_nearing_expiry
FROM cards
WHERE expiry_date >= (
    SELECT MAX(transaction_date) FROM transactions
)
AND expiry_date <= DATE_ADD(
    (SELECT MAX(transaction_date) FROM transactions),
    INTERVAL 90 DAY
)
GROUP BY card_type
ORDER BY cards_nearing_expiry DESC;

-- Top 10 cards by outstanding balance

SELECT card_id,account_id,card_type,network,is_active,
    ROUND(credit_limit, 2) AS credit_limit,
    ROUND(outstanding_balance, 2) AS outstanding_balance,
    reward_points
FROM cards
ORDER BY outstanding_balance DESC
LIMIT 10;

-- Card balances by customer segment

SELECT
    c.segment,
    COUNT(cd.card_id) AS total_cards,
    ROUND(SUM(cd.credit_limit), 2) AS total_credit_limit,
    ROUND(SUM(cd.outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(cd.outstanding_balance), 2) AS average_outstanding
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN cards cd
    ON a.account_id = cd.account_id
GROUP BY c.segment
ORDER BY total_outstanding DESC;

-- Accounts with multiple cards

SELECT
    account_id,
    COUNT(*) AS total_cards,
    ROUND(SUM(credit_limit), 2) AS total_credit_limit,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding
FROM cards
GROUP BY account_id
HAVING COUNT(*) > 1
ORDER BY total_cards DESC, total_outstanding DESC;

