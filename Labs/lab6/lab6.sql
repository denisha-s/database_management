/* 
    lab6.sql 
    Author: Denisha Saviela
    
 */

/***********/
/* Stage 1 */
/***********/

DROP TABLE IF EXISTS uber_report;

-- add your statements here to create and load uber_report
CREATE TABLE uber_report (
    distance NUMERIC(3,2),
    time_stamp TIMESTAMP,
    destination TEXT,
    source TEXT,
    price NUMERIC(4,2),
    surge_multiplier NUMERIC(3,2),
    name TEXT,
    id INTEGER PRIMARY KEY
);

\copy uber_report FROM 'uber_report.csv' WITH (FORMAT csv, HEADER true);

-- sanity-check the data and shape of the table
\d uber_report

SELECT * FROM uber_report LIMIT 5;

SELECT COUNT(*) FROM uber_report;



DROP TABLE IF EXISTS weather_report;

-- add your statements here to create and load weather_report
CREATE TABLE weather_report (
    temp NUMERIC(4,2),
    location TEXT,
    clouds NUMERIC(3,2),
    pressure NUMERIC(6,2),
    rain NUMERIC(5,4),
    time_stamp TIMESTAMP,
    humidity NUMERIC(3,2),
    wind NUMERIC(4,2),
    PRIMARY KEY(location, time_stamp)
);

\copy weather_report FROM 'weather_report.csv' WITH (FORMAT csv, HEADER true);

-- sanity-check the data and shape of the table
\d weather_report

SELECT * FROM weather_report LIMIT 5;

SELECT COUNT(*) FROM weather_report;

/***********/
/* Stage 2 */
/***********/

-- 2.1 is captured in lab6.pdf, not this script 

-- 2.2

EXPLAIN ANALYZE
SELECT DISTINCT id, source, destination
FROM uber_report ur, weather_report wr
WHERE source = location AND rain > 0.09
 AND date(wr.time_stamp) = date(ur.time_stamp);


-- capture screen shot and explanations in lab6.pdf

-- 2.3

-- put your CREATE INDEX statement(s) here:
CREATE INDEX weather_report_idx ON weather_report(location, time_stamp);
CREATE INDEX uber_report_idx ON uber_report(source);


EXPLAIN ANALYZE
SELECT DISTINCT id, source, destination
FROM uber_report ur, weather_report wr
WHERE source = location AND rain > 0.09
AND date(wr.time_stamp) = date(ur.time_stamp);

-- capture screen shot and explanations in lab6.pdf

-- 2.4

-- put your altered SQL statement here inside EXPLAIN (without ANALYZE!):
EXPLAIN 
SELECT DISTINCT ur.id, ur.source, ur.destination
FROM uber_report ur
WHERE EXISTS (
  SELECT 1
  FROM weather_report wr
  WHERE ur.source = wr.location
    AND wr.rain > 0.09
    AND date(wr.time_stamp) = date(ur.time_stamp)
);


-- capture screen shot and explanations in lab6.pdf

