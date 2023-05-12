-- 403A WS 6
SET search_path TO practice;
-- 1. Write a query to count the number of books in the inventory by the author Margaret Atwood.
SELECT COUNT(*)
FROM bookstore_inventory
WHERE author = 'Margaret Atwood';

-- 2. Write a query to find out how many different authors have written books that are in the bookstore’s inventory.
SELECT COUNT(DISTINCT author)
FROM bookstore_inventory;

-- 3. Write a query to get the count, the average and the difference between the maximum and minimum price of a book for each possible book condition for the books in inventory.
SELECT condition, COUNT(*), AVG(price), SUM(price)/COUNT(price) AS average, MAX(price)-MIN(price) AS difference
FROM bookstore_inventory
GROUP BY condition;

-- 4. Propose a business question that you believe would take an aggregate and/or grouping operation to solve against the practice schema bookstore-related tables. Write it in English here:
-- What is the most expensive book by each author, from least to most expensive?

-- 5. Have your partner determine the answer to that business question with an SQL statement against the practice schema. Write their SQL statement here:
SELECT author, MAX(price)
FROM bookstore_inventory
GROUP BY author
ORDER BY 1;

SELECT title, author, price
FROM bookstore_inventory bi
WHERE price = 
  (SELECT MAX(price)
   FROM bookstore_inventory bi2
   WHERE bi2.author = bi.author)
ORDER BY author, title;

-- which author has the most titles
SELECT author, COUNT(*)
FROM bookstore_inventory
GROUP BY author
ORDER BY COUNT(*) DESC
LIMIT 5;

SELECT MAX(count)
FROM (SELECT author, COUNT(*) AS count
      FROM bookstore_inventory
      GROUP BY author) author_counts;

SELECT author, COUNT(*)
FROM bookstore_inventory
GROUP BY author
HAVING COUNT(*) = (SELECT MAX(count)
                   FROM (SELECT author, COUNT(*) AS count
                        FROM bookstore_inventory
                         GROUP BY author) author_counts);

