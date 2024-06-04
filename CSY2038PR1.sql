--/Users/elizabethamponsah/Documents/DATABASES 2/CSY2038PR1.sql
-- CSY2038_127@student/CSY2038_127
/*
COLUMN object_name FORMAT A30;

COLUMN object_type FORMAT A12;

PURGE RECYCLEBIN;

SELECT object_name, object_type FROM user_objects;

*/
---drops


-- DROPING TRIGGERS

DROP TRIGGER tri_dob_ck;
-- DROPING PROCEDURES AND FUNCTION

drop PROCEDURE proc_param_fun_ct;
drop FUNCTION fun_param_country_ct;

DROP PROCEDURE proc_fun;
DROP FUNCTION fun_country_ct;

DROP PROCEDURE proc_occasion;
DROP PROCEDURE proc_param;
        -- DROPPING foreign key AND PRIMARY KEY constraints

        ALTER TABLE occasions
        drop CONSTRAINTS fk_o_sites;


        ALTER TABLE occasions
        drop CONSTRAINTS fk_o_staff;

        ALTER TABLE sites
        drop CONSTRAINTS pk_sites;

        ALTER TABLE staff
        drop CONSTRAINTS pk_staff;

        ALTER TABLE occasions
        drop CONSTRAINTS pk_occasions;



drop table staff;
drop table occasions;
drop table sites;
drop table addresses;
drop type address_type;
drop type accomodation_table_type;
drop type accomodation_type;
drop type social_media_varray_type;
drop type social_media_type;

purge recyclebin;



-- querying object types and tables 
SELECT object_name, object_type FROM user_objects;

-- creating tables

-- creating object tables
CREATE OR REPLACE TYPE address_type AS object (
    street VARCHAR2(40),
    postcode VARCHAR2(10),
    city VARCHAR2(40),
    country VARCHAR2 (40));
    /


--create table to reference object table
CREATE TABLE addresses OF address_type;


-- create tables
CREATE TABLE sites (
    site_id NUMBER(6),
    site_name VARCHAR2(50),
    address address_type);


CREATE TABLE occasions (
    occasion_id NUMBER(6),
    site_id NUMBER(6),
    occasion_type VARCHAR2(50),
    occasion_name VARCHAR2(50),
    staff_id NUMBER(6));


-- create varray types and tables

CREATE OR REPLACE TYPE social_media_type AS OBJECT (
    media_name VARCHAR2(40),
    username VARCHAR2(50));
    /

    CREATE TYPE social_media_varray_type AS VARRAY(100) OF social_media_type;
    /


    -- creating nested object table and types
CREATE OR REPLACE TYPE accomodation_type AS OBJECT (
    building_name VARCHAR2(30),
    room_number NUMBER(10),
    price NUMBER (5,2),
    room_type VARCHAR2(30));
    /

    CREATE TYPE accomodation_table_type AS TABLE OF accomodation_type;
    /


    CREATE TABLE staff (
        staff_id NUMBER(6),
        firstname VARCHAR2(20),
        surname VARCHAR2(30),
        email VARCHAR2(100),
        contact_number VARCHAR2(15),
        social_media social_media_varray_type,
        date_of_birth DATE,
        address REF address_type SCOPE IS addresses,
        accomodation accomodation_table_type)
        NESTED TABLE accomodation STORE AS accomodation_table;

        --defining UDTS
        -- adding primary key constraints

        ALTER TABLE sites
        ADD CONSTRAINTS pk_sites
        PRIMARY KEY (site_id);

        ALTER TABLE staff
        ADD CONSTRAINTS pk_staff
        PRIMARY KEY (staff_id);

        ALTER TABLE occasions
        ADD CONSTRAINTS pk_occasions
        PRIMARY KEY (occasion_id);


        -- adding foreign key constraints

        ALTER TABLE occasions
        ADD CONSTRAINTS fk_o_sites
        FOREIGN KEY (site_id)
        REFERENCES sites(site_id);

        ALTER TABLE occasions
        ADD CONSTRAINTS fk_o_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id);








--INSERTS for addresses table
 
INSERT INTO addresses (street, postcode, city, country)
VALUES ('38 ROSEWOOD STREET', 'NN1 2BR', 'NORTHAMPTON', 'UNITED KINGDOM');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('326 BURLEY ROAD', 'LS4 2NZ', 'LEEDS', 'UNITED KINGDOM');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('LINLEY COTTAGE', 'NR15 2EW', 'ASLACTON', 'UNITED KINGDOM');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('4 POPLARS LANE', 'TS21 1QE', 'CARLTON', 'UNITED STATES');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('1 HIRSTWOORD STREET', 'HX6 4BN', 'RIPPONDEN', 'UNITED KINGDOM');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('38 CRISPIN WAY', 'SL2 3UE', 'FARNHAM COMMON', 'UNITED KINGDOM');

INSERT INTO addresses (street, postcode, city, country)
VALUES ('7 CLIFFORD STREET', 'BD23 2AD', 'SKIPTON', 'UNITED KINGDOM');


-- INSERTS for sites

INSERT INTO sites (site_id, site_name, address)
VALUES (52386, 'CHURCH HALL',
  address_type('27 WOOD LANE', 'SL3 9BS', 'WINDSOR', 'UNITED KINGDOM'));

INSERT INTO sites (site_id, site_name, address)
VALUES (52387, 'THE COUNTRY CLUB', 
    address_type ('12 TRAFALGAR LANE', 'SL4 1AA', 'WINDSOR', 'UNITED KINGDOM'));

INSERT INTO sites (site_id, site_name, address)
VALUES (52388, 'ALEXANDRA PARK', 
    address_type ('23 PARK DRIVE', 'SL4 1AE', 'WINDSOR', 'UNITED KINGDOM'));

INSERT INTO sites (site_id, site_name, address)
VALUES (52389, 'THE OVAL HALL', 
address_type ('35 STAINSBOROUGH ROAD', 'SL3 1AT', 'WINDSOR', 'UNITED KINGDOM'));


INSERT INTO sites (site_id, site_name, address)
VALUES (52390, 'TRENT HALL', 
    address_type ('22 WEST LAUGHTON LANE', 'SL4 1BN', 'WINDSOR', 'UNITED KINGDOM'));

INSERT INTO sites (site_id, site_name, address)
VALUES (52391, 'LEA VALLEY CENTRE',
    address_type ('33 ST ALBANS ROAD', 'SL4 1AZ', 'WINDSOR', 'UNITED KINGDOM'));






--INSERTS INTO STAFF TABLE


INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28224, 'LINDA', 'BURLOUGH', 'LINDBURLS@GMAIL.COM', '07700900134', '13-MAR-1980',
social_media_varray_type(
    social_media_type('TWITTER','LINDAB12'),
    social_media_type('INSTAGRAM','LINDABURLS'),
    social_media_type('SNAPCHAT','CALLMELINDA')),
accomodation_table_type(
    accomodation_type('ROSE HOTEL', 24, '89.99', 'DOUBLE'),
    accomodation_type('MOORLEYS STAY',10,'50.00','SINGLE')),
REF(a)
FROM addresses a
WHERE postcode = 'NN1 2BR';


INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28225,'DEAN ','LOVELACE', 'DEANLOVELACE@HOTMAIL.COM', '01614960579', '10-DEC-1999',
social_media_varray_type(
    social_media_type('TWITTER','DEAN101'),
    social_media_type('INSTAGRAM','DEAN1011'),
    social_media_type('SNAPCHAT','ITSMEDEAN')),
accomodation_table_type(
    accomodation_type('ROSE HOTEL',70,'99.99','KING'),
    accomodation_type('CAVE STAY',11,'112.99','MASTER')),
REF(a)
FROM addresses a
WHERE postcode = 'LS4 2NZ';




INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28226,'JORDAN','SMALL', 'JORDSMALL@AOL.CO.UK', '01184960814', '23-APR-2000',
social_media_varray_type(
    social_media_type('TWITTER','JORDSLDN'),
    social_media_type('INSTAGRAM','JORDSLDNX'),
    social_media_type('SNAPCHAT','JORDSLDNOX')),
accomodation_table_type(
    accomodation_type('CAVE STAY',33,'89.99','QUEENS'),
    accomodation_type('PREMIER LODGE',20,'39.99','SMALL')),
