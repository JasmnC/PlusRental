-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema car_rental
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema car_rental
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `car_rental` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema sql_hr
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema sql_inventory
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema sql_invoicing
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema sql_store
-- -----------------------------------------------------
USE `car_rental` ;

-- -----------------------------------------------------
-- Table `car_rental`.`Offices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Offices` (
  `office_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `state` CHAR(2) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`office_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Employees` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `manager` INT NULL,
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `office` INT NOT NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `fk_Employees_Offices1_idx` (`office` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Offices1`
    FOREIGN KEY (`office`)
    REFERENCES `car_rental`.`Offices` (`office_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birthdate` DATE NOT NULL,
  `address` VARCHAR(45) NULL,
  `city` VARCHAR(30) NULL,
  `state` CHAR(2) NULL,
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Trip_Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Trip_Status` (
  `stauts_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`stauts_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Car_Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Car_Status` (
  `stauts_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `avalible` TINYINT NOT NULL,
  PRIMARY KEY (`stauts_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Models`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Models` (
  `model_id` INT NOT NULL AUTO_INCREMENT,
  `year` TINYINT(4) NOT NULL,
  `brand` VARCHAR(30) NOT NULL,
  `model` VARCHAR(30) NOT NULL,
  `seats` TINYINT(2) NOT NULL,
  PRIMARY KEY (`model_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Cars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Cars` (
  `car_id` INT NOT NULL AUTO_INCREMENT,
  `plate` VARCHAR(45) NOT NULL,
  `daily_rate` DECIMAL(5,2) NOT NULL,
  `state` CHAR(2) NOT NULL,
  `stauts` INT NOT NULL,
  `model` INT NOT NULL,
  PRIMARY KEY (`car_id`),
  INDEX `fk_Cars_Car_Status1_idx` (`stauts` ASC) VISIBLE,
  INDEX `fk_Cars_Models1_idx` (`model` ASC) VISIBLE,
  CONSTRAINT `fk_Cars_Car_Status1`
    FOREIGN KEY (`stauts`)
    REFERENCES `car_rental`.`Car_Status` (`stauts_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cars_Models1`
    FOREIGN KEY (`model`)
    REFERENCES `car_rental`.`Models` (`model_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Trips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Trips` (
  `trip_id` INT NOT NULL AUTO_INCREMENT,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `customer_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `stauts` INT NOT NULL,
  `car_id` INT NOT NULL,
  PRIMARY KEY (`trip_id`),
  INDEX `fk_Trips_Customers1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_Trips_Employees1_idx` (`employee_id` ASC) VISIBLE,
  INDEX `fk_Trips_Trip_Status1_idx` (`stauts` ASC) VISIBLE,
  INDEX `fk_Trips_Cars1_idx` (`car_id` ASC) VISIBLE,
  CONSTRAINT `fk_Trips_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `car_rental`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_Employees1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `car_rental`.`Employees` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_Trip_Status1`
    FOREIGN KEY (`stauts`)
    REFERENCES `car_rental`.`Trip_Status` (`stauts_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_Cars1`
    FOREIGN KEY (`car_id`)
    REFERENCES `car_rental`.`Cars` (`car_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Invoice` (
  `invoice_id` INT NOT NULL AUTO_INCREMENT,
  `invoice_number` VARCHAR(20) NOT NULL,
  `date` DATE NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `trip_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`invoice_id`),
  INDEX `fk_Invoice_Trips2_idx` (`trip_id` ASC) VISIBLE,
  INDEX `fk_Invoice_Customers1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Invoice_Trips2`
    FOREIGN KEY (`trip_id`)
    REFERENCES `car_rental`.`Trips` (`trip_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Invoice_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `car_rental`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Payment_Methods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Payment_Methods` (
  `method_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`method_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `car_rental`.`Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `car_rental`.`Payments` (
  `payment_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `customer_id` INT NOT NULL,
  `invoice_id` INT NOT NULL,
  `payment_method` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_Payments_Customers1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_Payments_Invoice1_idx` (`invoice_id` ASC) VISIBLE,
  INDEX `fk_Payments_Payment_Methods1_idx` (`payment_method` ASC) VISIBLE,
  CONSTRAINT `fk_Payments_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `car_rental`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payments_Invoice1`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `car_rental`.`Invoice` (`invoice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payments_Payment_Methods1`
    FOREIGN KEY (`payment_method`)
    REFERENCES `car_rental`.`Payment_Methods` (`method_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
