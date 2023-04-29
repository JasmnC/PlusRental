-- customer, young driver
-- INSERT INTO Customers VALUE (DEFAULT, "Jasmine", "Chen", "2000-10-30", "287 Henmingwey St", "Boston", "MA", "jasmnc@gmail.com", "360-267-0401");

-- trip, trip price
-- INSERT INTO Trips VALUES (DEFAULT, "2023-03-27", "2023-03-29", 8, 80699,1, 1);

-- insert a invoice
-- INSERT INTO Invoice VALUES (DEFAULT, "55-105-9840", "2023-03-27", 100,1,customer_id, 0);

-- payment include triggers
-- INSERT INTO Payments VALUE(DEFAULT, "2023-03-03", 100, customer_id,invoice_id,payment_method);
-- DELETE FROM Payments WHERE payment_id=;

-- for employees' feature
-- get best customer, get most popular car, trip amount due
-- SELECT * FROM car_rental.customer_rank;
-- SELECT * FROM car_rental.most_popular_car;
-- SELECT * FROM car_rental.trip_amount_due;

-- for business owner
-- best employee, and his manager
-- total sales