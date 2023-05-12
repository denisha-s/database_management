/*
    Lab 3 - Uver ERD SQL script
    
    Name: Denisha Saviela
 */
 
-- set your search path to include your username and public, 
-- but *not* in this script.
-- SET search_path TO dsaviela, public

-- windows psql needs the following line uncommented
-- \encoding utf-8

-- add other environment changes here (pager, etc.)
-- \pset pager off

-- add the SQL for each step that needs SQL below that step here.
-- use the 8 steps defined in class (step 8 was covered only in class!)

/*
   Step 1: Regular entities
 */
 -- done
 CREATE TABLE customer(
   name TEXT UNIQUE,
   location_point POINT,
   location_address TEXT,
   phone VARCHAR(12) PRIMARY KEY
 );

 CREATE TABLE driver(
   name TEXT,
   phone VARCHAR(12) PRIMARY KEY,
   registration CHAR(10) UNIQUE
 );

CREATE TABLE car(
   license_plate CHAR(10) PRIMARY KEY,
   seats INTEGER
);

/*
   Step 2: Weak entities --check code
 */
 CREATE TABLE ride(
   customer_name TEXT REFERENCES customer(name),
   number_of_riders INTEGER,
   ride_type TEXT,
   distance TEXT,
   destination_point POINT,
   destination_address TEXT,
   fare NUMERIC(10,2),
   pickup_time TIMESTAMP,
   payment_method TEXT,
   payment_confirmation_number CHAR(11) UNIQUE,
   PRIMARY KEY (customer_name, pickup_time)
 );

/*
   Step 3: 1:1 Relationships
 */
 -- drives relationship
ALTER TABLE driver
   ADD COLUMN car_license_plate CHAR(10)
      REFERENCES car(license_plate);

/*
   Step 4: 1:N Relationships
 */
-- reserves relationship
ALTER TABLE car
  ADD COLUMN customer_phone VARCHAR(12)
    REFERENCES customer(phone);

/*
   Step 5: N:M Relationships
 */
 -- driver serves customer
CREATE TABLE customer_driver_xref(
   phone VARCHAR(12), 
   driver_phone VARCHAR(12) REFERENCES driver(phone),
   PRIMARY KEY (phone, driver_phone),
   FOREIGN KEY (phone)
    REFERENCES customer(phone)
);

/*
   Step 6: Multi-valued attributes
 */
 CREATE TABLE car_feature(
   car_license_plate TEXT,
   feature TEXT,
   PRIMARY KEY (car_license_plate, feature),
   FOREIGN KEY (car_license_plate)
   REFERENCES car(license_plate)
 );

/*
   Step 7: N-ary Relationships
 */

/*
   Step 8: Derived attributes
 */
 CREATE VIEW ride_plus AS 
  SELECT car_license_plate,
   number_of_riders,
   ride_type,
   distance,
   destination_address,
   fare,
   pickup_time,
   payment_method,
   payment_confirmation_number,
   destination_point<@>location_point AS destination_distance
  FROM ride r join customer c
    ON c.name = r.customer_name;