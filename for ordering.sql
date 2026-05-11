DROP TABLE IF EXISTS `fooddb`.`delivery`;

CREATE TABLE `fooddb`.`delivery` (
  `delivery_id` VARCHAR(20) NOT NULL DEFAULT (concat(_utf8mb4'DLV-',upper(hex(random_bytes(4))))),
  `order_id` VARCHAR(20) DEFAULT NULL,
  `rider_id` VARCHAR(20) DEFAULT NULL,
  `delivery_status` ENUM('Delivering','Completed','Cancelled') NOT NULL DEFAULT 'Delivering',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- Added for tracking
  PRIMARY KEY (`delivery_id`),
  -- We keep the indexes for performance during your demo
  INDEX `fk_order_delivery_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_rider_delivery_idx` (`rider_id` ASC) VISIBLE,
  -- Foreign Key to Orders
  CONSTRAINT `fk_order_delivery` 
    FOREIGN KEY (`order_id`) 
    REFERENCES `fooddb`.`orders` (`order_id`) 
    ON DELETE CASCADE,
  -- Foreign Key to Delivery Rider (The User ID)
  CONSTRAINT `fk_rider_delivery` 
    FOREIGN KEY (`rider_id`) 
    REFERENCES `fooddb`.`delivery_rider` (`rider_id`) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `fooddb`.`orders`;

CREATE TABLE `fooddb`.`orders` (
  `order_id` VARCHAR(20) NOT NULL DEFAULT (concat(_utf8mb4'ORD-',upper(hex(random_bytes(4))))),
  `cust_id` VARCHAR(20) NOT NULL, -- This will hold the USR- ID from the customer table
  `order_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('Pending','Ready For Delivery','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  `total_price` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `address` VARCHAR(255) NOT NULL,
  `payment` ENUM('Cash', 'Credit Card', 'Cancelled') NOT NULL DEFAULT 'Cash',
  PRIMARY KEY (`order_id`),
  INDEX `fk_customer_id_idx` (`cust_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_customer` 
    FOREIGN KEY (`cust_id`) 
    REFERENCES `fooddb`.`customer` (`customer_id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `chk_orders_price` CHECK (`total_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `fooddb`.`order_detail`;

CREATE TABLE `fooddb`.`order_detail` (
  `order_detail_id` VARCHAR(20) NOT NULL DEFAULT (concat(_utf8mb4'DET-',upper(hex(random_bytes(4))))),
  `order_id` VARCHAR(20) NOT NULL,
  `item_id` VARCHAR(20) NOT NULL,
  `quantity` INT NOT NULL,
  `subtotal` DECIMAL(10,2) DEFAULT '0.00',
  PRIMARY KEY (`order_detail_id`),
  INDEX `fk_order_detail_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_item_detail_idx` (`item_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_parent` 
    FOREIGN KEY (`order_id`) 
    REFERENCES `fooddb`.`orders` (`order_id`) 
    ON DELETE CASCADE,
  CONSTRAINT `fk_item_referenced` 
    FOREIGN KEY (`item_id`) 
    REFERENCES `fooddb`.`food_menu` (`item_id`) 
    ON DELETE RESTRICT,
  CONSTRAINT `chk_quantity_positive` CHECK (`quantity` > 0),
  CONSTRAINT `chk_subtotal_positive` CHECK (`subtotal` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


update orders
set address = '123 deca homes, calumpang' 
where order_id = 'ORD-92E29AB1';