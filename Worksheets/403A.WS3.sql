SET search_path = amelia;
-- Create a table with the name birds with the following column name and types:
-- name
-- TEXT
-- weight
-- INTEGER
-- date_spotted
-- DATE
DROP TABLE IF EXISTS birds;
CREATE TABLE birds (
       name TEXT,
       weight INTEGER,
       date_spotted DATE
);
-- 2. Provide the SQL statement(s) to insert the following values into the birds table; make the types of the values be the same as the types of the columns:
-- (Blue Jay, NULL, 02-MAY-99) , (Robin, 3, 03-JUNE-97) , (Larry, 220, 09-JUNE-78)
INSERT INTO birds VALUES
   ('Blue Jay', NULL, DATE'02-MAY-99'),
   ('Robin', 3, DATE'1997-06-03' ),
   ('Larry', 220, DATE'06-09-78' );

-- 3. Woah! there was an error in the birds table, apparently the row with “Larry” wasn't an actual bird. Provide the SQL to delete that row from the birds table.
DELETE FROM birds
WHERE name = 'Larry';

-- 4. Recent news just came in that Blue Jays weigh 7 units. Provide the SQL to update the birds table to reflect this revolutionary discovery.
SELECT name, weight, 7 AS new_weight
FROM birds
WHERE name = 'Blue Jay';

UPDATE birds
SET weight = 7
WHERE name = 'Blue Jay';

-- 5. Set up a PK-FK restricting birds to known birds!
-- a. Create a new table named bird_types that has one column, name, that is the primary key.
CREATE TABLE bird_types (
    name TEXT PRIMARY KEY
);
-- b. populate bird_types with the distinct birds listed in the birds table, and add one more bird to bird_types not yet in the birds table.
INSERT INTO bird_types
  SELECT DISTINCT name
  FROM birds
  WHERE name IS NOT NULL;

INSERT INTO bird_types VALUES ('Cockatoo');

-- c. create a foreign key from birds to bird_types, to ensure that only birds listed in bird_types can be used in birds.
ALTER TABLE birds ADD CONSTRAINT fkey_types 
  FOREIGN KEY (name) REFERENCES bird_types(name);

-- 6. (BONUS) provide the DROP statement(s) to remove bird and bird_type
DROP TABLE bird_types, birds;

-- could drop birds then bird_types in two statements
-- could drop bird_types first if you use CASCADE