-- My groceries Team SQL File 
-- Maliah, Gage, Sean G, Forrest 

-- Gage’s code to create the mygroceries_user table 
CREATE TABLE mygroceries_user (
	user_id INTEGER NOT NULL,
    user_name VARCHAR(255),
    email VARCHAR(255),
    household_id INTEGER,
    PRIMARY KEY (user_id),
	FOREIGN KEY (household_id) REFERENCES household (household_id)
    );
-- Gage’s code to populate the mygroceries_user table 
INSERT INTO mygroceries_user (user_id, user_name, email, household_id) VALUES (1298483, 'Zachary', 'ZachS@Yahoo.com', 3829);
INSERT INTO mygroceries_user (user_id, user_name, email, household_id) VALUES (1029394, 'Will', 'Dogdogcat@gmail.com' , 1002);
INSERT INTO mygroceries_user (user_id, user_name, email, household_id) VALUES (2930048, 'Suzanne', 'Aem39oel21@AOL.com', 127);
INSERT INTO mygroceries_user (user_id, user_name, email, household_id) VALUES (8429590, 'Luka', 'Dolphin2910@gmail.com', 123);
INSERT INTO mygroceries_user (user_id, user_name, email, household_id) VALUES (9939939, 'Mallory', 'Mallory1@gmail.com', 0021);


-- Gage’s code to create the food_item table 
CREATE TABLE food_item (
	food_id INTEGER NOT NULL,
    food_name VARCHAR(255),
    price DECIMAl(16,2),
    PRIMARY KEY (food_id)
    );
-- Gage’s code to populate the food_item table 
INSERT INTO food_item (food_id, food_name, price) VALUES (001, 'Banana', '0.79');
INSERT INTO food_item (food_id, food_name, price) VALUES (002, 'Bread', '3.50');
INSERT INTO food_item (food_id, food_name, price) VALUES (003, 'Soup', '1.29');
INSERT INTO food_item (food_id, food_name, price) VALUES (004, 'Chicken', '6.75');
INSERT INTO food_item (food_id, food_name, price) VALUES (005, 'Grapes', '4.55');

--Gage’s code to make a price log table to implement trigger
CREATE TABLE price_log(
    food_id INT NOT NULL AUTO_INCREMENT,
    food_name VARCHAR(255),
    old_price decimal(16,2),
    new_price decimal(16,2),
    date_changed date,
    PRIMARY KEY (food_id)
);


-- Maliah’s code to implement the household table 
CREATE TABLE household (
    household_id INTEGER NOT NULL,
    num_people_in_household INTEGER,
    head_household_id INTEGER NOT NULL,
    PRIMARY KEY (household_id),
    FOREIGN KEY (head_household_id) REFERENCES mygroceries_user (user_id)
);

-- Maliah’s code to populate the household table 
insert into household values  (3829, 1, 1298483);
insert into household values (1002, 1, 1029394);
insert into household values (127, 1, 2930048);
insert into household values (123, 1, 8429590);
insert into household values (0021, 1, 8429590);

-- Maliah’s code to implement the transaction table 
CREATE TABLE users_transaction (
    transaction_id INTEGER NOT NULL,
    date_purchased DATE,
    user_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    purchase_total DECIMAL(16,2) NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (user_id) REFERENCES mygroceries_user (user_id)
);

-- Maliah’s code to populate the transaction table 
INSERT INTO users_transaction VALUES (301,2019-07-21, 8429590,1,75);
INSERT INTO users_transaction VALUES (302,2021-08-20, 8429590,2,120);
INSERT INTO users_transaction VALUES (303,2021-07-161, 1298483,1,15);
INSERT INTO users_transaction VALUES (304,2021-03-11, 1298483,4,90);
INSERT INTO users_transaction VALUES (305,2021-05-01, 2930048,5,35);

-- Forrest’s code to create and populate line_item
create table line_item (
	transaction_id int,
    food_id int,
    qty int,
    price decimal(16, 2),
    primary key (transaction_id, food_id),
    foreign key (transaction_id) references users_transaction(transaction_id),
    foreign key (food_id) references food_item(food_id)
);

insert into line_item values (301, 1, 3, 2.37);
insert into line_item values (301, 4, 1, 6.75);
insert into line_item values (301, 5, 2, 9.10);
insert into line_item values (302, 2, 1, 3.50);
insert into line_item values (302, 3, 1, 1.29);
insert into line_item values (303, 4, 2, 13.5);
insert into line_item values (304, 5, 3, 13.65);
insert into line_item values (304, 1, 6, 4.74);
insert into line_item values (305, 3, 5, 6.45);
insert into line_item values (305, 4, 1, 6.75);

