USE car_rental;

-- set restrictions
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- trip status, car status, and payment methods
INSERT INTO Payment_Methods (name) VALUES ("Cash"), ("Check"), ("Credit Card"), ("Wire Transfer"), ("Paypal"), ("Apple Pay");
INSERT INTO Trip_Status (name) VALUES ("Processed"), ("Waiting Payment"), ("On-going"), ("Returned");
INSERT INTO Car_Status (name, avalible) VALUES ("Booked",0), ("On-going trip", 0), ("Maintanance", 0), ("Avalible", 1);

-- customers
INSERT INTO Customers VALUE (DEFAULT, "Sam", "Dyson", "2000-01-04", NULL, NULL, NULL, "Sam2000@gmail.com", "617-408-9092");
INSERT INTO Customers VALUE (DEFAULT, "John", "Mayer", "1990-06-08", "45 Main St", "San Fransisco", "CA", "Mayer90@gmail.com", "213-847-2529");
INSERT INTO Customers VALUE (DEFAULT, "Freddy", "Mae", "1988-02-24", "360 Mass Ave", "Boston", "MA", "Freddy1988@gmail.com", "617-943-2558");
INSERT INTO Customers VALUE (DEFAULT, "Orange", "Cat", "1999-09-19", "754 London St", "Spring Abor", "MI", "iamacattt@gmail.com", "517-750-3703");
INSERT INTO Customers VALUE (DEFAULT, "Jenny", "Cao", "2004-07-25", NULL, NULL, "PA", "cao.jenn@gmail.com", "570-568-1343");
INSERT INTO Customers VALUE (DEFAULT, "Phil", "Rey", "2001-12-05", "8677 Charles Rd", "Lincon", "RI", "phillyr@gmail.com", "401-723-9245");
INSERT INTO Customers VALUE (DEFAULT, "Lydia", "Slvisky", "2003-10-30", "299 Henmingwey St", "Boston", "MA", "lydd@gmail.com", "360-267-0401");

-- offices
INSERT INTO Offices VALUES (DEFAULT, "NYC Midtown","5507 Becker Terrace",'New York City','NY', "917-528-5217");
INSERT INTO Offices VALUES (DEFAULT, "Bufflo Airport","8 South Crossing","Bufflo",'NY', "716-225-9614");
INSERT INTO Offices VALUES (DEFAULT, "Court Side VA",'54 Northland Court','Richmond','VA', "757-913-1373");
INSERT INTO Offices VALUES (DEFAULT, "Logan Airport",'99 Service Rd','Boston','MA', "617-966-8543");

-- employees
INSERT INTO Employees VALUES (80529,'Lynde','Aronson','Customer Manager',113553,"lynde.a@plusrental.com", "516-485-5281",1);
INSERT INTO Employees VALUES (80679,'Mildrid','Sokale','Trainee',80529,"mildrid.s@plusrental.com", "716-284-8842",1);
INSERT INTO Employees VALUES (84791,'Hazel','Tarbert','General Manager',113553,"hazel.t@plusrental.com", "372-707-9245",2);
INSERT INTO Employees VALUES (80699,'Thacher','Naseby','Junior Executive',84791, "thacher.n@plusrental.com", '941-527-3977',3);
INSERT INTO Employees VALUES (98449,'Ilene','Dowson','Customer Manager',113553, "ilene.d@plusrental.com", '615-641-4759',2);
INSERT INTO Employees VALUES (98374,'Estrellita','Daleman','Staff Accountant',113553,"Estrellita.d@plusrental.com","307-345-3310",3);
INSERT INTO Employees VALUES (115357,'Ivy','Fearey','Software Engineer',113553,"ivy.f@plusrental.com","462-937-270",4);
INSERT INTO Employees VALUES (113553,'Elka','Twiddell',"Chief Executive Officer", NULL,"twiddell@plusrental.com",'312-480-8498',4);

-- alter table 
ALTER TABLE `car_rental`.`Models` 
CHANGE COLUMN `year` `year` INT NOT NULL ;

