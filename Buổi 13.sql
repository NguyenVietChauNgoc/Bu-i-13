 EX1 
   SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
    SELECT company_id
    FROM job_listings
    GROUP BY company_id, title, description
    HAVING COUNT(*) > 1
) AS duplicates;
EX2
SELECT 
  category, 
  product, 
  total_spend 
FROM (
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
) AS ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking;
EX3 
SELECT 
    policy_holder_id,
    COUNT(case_id) AS call_count
FROM 
    callers
GROUP BY 
    policy_holder_id
HAVING 
    COUNT(case_id) >= 3;
EX5

WITH June_2022 AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_date >= '2022-06-01' AND event_date < '2022-07-01'
),
July_2022 AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_date >= '2022-07-01' AND event_date < '2022-08-01'
)
SELECT 
    7 AS month,
    COUNT(DISTINCT July_2022.user_id) AS monthly_active_users
FROM 
    July_2022
JOIN 
    June_2022 ON July_2022.user_id = June_2022.user_id;
EX6 
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    DATE_FORMAT(trans_date, '%Y-%m'), country;
EX7 
SELECT
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM
    Sales s
WHERE
    s.year = (
        SELECT MIN(year)
        FROM Sales s2
        WHERE s2.product_id = s.product_id
    );
EX8 
SELECT
    c.customer_id
FROM
    Customer c
GROUP BY
    c.customer_id
HAVING
    COUNT(DISTINCT c.product_key) = 
         (SELECT COUNT(*) FROM Product );
EX9 
SELECT DISTINCT e1.employee_id
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary < 30000
  AND e2.employee_id IS NULL
ORDER BY e1.employee_id;
EX11
 SELECT name AS results
FROM Users u
JOIN (
    SELECT user_id, COUNT(DISTINCT movie_id) AS num_ratings
    FROM MovieRating
    GROUP BY user_id
    ORDER BY num_ratings DESC, user_id ASC
    LIMIT 1
) mr ON u.user_id = mr.user_id;
EX12

SELECT person_id AS id, COUNT(*) AS num
FROM (
SELECT requester_id AS person_id FROM RequestAccepted
UNION ALL
SELECT accepter_id AS person_id FROM RequestAccepted
) AS all_persons
GROUP BY person_id
ORDER BY num DESC
LIMIT 1;

 

  