-- Sean's code to implement the store table
CREATE TABLE store (
    store_id int NOT NULL,
    store_name varchar(20) NOT NULL,
    store_address varchar(20),
    open_time time,
    close_time time,
    PRIMARY KEY (store_id)
);

-- Sean's code to populate the store table  
INSERT INTO store (store_id, store_name, store_address, open_time, close_time)
VALUES (1, "Smith's General", "195 3rd Avenue", "09:00:00", "22:00:00");
INSERT INTO store (store_id, store_name, store_address, open_time, close_time)
VALUES (2, "Kalispell Mercantile", "22 Glacier Drive", "09:30:00", "21:30:00");
INSERT INTO store (store_id, store_name, store_address, open_time, close_time)
VALUES (3, "Flathead Grocery", "11 South Main Street", "07:30:00", "19:30:00");
INSERT INTO store (store_id, store_name, store_address, open_time, close_time)
VALUES (4, "Evergreen Corral", "82 Ponderosa Drive", "08:00:00", "23:00:00");
INSERT INTO store (store_id, store_name, store_address, open_time, close_time)
VALUES (5, "Whitefish Market", "912 Winchester Court", "00:00:00", "24:00:00");

-- Database Advanced Implementation:
-- Maliah’s code to create a view ‘house_spending_report’ 
-- this view creates a table that shows each user in a certain household’s spending 
-- This takes in a household ID and a date range, and will return a table that shows how much 
-- each individual has spent. This allows households to see who spends the most money 
-- for best results, use household ‘127’ as this has multiple users 

drop view if exists house_spending_report; 
create view house_spending_report as (select user_name, purchase_total from users_transaction join mygroceries_user using(user_id) group by user_name
);
select * from house_spending_report;

-- Maliah’s code to create a procedure ‘Stores where X Amount Spent’ 
-- This procedure takes in a user ID, along with a given time range, and a dollar amount. 
-- The procedure will return any stores where the user spent more than x dollars and the total 
-- This will allow the user to see which store locations they spend the most money at. 
CREATE DEFINER=``@`%` PROCEDURE `store_report`(IN p_user_id INT, IN p_date1 DATE, IN p_date2 DATE, IN p_amount DECIMAL(16,2))
BEGIN

select store_name as 'Store', sum(purchase_total) as 'Total spent here' from users_transaction join 
store using(store_id) where user_id = p_user_id and date_purchased between p_date1 and p_date2
group by store_name having sum(purchase_total) > p_amount; 

END

-- then call the procedure 
call store_report(8429590, 20000621, 20270721, 9);
-- this produces the outcome we expect 
-- test if it will change the output with an increased dollar amount 
call store_report(8429590, 20000621, 20270721, 96);
-- this produces the outcome we expected, the procedure is functioning as we would like it to

-- Maliah’s code to create a function ‘Total Spent In Given Time Frame’ 
-- This function will take a set period of time and a user ID as an input parameter and will output 
-- the total amount of money the user spent on groceries in that time frame.. This will help 
-- the user track their expenses for specific times. 
CREATE DEFINER=``@`%` FUNCTION `total_spent_by`(p_user_id INT, p_date1 DATE, p_date2 DATE) RETURNS int(11)
BEGIN
DECLARE total decimal(16,2); 
select sum(purchase_total)  as 'Total spent' into total from users_transaction 
where user_id = p_user_id and date_purchased between p_date1 and p_date2 ; 

RETURN total;
END
-- test to see if it is running correctly 
select total_spent_by(8429590, 20000621, 20270721) as 'Total spent';
-- we see that it is 

-- Maliah’s code to create a trigger  ‘Household Increase’
-- This trigger will automatically update the number of users in a specific household when a user 
-- is input into an existing household ID. This will help the household table keep referential 
-- integrity as no one could exist in a household without the number of users in it differing. 
CREATE DEFINER=``@`%` TRIGGER `f21_myGroceries`.`mygroceries_user_AFTER_INSERT` 
AFTER INSERT ON `mygroceries_user` FOR EACH ROW
BEGIN
update household set num_people_in_household = num_people_in_household + 1 
where household_id = household_id; 
END
-- check that this trigger works by adding a user to an existing household and checking size 
insert into mygroceries_user values (7204711, 'Sydney Rawlins','sydthestemkid@aol.com', 127);
select num_people_in_household from household where household_id = 127; 
-- as the household size increased by one in response to the insert statement, it is working appropriately 

