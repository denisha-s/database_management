-- WS7 CSCI 403 A
SET search_path = practice;

-- 1. Using a subquery, write a query to list authors born after the death of author J.R.R. Tolkien.

SELECT * 
FROM authors
WHERE birth > (SELECT death
    FROM authors
    WHERE name = 'J.R.R. Tolkien');

-- 2. Write a query to find books by authors with only one book, given our available data. Hint: one way to write this is to use an aggregate in a subquery; another is to ask, for each book, whether there exist other books by the same author. BONUS: Write it both ways.

-- aggregate in SQ
SELECT title
FROM books
WHERE author_id IN 
    (SELECT DISTINCT author_id 
     FROM books
     GROUP BY author_id
     HAVING COUNT(books.title) = 1
    );

-- for each book, doesn't exist other books by the same author
SELECT title
FROM books b1
WHERE NOT EXISTS (SELECT 1
      FROM books b2 
      WHERE b1.author_id = b2.author_id
        AND b1.title <> b2.title);

-- 3. Using a set operation, list the authors that have won both an author award and a book award. Note: each side of the set operation does also require a JOIN: consider how to get from author names to author awards and to book awards.

  SELECT name
  FROM authors a JOIN authors_awards aa ON a.author_id = aa.author_id
INTERSECT
  SELECT name
  FROM authors a JOIN books b ON a.author_id = b.author_id
    JOIN books_awards ba ON b.book_id = ba.book_id;

WITH awarded_authors AS (
    SELECT author_id 
    FROM authors_awards
  INTERSECT
    SELECT author_id
    FROM books b 
    JOIN books_awards ba ON b.book_id = ba.book_id
)
SELECT name
  FROM authors a JOIN awarded_authors aa ON a.author_id = aa.author_id;


-- 4. Use a WITH to provide the number of books per author and then give as a result of the whole query the author’s name and their number of books, for all authors with more than one book, sorted by descending number.

WITH book_counts AS (
    SELECT COUNT(*) AS count, author_id
    FROM books
    GROUP BY author_id
)
WITH book_sums AS (
    SELECT SUM(1) AS count, author_id
    FROM books
    GROUP BY author_id
)
SELECT a.name, b.count
FROM authors a JOIN book_counts b ON a.author_id = b.author_id
WHERE b.count > 1
ORDER BY b.count DESC;

-- 5. List book, sale date, and price and provide the average book price for a particular date and the rank of each book for that date based on its price (cheapest first). Provide the result in date and rank order (ascending).

SELECT title, date_sold, price, AVG(price) OVER (PARTITION BY date_sold),
       RANK() OVER (PARTITION BY date_sold ORDER BY price)
FROM bookstore_inventory bi JOIN bookstore_sales bs
     ON bs.stock_number = bi.stock_number
ORDER BY date_sold;

SELECT title, date_sold, price, AVG(price) OVER (PARTITION BY date_sold),
       RANK() OVER (PARTITION BY date_sold ORDER BY price)
FROM bookstore_inventory bi JOIN bookstore_sales bs
     ON bs.stock_number = bi.stock_number
ORDER BY date_sold;