-- models
INSERT INTO Models VALUES (DEFAULT, 2016, "Versa Note", "Nissan", 5);
INSERT INTO Models VALUES (DEFAULT, 2019, "Soul", "Kia", 5);
INSERT INTO Models VALUES (DEFAULT, 2019, "Spark", "Chevrolet", 4);
INSERT INTO Models VALUES (DEFAULT, 2020, "Niro", "Kia", 5);
INSERT INTO Models VALUES (DEFAULT, 2014, "RAV4", "Toyota", 5);
INSERT INTO Models VALUES (DEFAULT, 2020, "Jetta", "Volkswagen", 5);

-- cars 
INSERT INTO Cars VALUES (DEFAULT, "8ECG057", 29, "MA",1, 3);
INSERT INTO Cars VALUES (DEFAULT, "648-VRP", 34.5, "MA",4, 2);
INSERT INTO Cars VALUES (DEFAULT, "CH78SV", 31.8, "MA",4, 4);
INSERT INTO Cars VALUES (DEFAULT, "7AAA458", 28.5, "NY",3, 1);
INSERT INTO Cars VALUES (DEFAULT, "7DV746", 29.9, "NY",4, 2);
INSERT INTO Cars VALUES (DEFAULT, "FYP1419", 31.5, "NY",2, 4);
INSERT INTO Cars VALUES (DEFAULT, "SC17657", 36, "VA",4, 2);
INSERT INTO Cars VALUES (DEFAULT, "4002B", 29.9, "VA",2, 5);
INSERT INTO Cars VALUES (DEFAULT, "3N34G4", 33.9, "NY",2, 4);
INSERT INTO Cars VALUES (DEFAULT, "403VJP", 35.37, "MA",2, 4);

-- price can be calculate by start-end date
ALTER TABLE `car_rental`.`Trips` 
DROP COLUMN `price`;

-- trips
INSERT INTO Trips VALUES (DEFAULT, "2022-12-03", "2022-12-06", 1, 80699,1, 4);
INSERT INTO Trips VALUES (DEFAULT, "2023-01-04", "2023-01-04", 6,80529,2, 8);
INSERT INTO Trips VALUES (DEFAULT, "2022-12-17", "2022-12-18", 5, 80699,1, 6);
INSERT INTO Trips VALUES (DEFAULT, "2022-12-07", "2022-12-09", 5, 80699,2, 5);
INSERT INTO Trips VALUES (DEFAULT, "2022-12-20", "2022-12-27", 4, 80529,3, 6);
INSERT INTO Trips VALUES (DEFAULT, "2023-01-08", "2023-01-09", 2, 84791,4, 3);
INSERT INTO Trips VALUES (DEFAULT, "2023-02-12", "2023-02-16", 3, 80529,3, 1);

-- view young driver
CREATE VIEW Young_Driver AS
SELECT customer_id, first_name, last_name, (birthdate-CURDATE())<25 AS is_young_driver
FROM Customers;

-- trip price detail
CREATE VIEW Trip_Price AS 
SELECT t.trip_id, 
	(t.end_date-t.start_date+1) AS trip_duration,
	(t.end_date-t.start_date+1)*c.daily_rate AS rental_price, 
	(t.end_date-t.start_date+1)*21.38 AS insurance, 
    (t.end_date-t.start_date+1)*10*y.is_young_driver AS young_driver_fee,
    (t.end_date-t.start_date+1)*c.daily_rate + (t.end_date-t.start_date+1)*21.38+(t.end_date-t.start_date+1)*10*y.is_young_driver AS total_price
FROM Trips t
JOIN Cars c USING(car_id)
JOIN young_driver y USING (customer_id);

-- update a amount for tracking payment
ALTER TABLE `car_rental`.`Invoice` 
ADD COLUMN `paid_amount` DECIMAL(10,2) NOT NULL DEFAULT 0 AFTER `customer_id`;

-- invoice
INSERT INTO Invoice VALUES (DEFAULT, "78-145-1093", "2022-12-06", 168, 1, 1,0);
INSERT INTO Invoice VALUES (DEFAULT, "78-145-1093", "2022-12-30", 61.28,2, 6,0);
INSERT INTO Invoice VALUES (DEFAULT, "77-593-0081", "2022-01-03", 172.17, 3, 5,0);
INSERT INTO Invoice VALUES (DEFAULT, "48-266-1517", "2022-12-17", 59.50, 7, 1,0);
INSERT INTO Invoice VALUES (DEFAULT, "20-848-0181", "2022-12-12", 126.15, 4, 5,0);
INSERT INTO Invoice VALUES (DEFAULT, "41-666-1035", "2023-01-05", 503.04, 5,4,0);
INSERT INTO Invoice VALUES (DEFAULT, "55-105-9605", "2023-01-11", 80.31,6,2,0);

