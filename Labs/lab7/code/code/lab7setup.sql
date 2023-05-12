/***********************************/
/* PROJECT PROGRAM SCHEMA CREATION */
/*  put your personal schema first */
/*  and lab7 second in your        */
/*  search_path                    */
/***********************************/

SET search_path = dsaviela, lab7;

drop table if exists album cascade;
drop table if exists artist cascade;

create table artist (
	id serial PRIMARY KEY, 
	name text NOT NULL 
);

create table album (
	id serial PRIMARY KEY,
	artist_id integer REFERENCES artist(id),
	title text NOT NULL,
	year numeric(4)
);


/******************/
/* DATA MIGRATION */
/******************/

/* populate artist table */
insert into artist (name)
select distinct artist_name from musicbrainz;

/* populate album table */
insert into album (artist_id, title, year)
select distinct 
	a.id,
	m.album_title,
	m.album_year
from
	artist a,
	musicbrainz m
where a.name = m.artist_name;


