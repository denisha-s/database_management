-- 1: entities
CREATE TABLE team (
   name TEXT PRIMARY KEY
);

CREATE TABLE field (
  address TEXT PRIMARY KEY
);

-- 2: weak entities

-- member of relationship
CREATE TABLE player (
   team_name TEXT REFERENCES team(name),
   number INTEGER,
   name TEXT,
   PRIMARY KEY (team_name,number)
);

-- played on relationship
CREATE TABLE game (
   field_address TEXT REFERENCES field(address),
   date TIMESTAMP,
   sport TEXT,
   PRIMARY KEY(field_address, date)
);

-- 3: 1:1 relationships

ALTER TABLE team ADD COLUMN captain_number INTEGER;
ALTER TABLE team ADD FOREIGN KEY (name, captain_number) 
  REFERENCES player(team_name, number);

-- 4: 1:n relationships
-- none left to address

-- 5: n:m relationships

-- plays relationship
CREATE TABLE team_game_xref (
   team_name TEXT REFERENCES team(name),
   game_field_address TEXT,
   game_date TIMESTAMP,
   score INTEGER,
   FOREIGN KEY (game_field_address, game_date)
      REFERENCES game(field_address, date),
   PRIMARY KEY (team_name, game_field_address, game_date)
);

-- 6: n-ary relationships
-- we have none

-- 7: multi-valued attributes

CREATE TABLE field_sport (
   field_address TEXT REFERENCES field(address),
   sport TEXT,
   PRIMARY KEY (field_address, sport)
);

-- 8: derived attribute

CREATE VIEW game_derived AS
  SELECT game.*, date - NOW() AS days_until
  FROM game;


/*
WS 4

-- 1: entities

CREATE TABLE team (
name TEXT PRIMARY KEY
);

CREATE TABLE field (
address TEXT PRIMARY KEY
);


-- 2: weak enities

-- member of relationship
CREATBLE TABLE player (
   team_name TEXT REFERENCES team(name),
   number INTEGER,
   name TEXT,
   PRIMARY KEY (team_name, number)
 );
 
 -- played on relationship
 CREATE TABLE game(
    field_address TEXT REFERNCES field(address),
    date TIMESTAMP,
    sport TEXT,
    PRIMARY KEY(field_address, date)
 );
 

 -- 3: 1:1 relationship

 ALTER TABLE team ADD COLUMN captain_number INTEGER;
 ALTER TABLE team ADD FOREIGN KEY (name, captain_number)
   REFERENCES player(team_name, number);


--4: 1:n relationships
-- none left to address


-- 5: n:m relationship

CREATE TABLE team_game_xref(
    team_name TEXT REFERENCES team(name),
    game_field_address TEXT,
    game_date TIMESTAMP
    score INTEGER
    FOREIGN KEY (game_field_address, game_date)
        REFERENCES game(field_address, date),
    PRIMARY KEY (team_name, game_field_address, game_date)
);

-- 6: N-ARY relationships
-- none


-- 7: multi-valued attribute

CREATE TABLE field_sport(
    field_address TEXT REFERENCES field(address),
    sport TEXT,
    PRIMARY KEY (field_address, sport)
);


-- 8: derived attribute

CREATE VIEW game_derived AS 
    SELECT game.*, date - NOW() AS days_until
    FROM game;

============================================================

WS 5

1. headquarters

2. label->headquarters will move to seperate table

3. artist->type (2NF: whole key needs to be on left hand side)

4.
BCNF: entire key needs to be on the left (all 3 violates)
round 1:
choose artist -> tyoe
artist+ = { artist, type } --> closure
    artist -> artist
last 2 is not a subset of the closure set = done

X = { artist }
Y = artist+ = {artist, type}
Z = R - X - Y = { album, year, number, track }

R1 = X U Y = {artist, type}
artist -> type
key: artist (all non-key attributes depend on the entire key)
R1 is in BCNF

R2 = X U Z = {artist, album, year, number, track} --> is in 2NF
key: artist, album, year, number, track
artist, album -> year
album, year -> artist

R2 is not in BCNF
round 2:
decompose R2
FD: artist, album, -> year
{artist, album}+ = {artist, album, year}

X = { artist, album }
Y = {artist, album, year}
Z = R2 - X - Y = { number, track }

R3 = X U Y = {artist, album, year}
artist, album -> track
album, year -> artist
key1: artist, album
key2: album, year
(pick one as primary key and the other is unique constraint)

R4 = X U Z = {artist, album, number, track}
key: artist, album, number, track
artist, album, number track -> artist, album, number, track
R4 is BCNF

round 3? on R3
album, year -> artist
{album, year}+ = {album, year, artist}
can't break it down, so it has 2 keys

R -> R1, R3, R4

5. 
CREATE TABLE headquarter AS 
    SELECT lable, headquarters
    FROM music2
    WHERE headquarters NOT LIKE '%,%'; -- find rows without ,

INSERT INTO headquarters
    SELECT label, SUBSTR(headquarters, 1, POSITION(',', headquarters)-1)
    FROM music2
    WHERE headquarters LIKE '%,%';

INSERT INTO headquarters
    SELECT label, SUBSTR(headquarters, POSITION(',', headquarters)+1)
    FROM music2
    WHERE headquarters LIKE '%,%';

CREATE TABLE artist_type AS
    SELECT DISTINCT artist, type
    FROM music2

ALTER TABLE artist TYPE ADD PRIMARY KEY (artist)

CREATE TABLE music2a AS
    SELECT DISTINCT artist, album, year, lable, genre
    FROM music2;

ALTER TABLE music2a ADD PRIMARY KEY (artist, album, year, label)

*/