-- update payment to allow null
ALTER TABLE `car_rental`.`Payments` 
DROP FOREIGN KEY `fk_Payments_Invoice1`;
ALTER TABLE `car_rental`.`Payments` 
CHANGE COLUMN `invoice_id` `invoice_id` INT NULL ;
ALTER TABLE `car_rental`.`Payments` 
ADD CONSTRAINT `fk_Payments_Invoice1`
  FOREIGN KEY (`invoice_id`)
  REFERENCES `car_rental`.`Invoice` (`invoice_id`);
ALTER TABLE `car_rental`.`Payments` 
CHANGE COLUMN `payment_id` `payment_id` INT NOT NULL AUTO_INCREMENT ;

-- trigger to update paid_amount after payment
DELIMITER $$
CREATE TRIGGER paid_amount_after_insert
	AFTER INSERT ON Payments
    FOR EACH ROW
BEGIN
	UPDATE Invoice
    SET paid_amount = paid_amount + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER paid_amount_after_delete
	AFTER DELETE ON Payments
    FOR EACH ROW
BEGIN
	UPDATE Invoice
    SET paid_amount = paid_amount - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;

-- payment
INSERT INTO Payments VALUES (DEFAULT, "2022-12-05", 168, 1,1,3);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-28", 61.28,6,2,4);
INSERT INTO Payments VALUES (DEFAULT, "2022-01-01", 50, 5,3,1);
INSERT INTO Payments VALUES (DEFAULT, "2022-01-01", 22.17, 5,3,1);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-15", 59.50, 1,1,3);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-10", 100, 5,4,4);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-10", 26.15, 5,4,4);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-04", 183.84, 4,5,2);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-10", 80.31,2,6,1);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-20", 70.00,5,NULL,1);

-- procedure get customer
DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN
	SELECT * FROM Customers;
END$$
DELIMITER ;

-- find the best customer 
CREATE VIEW customer_rank AS 
SELECT c.customer_id, c.first_name, c.last_name,
		SUM(amount) AS total_sales
FROM Customers c
JOIN Invoice i USING (customer_id)
GROUP BY customer_id 
ORDER BY SUM(amount) DESC;

-- veiw trips' payment due
CREATE VIEW trip_amount_due AS 
SELECT t.trip_id, i.customer_id, i.invoice_id, t.total_price, i.paid_amount, 
	t.total_price-i.paid_amount AS amount_due
FROM Invoice i
JOIN trip_price t USING (trip_id)
GROUP BY trip_id
ORDER BY (t.total_price-i.paid_amount) DESC;

-- getting total income
DELIMITER $$
CREATE PROCEDURE get_total_sales()
BEGIN
	SELECT SUM(total_price) FROM trip_price;
END$$
DELIMITER ;

-- get most popluar car
CREATE VIEW most_popular_car AS 
SELECT car_id, m.brand, m.model,c.state, COUNT(car_id) AS booking_times
FROM Trips t  
JOIN Cars c USING(car_id)
JOIN Models m ON c.model=m.model_id
GROUP BY car_id, m.brand
ORDER BY booking_times DESC;

-- get manager
DROP PROCEDURE IF EXISTS get_manager;
DELIMITER $$
CREATE PROCEDURE get_manager(employee_id INT )
BEGIN
	SELECT e.employee_id, e.first_name, e.last_name, e.title,
		m.first_name AS manager
	FROM Employees e
	LEFT JOIN Employees m ON e.manager = m.employee_id
	WHERE e.employee_id=employee_id;
END $$
DELIMITER ;

-- get best employee
DROP PROCEDURE IF EXISTS get_best_employee;
DELIMITER $$
CREATE PROCEDURE get_best_employee()
BEGIN
	SELECT e.employee_id, e.first_name, e.last_name,
		COUNT(employee_id) AS sales_by
	FROM Employees e
	JOIN Trips t USING(employee_id)
	GROUP BY employee_id
	ORDER BY sales_by DESC;
END $$
DELIMITER ;
