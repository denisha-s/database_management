-- OUTER JOIN
SET search_path = denisha, public, imdb;

-- contrast INNER join, LEFT/RIGHT/FULL outer join (ven diagram)

-- find courses that are not a prereq for other courses (cs_prereqs)
FROM cs_prereq cp1 RIGHT JOIN cs_prereq cp2
    ON cp1.prereq = cp2.course 
WHERE cp1.prereq IS NULL;
-- checking if one is null
-- outer join is expensive
  
-- find courses without instructors (mines_cs_courses, mines_cs_faculty)
-- instructor listed for course but not in fauclty table
SELECT couse_id
FROM mines_cs_courses c LEFT JOIN mines_cs_faculty f ON c.instructor = f.name 
WHERE f.name IS NULL;

-- find faculty without courses (mines_cs_courses, mines_cs_faculty)
SELECT f.name 
FROM mines_cs_faculty f LEFT JOIN mines_cs_courses c ON c.instructor = f.name
WHERE c.instructor IS NULL;

SELECT f.name
FROM mines_cs_courses c RIGHT JOIN mines_cs_faculty f ON c.instructor = f.name 
WHERE c.instructor IS NULL;

-- generate a list of all courses and faculty, showing course/faculty data together, but including *all* courses and *all* faculty, even courses without faculty and faculty without courses.
SELECT c.couse_id, c.instructor, f.name
FROM mines_cs_courses c FULL JOIN mines_cs_faculty f ON c.instructor = f.name 


-- limit yourself to only some movie genres (define a view)
-- choose from these:
SELECT DISTINCT genre 
FROM movie_genres;

-- find movies that are not those genres


-- What's the meaning of the query if we reverse the direction of the OJ(left<->right) ? (what needs to change besides the left/rightness?)


-- find actors that have acted in movies of genres beyond those


-- What's the meaning of the query if we reverse the direction of the OJ (left<->right)? (what needs to change besides the left/rightness?)

 
-- what's the meaning/what else do we need to change if we make it a full outer join?


