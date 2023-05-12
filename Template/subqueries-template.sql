-- CSCI 403 subquery examples

SET search_path TO subqueries;

-- Books by living authors
SELECT title, author
FROM books
WHERE author IN -- use for 1-coulmn table
    (SELECT name
    FROM authors
    WHERE death IS NULL);

-- Books by authors born after 1950
SELECT title, authors
FROM books
WHERE author IN
    (SELECT name
    FROM authors
    WHERE EXTRACT(year FROM birth) > 1950);

-- Books in the same genre as books I read
-- Genres of books I read:
SELECT DISTINCT genre 
FROM books b JOIN history h ON b.title = h.title;

SELECT title, genre 
FROM books 
WHERE genre IN 
    (SELECT DISTINCT genre 
    FROM books b JOIN history h ON b.title = h.title);

-- Books in the same genre as books I read but haven't read yet
SELECT title, genre 
FROM books 
WHERE genre IN 
        (SELECT DISTINCT genre 
        FROM books b JOIN history h ON b.title = h.title)
    AND NOT title IN (SELECT title FROM history);

-- How would you even do that with a join (inner)?


-- Posthumous books (books published after author died)
SELECT title, author 
FROM books b
WHERE publication_year > (SELECT EXTRACT(year FROM death)
        FROM authors a
        WHERE b.authors = a.name);
-- returns 1 row everytime

-- cf join:
SELECT title, author 
FROM books b JOIN authors a ON b.authors = an.name
WHERE publication_year > EXTRACT(year FROM death);

-- from grouping:
-- Who made the most sales in February, and how many sales did they make, for what total sum?
-- Maximum of a count
SET search_path = grouping;

SELECT salesperson, COUNT(*), SUM(amount)
FROM sales s
WHERE EXTRACT(month FROM order_date) = 2
GROUP BY salesperson
HAVING COUNT(*) =
    (SELECT MAX(count)
        FROM (SELECT COUNT(*) AS count FROM sales s2
            WHERE EXTRACT(month FROM order_date) = 2
            GROUP BY salesperson) x );