REF(a)
FROM addresses a
WHERE postcode = 'NR15 2EW';




INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28227,'DAVINA','AGYEMAN', 'DAVAGY@HOTMAIL.COM', '07700900245', '23-JAN-1990',
social_media_varray_type(
    social_media_type('TWITTER','SIMPLYDAVS'),
    social_media_type('INSTAGRAM','SIMPLYYDAVS'),
    social_media_type('SNAPCHAT','DAVSSXOX')),
accomodation_table_type(
    accomodation_type('ROSE HOTEL',23,'79.99','QUEENS'),
    accomodation_type('CAVE STAY',40,'89.99','QUEENS')),
REF(a)
FROM addresses a
WHERE postcode = 'TS21 1QE';



INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28228,'TYLAH','BROWN', 'TYLAHBROWN@AOL.COM', '07700900451', '24-DEC-2001',
social_media_varray_type(
    social_media_type('TWITTER','TYBROWNX'),
    social_media_type('INSTAGRAM','TYBROWNXX'),
    social_media_type('SNAPCHAT','TYLAHBXX')),
accomodation_table_type(
    accomodation_type('CAVE STAY',76,'112.99','MASTER'),
    accomodation_type('PREMIER LODGE',30,'50.99','STUDIO')),
REF(a)
FROM addresses a
WHERE postcode = 'HX6 4BN';



INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28229,'RUI','FERNANDO', 'RUIFERNDS@MSN.CO.UK', '07700900933', '30-DEC-1989',
social_media_varray_type(
    social_media_type('TWITTER','ROOSWORLD'),
    social_media_type('INSTAGRAM','RUIFERNS'),
    social_media_type('SNAPCHAT','RUIFERNSLDN')),
accomodation_table_type(
    accomodation_type('MOORLEYS STAY',54,'69.99','DOUBLE'),
    accomodation_type('ROSE HOTEL',25,'89.99','DOUBLE')),
REF(a)
FROM addresses a
WHERE postcode = 'SL2 3UE';

INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28230,'RODENY','WALKER','RODWEAVES@YAHOO.CO.UK','07700900236','02-FEB-2002',
social_media_varray_type(
    social_media_type('TWITTER','RODSWORLD'),
    social_media_type('INSTAGRAM','RODROCKS'),
    social_media_type('SNAPCHAT','RODLDN')),
accomodation_table_type(
    accomodation_type('MOORLEYS STAY',89,'69.99','DOUBLE'),
    accomodation_type('ROSE HOTEL',39,'89.99','DOUBLE')),
REF(a)
FROM addresses a
WHERE postcode = 'SL2 3UE';

--INSERTS for the occasions table


INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04662, 52386, 'WEDDING', 'ALVAREZ AT LAST', 28224);

INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04663, 52387, 'GOLF', 'THE ANNUAL TRENT GOLF EVENT', 28225);

INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04664, 52388, 'CIRCUS', 'WALDOS CIRCUS OF MAGIC', 28226);

INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04665, 52389, 'CONCERT', 'THE FIREFLIES', 28227);

INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04666, 52390, 'CAR SHOWRROM', 'TOP DOGS ANNUAL SHOWROOM', 28228);

INSERT INTO occasions (occasion_id, site_id, occasion_type, occasion_name, staff_id)
VALUES (04667, 52391, 'OUTDOOR ACTIVITIES', 'THE ANNUAL PADDLE EVENT', 28229);









-- REMEMBER TO ALTER ACCOMODATION ROOM_NAME TO BUILDING_NAME

--commit;

--QUERIES


--basic form of queries

SELECT site_id, site_name, address
FROM sites s;

SELECT occasion_id, site_id, occasion_type, occasion_name, staff_id
FROM occasions o;

-- basic form of query with Restriction: WHERE CLAUSE

SELECT site_id, site_name, address
FROM sites s
WHERE site_name = 'LEA VALLEY CENTRE';

SELECT occasion_id, site_id, occasion_type, occasion_name, staff_id
FROM occasions o 
WHERE occasion_name = 'THE ANNUAL TRENT GOLF EVENT';

