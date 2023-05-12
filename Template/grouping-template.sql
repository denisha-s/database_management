-- queries using aggregates, GROUP BY, HAVING
SET search_path = grouping;
--\d

-- How many sales did we make in the first quarter?
SELECT COUNT(*)
FROM sales
WHERE EXTRACT(quarter FROM order_date) = 1;
--quarter = 1, 2, 3, 4

-- From here on we'll assume we only have data for the first quarter (which is true).

-- How much did we actually bring in (revenue)?
-- use SUM from amount where it has been paid
SELECT SUM(amount), EXTRACT(quarter FROM order_date) -- SUM(amount) only includes not null
FROM sales
WHERE status = 'paid';
GROUP BY EXTRACT(quarter FROM order_date);

-- How much did we sell each month?
-- how much in process or paid = non-cancelled sales
SELECT EXTRACT(month FROM order_date) AS order_month, COUNT(*)
FROM sales
WHERE status <> 'canceled'
GROUP BY order_month
ORDER BY order_month;

-- How about actual revenue by month?  (Where does the WHERE clause fit in?)
SELECT EXTRACT(month FROM order_date) AS order_month, SUM(amount), COUNT(*)
FROM sales
WHERE status = 'paid' -- dropped status in process
GROUP BY order_month
ORDER BY order_month;

-- How many sales did each person make in the quarter, ranked by count?
SELECT salesperson, COUNT(order_number)
FROM sales
-- WHERE not needed, looking at all work by salespeople
GROUP BY salesperson
ORDER BY COUNT(order_number) DESC; -- most to least
-- data is from whole quarter

SELECT salesperson, EXTRACT(month FROM order_date) AS order_month, COUNT(order_number)
    COUNT(CASE WHEN status <> 'canceled' THEN 1 ELSE NULL END)
FROM sales
-- WHERE not needed, looking at all work by salespeople
GROUP BY salesperson, order_month
ORDER BY order_month, COUNT(order_number) DESC; -- most to least

-- How about revenue by person, ranked by revenue?
SELECT salesperson, COUNT(order_number), SUM(amount) AS revenue
FROM sales
WHERE status = 'paid'
GROUP BY salesperson
ORDER BY revenue DESC;

-- How did each salesperson do (sale amount) each month?
-- Consider an appropriate sort order
SELECT salesperson, EXTRACT(month FROM order_date) AS order_month, COUNT(order_number) AS tot_orders, SUM(amount) AS tot_revenue
FROM sales
WHERE status = 'paid'
GROUP BY salesperson, order_month
ORDER BY order_month, tot_revenue DESC;

-- by decreasing revenue to see if month stands out
SELECT salesperson, EXTRACT(month FROM order_date) AS order_month, COUNT(order_number) AS tot_orders, SUM(amount) AS tot_revenue
FROM sales
WHERE status = 'paid'
GROUP BY salesperson, order_month
ORDER BY tot_revenue DESC;

-- Who are our best customers?  (Find sales by customer, ordered by sales descending)
-- best: spends the most money (status = 'paid')
SELECT customer, SUM(amount) AS sales
FROM sales
WHERE status = 'paid'
GROUP BY customer
ORDER BY sales DESC;

-- Anybody who makes sales in an amount at least 70,000 in a given month receives a bonus.  Who gets bonuses each month?
SELECT salesperson, EXTRACT(month FROM order_date) AS order_month, COUNT(order_number) AS tot_orders, SUM(amount) AS tot_revenue
FROM sales
WHERE status = 'paid'
GROUP BY salesperson, order_month
HAVING SUM(amount) >= 70000
ORDER BY order_month, tot_revenue DESC;

-- How about just in January?
SELECT salesperson, EXTRACT(month FROM order_date) AS order_month, COUNT(order_number) AS tot_orders, SUM(amount) AS tot_revenue
FROM sales
WHERE status = 'paid' AND EXTRACT(month FROM order_date) = 1
GROUP BY salesperson, order_month
HAVING SUM(amount) >= 70000
ORDER BY order_month, tot_revenue DESC;
-- remove order_month grouping since only one value


-- Who made the most sales in February, and how many sales did they make, for what total sum? (requires a subquery, coming next)


-- We can make it a bit cleaner using a WITH query (CTE), which acts like a temporary view we can use for just this one query:



