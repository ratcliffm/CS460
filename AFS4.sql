-- Maliah Ratcliff
-- AFS 
use usr_ratcliffm_0;

-- CUSTOMER TABLE
CREATE TABLE customer(
	customer_id CHAR(3) NOT NULL,
	customer_name_first VARCHAR(10) NOT NULL,
    customer_name_last VARCHAR(10) NOT NULL,
	phone_num VARCHAR(10) NOT NULL,
    email_address VARCHAR(20),
    address VARCHAR(20) NOT NULL
    );
    
    ALTER TABLE customer
   ADD CONSTRAINT customer_pk
   PRIMARY KEY (customer_id);

-- TRIP TABLE
CREATE TABLE trip(
	trip_id CHAR(3) NOT NULL,
	guide_id VARCHAR(20) NOT NULL,
	location VARCHAR(15) NOT NULL,
    price INT NOT NULL,
    full_day BOOLEAN NOT NULL,
    trip_full BOOLEAN NOT NULL
    );

 ALTER TABLE trip
   ADD CONSTRAINT trip_pk
   PRIMARY KEY (trip_id);
   
   ALTER TABLE trip
   ADD CONSTRAINT trip_fk
   FOREIGN KEY (guide_id)
   REFERENCES fishing_guide(guide_id);
   
-- GUIDE TABLE
CREATE TABLE fishing_guide(
	guide_id char(3) NOT NULL,
	guide_name_first varchar(10) NOT NULL,
	guide_name_last varchar(10) NOT NULL,
	boat_num int NOT NULL,
	phone_num varchar(20) NOT NULL,
	guide_license int NOT NULL
);

ALTER TABLE fishing_guide
ADD CONSTRAINT fishing_guide_pk
   	PRIMARY KEY (guide_id);
    

-- CUSTOMER TRIP TABLE
CREATE TABLE customer_trip(
	trip_id CHAR(3) NOT NULL,
	customer_id VARCHAR(20) NOT NULL,
	num_of_people INT NOT NULL,
    departure_date VARCHAR(10) NOT NULL,
    trip_cost INT NOT NULL,
    amt_paid INT NOT NULL,
    amt_owed INT NOT NULL,
    waiver_signed BOOLEAN NOT NULL
    );
    
     ALTER TABLE customer_trip
   ADD CONSTRAINT customer_trip_pk
   PRIMARY KEY (trip_id, customer_id);
   
   ALTER TABLE customer_trip
   ADD CONSTRAINT customer_trip_fk
   FOREIGN KEY (trip_id)
   REFERENCES trip(trip_id);
   
   ALTER TABLE customer_trip
   ADD CONSTRAINT customer_trip_fk
   FOREIGN KEY (customer_id)
   REFERENCES customer(customer_id);
   
-- insert statement for customer
INSERT INTO customer VALUES ('100','Mike','Welsh', '5416543834','mikew@gmail.com', '261 ross way');
INSERT INTO customer VALUES ('101','Susan','Dallas', '7647344953', 'susandallas@hotmail.com', '2800 Delta Waters Rd');
INSERT INTO customer VALUES ('102','Dave','Wilson', '9713033033', 'dwilson@gmail.com', '1661 Clark Ave');
INSERT INTO customer VALUES ('103','Sydney','Rawlins', '6519468759', 'sydr@aol.com', '752 West Point Ave');
INSERT INTO customer (customer_id, customer_name_first, customer_name_last, phone_num, address) VALUES (104,'Ally','Ritchy', '7319058673', '24 Lake Rd');

-- insert statement for trip
INSERT INTO trip VALUES ('501','001', 'Rogue River', 70, 0,1);
INSERT INTO trip VALUES ('502','003', 'Klamath River', 80, 1,0);
INSERT INTO trip VALUES ('503','002','Williamson River', 90, 1,1);
INSERT INTO trip VALUES ('504','001','Rogue River', 120, 1,1);
INSERT INTO trip VALUES ('505','005','Williamson River', 50, 0,1);

-- insert statement for fishing_guide
INSERT INTO fishing_guide (guide_id, guide_name_first, guide_name_last, boat_num, phone_num, guide_license) VALUES ('001', 'Stuart','McDonald', 201, '541-220-4506', 2001);
INSERT INTO fishing_guide (guide_id, guide_name_first, guide_name_last, boat_num, phone_num, guide_license) VALUES ('002', 'Paul','Warren', 549, '541-218-9777', 3032);
INSERT INTO fishing_guide (guide_id, guide_name_first, guide_name_last, boat_num, phone_num, guide_license) VALUES ('003', 'James','Fisher', 211, '541-320-3190', 2111);
INSERT INTO fishing_guide (guide_id, guide_name_first, guide_name_last, boat_num, phone_num, guide_license) VALUES ('004', 'Lucas','Weldin', 009, '541-909-2345', 2398);
INSERT INTO fishing_guide (guide_id, guide_name_first, guide_name_last, boat_num, phone_num, guide_license) VALUES ('005', 'Dave','Johnson', 340, '541-098-3498', 5006);

-- insert statement for customer_trip 
INSERT INTO customer_trip (trip_id, customer_id, num_of_people, departure_date, trip_cost, amt_paid, amt_owed) VALUES ('501','104', 2, '06-12-21', 70, 70, 0);
INSERT INTO customer_trip VALUES ('502','100', 3, '06-12-21',80, 60, 20,1);
INSERT INTO customer_trip VALUES ('502','101', 2, '06-12-21', 80, 20, 60,1);
INSERT INTO customer_trip VALUES ('501','101', 4, '06-12-21', 70, 0, 70,1);
INSERT INTO customer_trip VALUES ('503','103', 3, '06-12-21', 90, 45, 45,1);

-- Project Part 4 
-- 1. Set all trips to be a full day. 
UPDATE trip SET full_day = 1; 
-- 2. Remove all scheduled trips in the customer_trip table that are from trip 502.  
DELETE FROM customer_trip WHERE trip_id = '502';
-- 3. Select fishing guides whose boat number contains a 9. 
SELECT guide_name_first FROM fishing_guide WHERE boat_num like '%9%'; 
-- 4. List each customer by first name with the trip that they are taking. 
SELECT customer_name_first, trip_id FROM customer JOIN customer_trip USING(customer_id); 
-- 5. List the names of the fishing guide who will be hosting the trip for each of the locations.  
SELECT location, guide_name_first FROM fishing_guide JOIN trip using(guide_id) GROUP BY location, guide_id; 
-- 6. Select all customers who are not currently attending a trip. 
SELECT customer_name_first FROM customer WHERE customer_id NOT IN (SELECT customer_id FROM customer_trip); 
-- 7. Create a view for each customer along with the trip they are taking and show all customers who are attending trip num 502. 
CREATE VIEW v_customer_info AS SELECT customer_name_first, trip_id FROM customer JOIN customer_trip USING(customer_id);
SELECT * FROM v_customer_info  WHERE trip_id = 502;