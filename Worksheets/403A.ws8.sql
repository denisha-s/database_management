-- CSCI 403A WS 8

-- 1. Using tables in the practice schema, list those authors who have not won an author award using an outer join. (This could also be done with a subquery - but that’s not this worksheet’s topic...)

SELECT a.name 
FROM authors a LEFT OUTER JOIN authors_awards authors_awards
   ON a.author_id = aa.author_id
WHERE aa.author_id IS NULL;

SELECT a.name 
FROM authors a LEFT OUTER JOIN authors_awards authors_awards
   ON a.author_id = aa.author_id
WHERE aa.award_id IS NULL;

/*

2. Using the methods provided in class material, estimate and measure the current size of the table performance.temp_by_country. Include the # of rows per page.
a. # rows per page (give the calculation and the number)
                   Table "performance.temp_by_country"
        Column        |       Type       | Collation  | Nullable | Default 
----------------------+------------------+------------+----------+---------
 temp_date            | date             |    4       |          | 
 avg_temp             | double precision |    8       |          | 
 avg_temp_uncertainty | double precision |    8       |          | 
 country              | text             | 10 + 4 OH  |          | 

 8192 = 24 + R * (27 + 4 + 8 + 8 + 10 + 4)
 R = 133

b. Estimated # of pages (show your work; assume each page fills before the next is created)
SELECT ceil(COUNT(*)/133.0) FROM temp_by_country;
= 4342

c. Actual # pages (write and run the query - provide the query and the result here)
SELECT pg_relation_size('performance.temp_by_country')/8192;
= 4560

d. Now estimate the size of the table in 5 years; first, state how many new rows per year you expect, then the total table size in pages after 5 years of those increases on top of the current size.
rows per year: 243 * 12
SELECT ceil((COUNT(*) + 5 * 243 * 12)/133.0) FROM temp_by_country;
4452
*/

-- 3. Write the relational algebra version of this query:
SELECT temp_date, c.country
FROM temp_by_country t JOIN country_capital c ON t.country=c.country 
WHERE avg_temp > 25.5 AND capital = 'Harare';

/*
pi[temp_date,c.country]
(sigma[avg_temp > 25.5 AND capital = 'Harare']
((rho[t](temp_by_country)) JOIN[t.country=c.country] (rho[c](country_capital))))
*/
