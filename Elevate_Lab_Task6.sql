SET datestyle = 'MDY';
COPY orders FROM 'C:\Program Files\PostgreSQL\17\Amazon_Sales.csv'
DELIMITER ',' CSV HEADER;

SELECT COUNT(*) FROM orders;
SELECT * FROM orders LIMIT 10;

ALTER TABLE orders ADD COLUMN order_date_final DATE;

UPDATE orders
SET order_date_final = TO_DATE(order_date, 'MM-DD-YY');

SELECT
    EXTRACT(YEAR FROM order_date_final) AS order_year,
    EXTRACT(MONTH FROM order_date_final) AS order_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

SELECT
    order_year,
    order_month,
    total_revenue
FROM (
    SELECT
        EXTRACT(YEAR FROM order_date_final) AS order_year,
        EXTRACT(MONTH FROM order_date_final) AS order_month,
        SUM(amount) AS total_revenue
    FROM orders
    GROUP BY order_year, order_month
) sub
ORDER BY total_revenue DESC
LIMIT 3;

SELECT
    EXTRACT(YEAR FROM order_date_final) AS order_year,
    EXTRACT(MONTH FROM order_date_final) AS order_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM orders
WHERE EXTRACT(YEAR FROM order_date_final) = 2022
GROUP BY order_year, order_month
ORDER BY order_month;

SELECT
    EXTRACT(YEAR FROM order_date_final) AS order_year,
    EXTRACT(MONTH FROM order_date_final) AS order_month,
    SUM(COALESCE(amount, 0)) AS total_revenue
FROM orders
GROUP BY order_year, order_month;
