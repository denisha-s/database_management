/*
    CSCI 403 Lab 2: Schedule
    
    Name: Denisha Saviela
*/

-- do not put SET SEARCH_PATH in this file
-- add your statements after the appropriate Step item
-- it's fine to add additional comments as well

/* Step 1: Create the table */
CREATE TABLE schedule (
    department text,
    course numeric(3),            
    title text NOT NULL,
    credits numeric(3,1) NOT NULL,
    semester text CHECK (semester IN ( 'Spring', 'Fall', 'Summer')),
    year int DEFAULT EXTRACT('Year' FROM CURRENT_DATE),
    PRIMARY KEY (department, course));

/* Step 2: Insert the data */ -- check case statement
INSERT INTO schedule
    SELECT department, course_number, course_title, semester_hours,
        CASE 
            WHEN spring = 'True' THEN 'Spring'
            ELSE 'Spring'
        END
    FROM cs_courses
    WHERE 
        course_number IN (303, 306, 403, 406);

INSERT INTO schedule VALUES ('MATH', 201, 'INTRO TO STATISTICS', 3.0, 'Spring');

/* Step 3: Fix errors */ 
UPDATE schedule
SET semester = 'Spring'
WHERE IS NULL;

UPDATE schedule
SET title = 'DATABASE MANAGEMENT'
WHERE course = 403;

/* Step 4: Add more constraints */
ALTER TABLE schedule
ADD CONSTRAINT title_unique UNIQUE (title);

ALTER TABLE schedule
ADD CONSTRAINT credits_check
CHECK (credits BETWEEN 0.5 AND 15);

/* Step 5: Create another table */
CREATE TABLE assumed_grades (
    term text,
    year int DEFAULT EXTRACT('Year' FROM CURRENT_DATE),
    department text,
    course numeric(3),
    title text,
    grade char(3),
    credits numeric(3,1));

    ALTER TABLE assumed_grades                                       
    ADD CONSTRAINT  grades_schedule_fkey
        FOREIGN KEY (department, course) REFERENCES schedule(department, course);

/* Step 6: Add the data */
INSERT INTO assumed_grades (term, year, department, course, title, credits)
    SELECT sh.semester, sh.year, sh.department, sh.course, sh.title, sh.credits
    FROM schedule sh;

/* Step 7: Enter grades */
UPDATE assumed_grades
SET grade = 'A'
WHERE course = 303;

UPDATE assumed_grades
SET grade = 'B'
WHERE course = 306;

UPDATE assumed_grades
SET grade = 'A'
WHERE course = 406;

UPDATE assumed_grades
SET grade = 'A'
WHERE course = 403;

UPDATE assumed_grades
SET grade = 'A'
WHERE course = 201;

/* Step 8: cleaning up the table */
ALTER TABLE assumed_grades
RENAME COLUMN term TO semester;

/* Step 9 (Extra Credit): Play */

/* Step 10: Make a new table by copying */
CREATE TABLE transcript AS (
    SELECT * 
    FROM assumed_grades
    WHERE course IN (303, 306, 403, 406, 201));

ALTER TABLE transcript                                       
    ADD CONSTRAINT  grades_schedule_fkey
        FOREIGN KEY (department, course) REFERENCES schedule(department, course);

UPDATE transcript
SET grade = 'A+'
WHERE course = 403;

/* Step 11 (Extra Credit): Re-examining the schema */
ALTER TABLE assumed_grades
    DROP CONSTRAINT grades_schedule_fkey;

ALTER TABLE schedule
    DROP CONSTRAINT schedule_pkey CASCADE;

ALTER TABLE schedule
    ADD CONSTRAINT schedule_fkey
        PRIMARY KEY (department, course, semester, year);

ALTER TABLE assumed_grades
    ADD CONSTRAINT assumed_grades_fkey
        FOREIGN KEY (department, course, semester, year) REFERENCEs schedule (department, course, semester, year);

INSERT INTO schedule
    SELECT department, course_number, course_title, semester_hours,
        CASE 
            WHEN spring = 'True' THEN 'Spring'
            ELSE 'Spring'
        END
    FROM cs_courses
    WHERE 
        course_number IN (400);

INSERT INTO schedule VALUES ('MATH', 335, 'INTRO MATHEMATICAL STATISTICS', 3.0, 'Spring');
