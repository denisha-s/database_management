/* Project 5 SQL Script */
/* Author: Denisha Saviela */

-- SET search_path = music;

/* 1. How many albums are classified as part of the jazz genre? */
SELECT COUNT(*)
FROM album_genre
WHERE genre IN 
    (SELECT DISTINCT genre
    FROM album a JOIN album_genre ag ON a.id = ag.album_id
    WHERE genre = 'jazz');

/* 2. In what year was the oldest album(s) in our data released? */
SELECT DISTINCT year
FROM album
WHERE year = 
    (SELECT MIN(year) 
    FROM album);

/* 3. How many artists are individuals (not a group)? */
SELECT COUNT(type)
FROM artist
WHERE type = 'Person';

/* 4. How many artists have names that are longer than 5 characters? */
SELECT COUNT(name)
FROM artist
WHERE length(name) > 5;

/* 5. For each album genre, how many albums are classified as part of that genre? Order from most to least albums in that genre. */
SELECT genre, COUNT(*)
FROM album_genre
GROUP BY genre
HAVING COUNT(*) >= 1
ORDER BY count DESC;

/* 6. Which albums have more than 20 tracks (in our data), and how many do they have? Order from most tracks to least tracks. If albums have the same number of tracks, put them in alphabetical order. */
SELECT a.title, COUNT(album_id) AS tracks
FROM track t JOIN album a
    ON t.album_id = a.id
GROUP BY a.title, t.album_id
HAVING COUNT(album_id) > 20
ORDER BY tracks DESC;

/* 7. Using only rows where the appropriate data isn't null, give an approximate average number of years that group members spend in a group. */
-- check this answer
SELECT AVG(end_year - begin_year) AS avg_years
FROM artist_member_xref
WHERE end_year IS NOT NULL AND begin_year IS NOT NULL;

/* 8. In what years were exactly 8 of the albums in our database released? */
-- check answer
SELECT year
FROM album
GROUP BY year
HAVING COUNT(id) = 8;

/* 9. What is the maximum number of members a group has in our data? */ 
SELECT MAX(members) 
FROM 
    (SELECT COUNT(type) AS members 
    FROM artist a, group_member g, artist_member_xref x
    WHERE a.id = x.artist_id 
        AND g.id = x.member_id
    GROUP BY a.id) 
AS result;

/* 10. What artist has the most recent album in our data, and what year was it released? */
SELECT name, year
FROM artist a, album b
WHERE a.id = b.artist_id
   AND b.year = 
        (SELECT MAX(year) 
        FROM album);

/* 11. What artists was Chris Thile part of? */
SELECT a.name 
FROM artist a
WHERE id IN 
    (SELECT x.artist_id
    FROM group_member g, artist_member_xref x
    WHERE g.id = x.member_id
        AND name = 'Chris Thile');

/* 12. What are the names of every member of the artist Foo Fighters, and what year did they enter the group? List them in order of least to most recent entry into the group. If they entered in the same year, put them in alphabetical order. */
SELECT name, begin_year
FROM group_member g JOIN artist_member_xref x ON g.id = x.member_id
WHERE id IN 
    (SELECT x.member_id
     FROM artist_member_xref x JOIN artist a ON a.id = x.artist_id
     WHERE a.name = 'Foo Fighters')
ORDER BY begin_year, name;

/* 13. Amy Ray is part of a group. Provide the title of the group's 2020 album, along with the name of the label that produced it. */
SELECT a.title AS album, l.name AS label, a.year
FROM album a JOIN label l ON a.label_id = l.id
WHERE year = 2020 AND artist_id = 
    (SELECT artist_id
     FROM artist_member_xref a JOIN group_member g ON a.member_id = g.id
     WHERE g.name = 'Amy Ray');

/* 14. Which artists had more than 10 albums produced by the same label? */
SELECT DISTINCT a.name
FROM album b JOIN artist a 
    ON b.artist_id = a.id
    JOIN label l ON l.id = b.label_id
GROUP BY l.id, a.name
HAVING COUNT (l.id) > 10;
