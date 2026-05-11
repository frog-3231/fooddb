-- Step 1: Drop the table if it already exists to start fresh
DROP TABLE IF EXISTS `fooddb`.`administrator`;

-- Step 2: Create the table linked to the users table
CREATE TABLE `fooddb`.`administrator` (
  `admin_id` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`admin_id`),
  CONSTRAINT `fk_admin_user`
    FOREIGN KEY (`admin_id`)
    REFERENCES `fooddb`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

;
-- --------------------------CUSTOMER---------------------------------
DROP TABLE IF EXISTS `fooddb`.`customer`;

CREATE TABLE `fooddb`.`customer` (
  `customer_id` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `fk_customer_user`
    FOREIGN KEY (`customer_id`)
    REFERENCES `fooddb`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------CUSTOMER-----------------------------------

-- -----------------------------RIDER-------------------------------------
DROP TABLE IF EXISTS `fooddb`.`delivery_rider`;

CREATE TABLE `fooddb`.`delivery_rider` (
  `rider_id` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`rider_id`),
  CONSTRAINT `fk_rider_user`
    FOREIGN KEY (`rider_id`)
    REFERENCES `fooddb`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- -----------------------------RIDER-------------------------------------

-- -----------------------------CASHIER------------------------------------
DROP TABLE IF EXISTS `fooddb`.`cashier`;

CREATE TABLE `fooddb`.`cashier` (
  `cashier_id` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`cashier_id`),
  CONSTRAINT `fk_cashier_user`
    FOREIGN KEY (`cashier_id`)
    REFERENCES `fooddb`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------CASHIER-----------------------------------

ALTER TABLE `fooddb`.`users` 
-- Add Phone Format Check (PH Standard: 09 + 9 digits)
ADD CONSTRAINT `chk_ph_phone` 
	CHECK (`phone` REGEXP '^09[0-9]{9}$'),

-- Add Email Format Check
ADD CONSTRAINT `chk_email_format` 
	CHECK (`email` REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),

-- Ensure updated_at behaves automatically
MODIFY COLUMN `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

CREATE TABLE `users` (
  `user_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'USR-',upper(hex(random_bytes(4))))),
  `username` varchar(45) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `is_active` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `password` char(64) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- ----------------------------------------------------------------------------------------------