--Querying object tables using standard syntax

SELECT street, postcode, city, country 
FROM addresses;
  
-- Querying a reference from object table
SELECT REF(a), street, postcode, city, country 
FROM addresses a
WHERE street = '326 BURLEY ROAD';

SELECT REF (a), street, postcode, city, country 
FROM addresses a
WHERE city = 'LEEDS';

-- Querying object columns
SELECT site_id, site_name, address
FROM sites;

--Querying using dot notation
SELECT s.address.street, s.address.postcode 
FROM sites s;



-- Querying tables with ref columns 
SELECT site_id, site_name, address
FROM sites;

-- Querying using DREF
SELECT staff_id, DEREF(address)
FROM staff;

-- querying with a VARRAY using standard syntax
SELECT social_media FROM staff;

--querying a VARRAY using an un-nested query
SELECT s.staff_id, s.media_name, s.username
FROM staff s, 
TABLE (s.social_media)s
WHERE staff_id = 28229;

-- querying a nested table standard syntax

SELECT accomodation FROM staff;

-- querying nesting table only

SELECT VALUE(s)
    FROM THE(
    SELECT accomodation
    FROM staff
    WHERE staff_id = 28229)s;




-- querying using cartesian - omitting the join clause


SELECT s.staff_id, s.firstname, s.surname, o.occasion_id, o.occasion_name
FROM staff s, occasions o;

-- querying using compound inner joins to join first name from staff via site id from occasions table onto site name from sites table
SELECT firstname, site_name
FROM occasions
JOIN sites
ON occasions.site_id = sites.site_id
JOIN staff
ON occasions.staff_id = staff.staff_id;


-- querying using outer joins

SELECT s.staff_id, o.occasion_name, occasion_type
FROM occasions o 
LEFT JOIN staff s
ON s.staff_id = o.staff_id;

--  querying full outer joim

SELECT s.firstname, s.surname, o.occasion_name
FROM staff s
FULL OUTER JOIN occasions o
ON s.staff_id = o.staff_id;


--querying with nested queries

SELECT staff_id, firstname, surname
FROM staff
WHERE staff_id IN(
    SELECT staff_id
    FROM occasions);


-- procedures, functions, triggers, testing

SET SERVEROUTPUT ON

--procedures - inserts a new row into the id table for occasions

CREATE OR REPLACE PROCEDURE proc_occasion IS
vc_occasion_type occasions.occasion_type%TYPE:= 'WEDDING';

BEGIN

INSERT INTO occasions (occasion_id, occasion_type)
VALUES(04670,vc_occasion_type);

END proc_occasion;
/

SHOW ERRORS;


exec proc_occasion

--




-- procedure with parameters, displays specific staff names via staff id whilst sub stringed to a string hello
CREATE OR REPLACE PROCEDURE proc_param 
            (in_staff_id IN staff.staff_id%TYPE) IS
            vc_firstname staff.firstname%TYPE;
            vc_surname staff.surname%TYPE;


BEGIN
    SELECT firstname, surname
    INTO vc_firstname, vc_surname
    FROM staff
    WHERE staff_id = in_staff_id;

DBMS_OUTPUT.PUT_LINE('HELLO ' || vc_firstname || ' ' || vc_surname);


END proc_param;
/

SHOW ERRORS

execute proc_param(28229);


--FUNCTION TO COUNT HOW MANY PEOPLE ARE ASSOCIATED TO THE UNITED STATES

SET SERVEROUTPUT ON



CREATE OR REPLACE FUNCTION fun_country_ct
RETURN NUMBER IS

vn_country_ct NUMBER(3);

BEGIN

SELECT COUNT(*)
INTO vn_country_ct
FROM addresses
WHERE country = 'UNITED STATES';

RETURN vn_country_ct;

END fun_country_ct;
/

show ERRORS

CREATE OR REPLACE PROCEDURE proc_fun IS
vn_num_of_country_ct NUMBER(3);
BEGIN
vn_num_of_country_ct := fun_country_ct;

DBMS_OUTPUT.PUT_LINE('There are ' || vn_num_of_country_ct || ' person(s) that are in the UNITED STATES');


END proc_fun;
/

