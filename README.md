# PlusRental
This is a milestone project for database design and database management.

### Here I built a database pipeline for a pseudo car rental company called Plus Rental.

**Built with:**	![](https://img.shields.io/badge/Code-MySQL-informational?style=flat&logo=Java&logoColor=white&color=FA8218)  ![](https://img.shields.io/badge/Tool-Workbench-informational?style=flat&logo=Java&logoColor=white&color=6082B6)  ![](https://img.shields.io/badge/Skill-DatabaseManagement-informational?style=flat&logo=Java&logoColor=white&color=90EE90)  

### 1. Problem statement:
-	I want to build a car rental system.
-	Customers may have trips and make payments.
-	Each trip is sales by employee.
-	We would have multiple cars, and each car has their own model, brand and year.
-	For each trip, I would want to know how it is be charged.
-	For drivers under 25, a young driver fee will be applied.


### 2. Use cases:
Here's three main stakeholder in my systems, each of them have their specific use case based on their role.

For customers:
- Starting trips
- Making payments

For employees:
- Viewing the best customers/customer ranks
- Viewing best cars
- Viewing payment dues for each trip 

For business owners:
- Getting total sales
- Viewing best employees
- Getting their manager by employee id

### 3. The ER Diagram

![](https://github.com/JasmnC/PlusRental/blob/main/images/ER_Diagram.png)


### 4. The EER (After normalization)

![](https://github.com/JasmnC/PlusRental/blob/main/images/EER_Diagram_3NF.png)


### 5. The physical model made with MySQL workbench 
![](https://github.com/JasmnC/PlusRental/blob/main/images/Physical_Model.png) 


### 6. Dummy data and Code review

<details>
  <summary>1. Dummy Data</summary>
  
  After I generate the sql script by forward engineering, defining structures, we can see all tables here but no data.
  ![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot1.png)

 First, I insert the three entities customers, cars and employees, with their corresponding tables. 

 ![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot2.png)

The table of customers: 
 ![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot3.png)

Table of cars, associate with car model and car status.  
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot4.png)
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot5.png)
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot6.png)

And employees associate with their office.  
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot7.png)
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot8.png)

Now we have all the customers, we can start finding out all young drivers, create view for young drivers. 

```
CREATE VIEW Young_Driver AS
SELECT customer_id, first_name, last_name, (birthdate-CURDATE())<25 AS is_young_driver
FROM Customers;
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot9.png)
 
Test by inserting a new customer.

</details>

<details>
  <summary>2. Use case for customers</summary>

```
INSERT INTO Customers VALUE (DEFAULT, "Jasmine", "Chen", "2000-10-30", "287 Henmingwey St", "Boston", "MA", "jasmnc@gmail.com", "360-267-0401");
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot10.png)

Check by customer table.
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot11.png)


Refresh table, we can see a new customer is added and the young driver table as well. Also, the customer id is auto increased. 

Customers make trips to car.

Trip dummy data
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot12.png)
 
Test by insert trip.
```
INSERT INTO Trips VALUES (DEFAULT, "2023-03-27", "2023-03-29", 8, 80699,1, 1);  
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot13.png)

For trips we need to know the price, we can get trip price by start date, end date, and young driver fees.

```
CREATE VIEW Trip_Price AS 
SELECT t.trip_id, (t.end_date-t.start_date+1) AS trip_duration,
(t.end_date-t.start_date+1)*c.daily_rate AS rental_price, 
(t.end_date-t.start_date+1)*21.38 AS insurance, 
(t.end_date-t.start_date+1)*10*y.is_young_driver AS young_driver_fee,
(t.end_date-t.start_date+1)*c.daily_rate + (t.end_date-t.start_date+1)*21.38+(t.end_date-t.start_date+1)*10*y.is_young_driver AS total_price
FROM Trips t
JOIN Cars c USING(car_id)
JOIN young_driver y USING (customer_id);
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot14.png)

Now we have the total price, we can start charging for trips by making invoice. Here I separate invoice with payments because a invoice may have multiple payments, it can not be link to customer directly or it will create a many-to-many relationship.

![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot15.png)


Test new invoice by inserting data.
```
INSERT INTO Invoice VALUES (DEFAULT, "55-105-9840", "2023-03-27", 100,1,8, 0);  
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot16.png)

And we have payments.  
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot17.png)

With payments and invoice, we can know the amount due for each trip. Because payments are link to invoice, the paid amount, so write triggers to auto update.

```
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
```

Test making payment. We can see after paying $100, the paid amount in column 9 is updated.

```
INSERT INTO Payments VALUE(DEFAULT, "2023-03-03", 100, 8,9,3);
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot18.png)


</details>
<details>
  <summary>3. Use case for employees</summary>
	
View best customers by the customer_rank view table.
```
CREATE VIEW customer_rank AS 
SELECT c.customer_id, c.first_name, c.last_name,
		SUM(amount) AS total_sales
FROM Customers c
JOIN Invoice i USING (customer_id)
GROUP BY customer_id 
ORDER BY SUM(amount) DESC;

SELECT * FROM car_rental.customer_rank; 
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot19.png)


View best car by the most_popular_car view table.

```
CREATE VIEW most_popular_car AS 
SELECT car_id, m.brand, m.model,c.state, COUNT(car_id) AS booking_times
FROM Trips t  
JOIN Cars c USING(car_id)
JOIN Models m ON c.model=m.model_id
GROUP BY car_id, m.brand
ORDER BY booking_times DESC;

SELECT * FROM car_rental.most_popular_car;
``` 
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot20.png)


Also we’ll want to know each trip amount dues by the trip_amount_due view table.

```
CREATE VIEW trip_amount_due AS 
SELECT t.trip_id, i.customer_id, i.invoice_id, t.total_price, i.paid_amount, 
	t.total_price-i.paid_amount AS amount_due
FROM Invoice i
JOIN trip_price t USING (trip_id)
GROUP BY trip_id
ORDER BY (t.total_price-i.paid_amount) DESC;

SELECT * FROM car_rental.trip_amount_due;
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot21.png)
 
</details>
<details>
  <summary>4. Use case for business owners</summary>

View total sales by procedures.
```
DELIMITER $$
CREATE PROCEDURE get_total_sales()
BEGIN
SELECT SUM(total_price) AS total_sales FROM trip_price;
END$$
DELIMITER ;
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot22.png)


View best employee by sorted procedures.
```
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
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot23.png)


Also find his/her manager by sorted procedures, pass in employee id to as parameter. To avid not finding employee with NULL manager value, use left join.
```
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
```
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot24.png)
![](https://github.com/JasmnC/PlusRental/blob/main/images/Screenshot25.png)

</details>








  