-- Forrest’s view
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `georgevif`@`%` 
    SQL SECURITY DEFINER
VIEW `household_weekly_quantity` AS
    SELECT 
        `mygroceries_user`.`household_id` AS `household_id`,
        `food_item`.`food_name` AS `food_name`,
        SUM(`line_item`.`qty`) AS `total`
    FROM
        (((`line_item`
        JOIN `users_transaction` ON ((`line_item`.`transaction_id` = `users_transaction`.`transaction_id`)))
        JOIN `food_item` ON ((`line_item`.`food_id` = `food_item`.`food_id`)))
        JOIN `mygroceries_user` ON ((`users_transaction`.`user_id` = `mygroceries_user`.`user_id`)))
    WHERE
        (`users_transaction`.`date_purchased` >= (CURDATE() - INTERVAL 1 WEEK))
    GROUP BY `mygroceries_user`.`household_id` , `food_item`.`food_id`

-- Forrest’s procedure
CREATE DEFINER=`georgevif`@`%` PROCEDURE `last_purchased`(p_id int)
BEGIN
	select food_item.food_name, max(users_transaction.date_purchased) as last_purchased from users_transaction
	inner join line_item on users_transaction.transaction_id = line_item.transaction_id
	inner join food_item on line_item.food_id = food_item.food_id
	where user_id = p_id
	group by line_item.food_id;
END

-- Forrest’s function
CREATE DEFINER=`georgevif`@`%` FUNCTION `discount_amount`(p_price decimal(16,2), p_qty integer, p_id int) RETURNS decimal(16,2)
BEGIN
	declare l_result decimal(16, 2);
	select cast((100 - p_price / p_qty / price * 100) as decimal(16, 2))
    into l_result from food_item where food_id = p_id;
RETURN l_result;
END

-- Forrest’s trigger
CREATE DEFINER=`georgevif`@`%` TRIGGER `f21_myGroceries`.`line_item_AFTER_INSERT` AFTER INSERT ON `line_item` FOR EACH ROW
BEGIN
update users_transaction set purchase_total = purchase_total + new.price where users_transaction.transaction_id = new.transaction_id;
END


-- Sean's code to create a view 'display week transactions'
CREATE VIEW display_week_transactions AS
SELECT * FROM users_transaction 
WHERE date_purchased > NOW() - INTERVAL 1 WEEK;
-- Sean's code to insert a transaction that has the current date as the date_purchased value to test the view
INSERT INTO display_week_transactions(transaction_id, date_purchased, user_id, store_id, purchase_total) VALUES(309, now(), 8429590, 1, 87.00);
-- Sean's code to see the view
SELECT * FROM f21_myGroceries.display_week_transactions;

-- Sean's code to implement a procedure that sorts a user's transactions by store popularity (assuming visits correspond with popularity)
CREATE DEFINER=`gauses`@`%` PROCEDURE `sort_user_transaction_by_count`(IN l_user_id int)
BEGIN
SELECT user_id AS 'user ID', store_id AS 'Store ID', count(store_id) AS 'Transactions' FROM users_transaction WHERE user_id = l_user_id GROUP BY store_id;
END
-- Sean's code to test the sorting procedure with a hard-coded user_id value
CALL sort_user_transaction_by_count(8429590);

-- Sean's code to implement a function that takes a user ID and a weekly budget goal as input and then determines the weekly budget difference
CREATE DEFINER=`gauses`@`%` FUNCTION `budget_checker`(l_user_id INT, l_budget_goal DECIMAL) RETURNS decimal(10,0)
BEGIN
DECLARE temp_difference DECIMAL;
DECLARE o_budget_difference DECIMAL;
SET temp_difference = 0.0;
SELECT sum(purchase_total) FROM users_transaction WHERE user_id = 8429590 AND date_purchased > (NOW() - INTERVAL 1 WEEK) INTO o_budget_difference;
SET temp_difference = l_budget_goal - o_budget_difference;
RETURN temp_difference;
END
-- Sean's code to test the budget_checker function
SELECT budget_checker (8429590, 10.0) AS ' User Budget Difference For This Week';

-- Sean's code to implement a trigger that disallows negative price values for food items inserted into the database
CREATE DEFINER=`gauses`@`%` TRIGGER `f21_myGroceries`.`food_item_BEFORE_INSERT` 
BEFORE INSERT ON `food_item` FOR EACH ROW
BEGIN
	If new.price < 0 
    THEN SET new.price = 0;
    END IF;
END

