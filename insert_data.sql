USE car_rental;

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
CREATE VIEW Yound_Driver AS
SELECT customer_id, first_name, last_name, (birthdate-CURDATE())<25 AS is_young_driver
FROM Customers;

-- trip price detail
CREATE VIEW Trip_Price AS 
SELECT t.trip_id, 
	(t.end_date-t.start_date+1) AS trip_duration,
	(t.end_date-t.start_date+1)*c.daily_rate AS rental_price, 
	(t.end_date-t.start_date+1)*21.38 AS insurance, 
    (t.end_date-t.start_date+1)*10*y.is_young_driver AS younf_driver_fee,
    (t.end_date-t.start_date+1)*c.daily_rate + (t.end_date-t.start_date+1)*21.38+(t.end_date-t.start_date+1)*10*y.is_young_driver AS total_price
FROM Trips t
JOIN Cars c USING(car_id)
JOIN yound_driver y USING (customer_id);

-- drop customer_id, can be found by trip
ALTER TABLE `car_rental`.`Invoice` 
DROP FOREIGN KEY `fk_Invoice_Customers1`;
ALTER TABLE `car_rental`.`Invoice` 
DROP COLUMN `customer_id`,
DROP INDEX `fk_Invoice_Customers1_idx` ;
;

-- invoice
INSERT INTO Invoice VALUES (DEFAULT, "78-145-1093", "2022-12-06", 168, 1);
INSERT INTO Invoice VALUES (DEFAULT, "78-145-1093", "2022-12-30", 61.28,2);
INSERT INTO Invoice VALUES (DEFAULT, "77-593-0081", "2022-01-03", 172.17, 3);
INSERT INTO Invoice VALUES (DEFAULT, "48-266-1517", "2022-12-17", 59.50, 1);
INSERT INTO Invoice VALUES (DEFAULT, "20-848-0181", "2022-12-12", 126.15, 4);
INSERT INTO Invoice VALUES (DEFAULT, "41-666-1035", "2023-01-05", 503.04, 5);
INSERT INTO Invoice VALUES (DEFAULT, "55-105-9605", "2023-01-11", 80.31,6);

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

-- payment
INSERT INTO Payments VALUES (DEFAULT, "2022-12-05", 168, 1,1,3);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-28", 61.28,6,2,4);
INSERT INTO Payments VALUES (DEFAULT, "2022-01-01", 172.17, 5,3,1);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-15", 59.50, 1,1,3);
INSERT INTO Payments VALUES (DEFAULT, "2022-12-10", 126.15, 5,4,4);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-04", 503.04, 4,5,2);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-10", 80.31,2,6,1);
INSERT INTO Payments VALUES (DEFAULT, "2023-01-20", 70.00,5,NULL,1);