show ERRORS

exec proc_fun;


--- 








-- THIS FUNCTION DISPLAYS HOW MANY PEOPLE ARE ASSOCIATED TO A PARTIAL PART OF A POSTCODE


SET SERVEROUTPUT ON



CREATE OR REPLACE FUNCTION fun_param_country_ct (in_site_name sites.site_name%TYPE)
RETURN NUMBER IS

vn_postcode_ct NUMBER(3);

BEGIN

SELECT COUNT(*)
INTO vn_postcode_ct
FROM sites s
WHERE s.address.postcode LIKE 'SL3%';

RETURN vn_postcode_ct;

END fun_param_country_ct;
/

show ERRORS


CREATE OR REPLACE PROCEDURE proc_param_fun_ct (in_site_name sites.site_name%TYPE)IS
vn_no_of_postcode NUMBER(3);
BEGIN
vn_no_of_postcode := fun_param_country_ct(in_site_name);

DBMS_OUTPUT.PUT_LINE('There are ' || vn_no_of_postcode || ' sites that are in the SL3 postcode area');


END proc_param_fun_ct;
/


exec proc_param_fun_ct('CHURCH HALL');



-- TRIGGERS
-- trigger to find staff members age and stating whether or not they are underage
CREATE OR REPLACE TRIGGER tri_dob_ck
BEFORE INSERT OR UPDATE OF date_of_birth ON staff
FOR EACH ROW 
WHEN(NEW.date_of_birth IS NOT NULL)


DECLARE
vn_dob NUMBER(2);

BEGIN
vn_dob:= MONTHS_BETWEEN(SYSDATE, :NEW.date_of_birth)/12;

IF vn_dob < 18
THEN DBMS_OUTPUT.PUT_LINE('THIS STAFF MEMBER IS UNDERAGE, AGE IS ' || vn_dob);
ELSE DBMS_OUTPUT.PUT_LINE('THIS STAFF MEMBER IS OF AGE, AGE IS ' || vn_dob);
END IF;

END tri_dob_ck;
/



--TEST

--TRIGGER TEST

--BAD EXAMPLE. Can't test triggers that data already exist

INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28224, 'SAM', 'SMITH', 'SSMITH@GMAIL.COM', '07700900134', '13-MAR-1980',
social_media_varray_type(
    social_media_type('TWITTER','SAMSMITH101'),
    social_media_type('INSTAGRAM','SAMMITH101'),
    social_media_type('SNAPCHAT','SMITHSAM101')),
accomodation_table_type(
    accomodation_type('ROSE HOTEL', 24, '89.99', 'DOUBLE'),
    accomodation_type('MOORLEYS STAY',10,'50.00','SINGLE')),
REF(a)
FROM addresses a
WHERE postcode = 'NN1 2BR';




--GOOD EXAMPLE shows if the staff member is of age or not

INSERT INTO staff (staff_id, firstname, surname, email, contact_number, date_of_birth, social_media, accomodation, address)
SELECT 28270, 'SAM', 'SMITH', 'SSMITH@GMAIL.COM', '07700900134', '13-MAR-1980',
social_media_varray_type(
    social_media_type('TWITTER','SAMSMITH101'),
    social_media_type('INSTAGRAM','SAMMITH101'),
    social_media_type('SNAPCHAT','SMITHSAM101')),
accomodation_table_type(
    accomodation_type('ROSE HOTEL', 24, '89.99', 'DOUBLE'),
    accomodation_type('MOORLEYS STAY',10,'50.00','SINGLE')),
REF(a)
FROM addresses a
WHERE postcode = 'NN1 2BR';




-- query testing -- QUERYING PARTIAL STRING FROM OBJECT TYPE COLUMNS VIA RELATIONAL TABLE 
SELECT s.address.city, s.address.postcode
FROM sites s
WHERE s.address.postcode LIKE 'SL3%';


-- query testing a varray using an unnested query and dot notation

SELECT s.staff_id, s.media_name, s.username
FROM staff s, 
TABLE (s.social_media)s
WHERE staff_id = 28227;


-- query testing --basic query of selected rows from address table
SELECT street, postcode, city, country 
FROM addresses;


