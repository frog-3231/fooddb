-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: fooddb
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrator` (
  `admin_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'ADM-',upper(hex(random_bytes(4))))),
  `username` varchar(255) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  CONSTRAINT `chk_email_format` CHECK (regexp_like(`email`,_utf8mb4'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$')),
  CONSTRAINT `chk_password_hash` CHECK ((length(`password`) = 64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

LOCK TABLES `administrator` WRITE;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES ('ADM-875F1D58','alvin_admin','6ee9dbbcb9ec1a87efea06976b3776ba9610ebe2cca0d2b3045e04156148b943','alvin@fooddb.com','2026-04-05 03:19:19');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_administrator_insert` AFTER INSERT ON `administrator` FOR EACH ROW BEGIN
    -- This automatically creates a record in 'users' linked to the new Admin
    INSERT INTO users (admin_id, is_active) 
    VALUES (NEW.admin_id, 'Active');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `all_users`
--

DROP TABLE IF EXISTS `all_users`;
/*!50001 DROP VIEW IF EXISTS `all_users`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_users` AS SELECT 
 1 AS `user_id`,
 1 AS `username`,
 1 AS `email`,
 1 AS `role`,
 1 AS `is_active`,
 1 AS `joined_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cashier`
--

DROP TABLE IF EXISTS `cashier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashier` (
  `cashier_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'CSH-',upper(hex(random_bytes(4))))),
  `username` varchar(50) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cashier_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_cashier_email` CHECK (regexp_like(`email`,_utf8mb4'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$')),
  CONSTRAINT `chk_cashier_phone` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{11}$')),
  CONSTRAINT `chk_cashier_pw_len` CHECK ((length(`password`) = 64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashier`
--

LOCK TABLES `cashier` WRITE;
/*!40000 ALTER TABLE `cashier` DISABLE KEYS */;
INSERT INTO `cashier` VALUES ('CSH-9EA39641','april_cashier','bee6fbdb31c117800bbf2fdf1c08c2b0b696c10381ede29f74981a2e629a1eb0','april@fooddb.com','09702212345','2026-04-05 03:23:43');
/*!40000 ALTER TABLE `cashier` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_cashier_insert` AFTER INSERT ON `cashier` FOR EACH ROW BEGIN
    INSERT INTO users (cashier_id, is_active) VALUES (NEW.cashier_id, 'Active');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'CST-',upper(hex(random_bytes(4))))),
  `username` varchar(50) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_customer_email` CHECK (regexp_like(`email`,_utf8mb4'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$')),
  CONSTRAINT `chk_customer_phone` CHECK (regexp_like(`phone`,_utf8mb4'^0[0-9]{10}$')),
  CONSTRAINT `chk_customer_pw_len` CHECK ((length(`password`) = 64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('CST-BBF89E0F','victor_customer','29bb72f3aa2d13f4c0da08cda282f6dce2edf9ef58e800123effc5666059351b','victor@fooddb.com','09341722178','2026-04-05 03:25:31','Victor John','Doe');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_customer_insert` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
    INSERT INTO users (customer_id, is_active) VALUES (NEW.customer_id, 'Active');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `delivery_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'DLV-',upper(hex(random_bytes(4))))),
  `order_id` varchar(20) DEFAULT NULL,
  `rider_id` varchar(20) DEFAULT NULL,
  `delivery_status` enum('Delivering','Completed','Cancelled') NOT NULL DEFAULT 'Delivering',
  PRIMARY KEY (`delivery_id`),
  KEY `fk_order_delivery_idx` (`order_id`),
  KEY `fk_rider_delivery_idx` (`rider_id`),
  CONSTRAINT `fk_order_delivery` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rider_delivery` FOREIGN KEY (`rider_id`) REFERENCES `delivery_rider` (`rider_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` VALUES ('DLV-97C3D905','ORD-5EE4CC73','RDR-9F62B298','Completed');
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_delivery_status_update` AFTER UPDATE ON `delivery` FOR EACH ROW BEGIN
    -- Check if the status has actually changed to Completed or Cancelled
    IF NEW.delivery_status <> OLD.delivery_status THEN
        
        IF NEW.delivery_status = 'Completed' THEN
            UPDATE orders 
            SET status = 'Completed' 
            WHERE order_id = NEW.order_id;
            
        ELSEIF NEW.delivery_status = 'Cancelled' THEN
            UPDATE orders 
            SET status = 'Cancelled' 
            WHERE order_id = NEW.order_id;
            
        END IF;
        
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `delivery_rider`
--

DROP TABLE IF EXISTS `delivery_rider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_rider` (
  `rider_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'RDR-',upper(hex(random_bytes(4))))),
  `username` varchar(50) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  PRIMARY KEY (`rider_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `chk_rider_email` CHECK (regexp_like(`email`,_utf8mb4'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$')),
  CONSTRAINT `chk_rider_phone` CHECK (regexp_like(`phone`,_utf8mb4'^0[0-9]{10}$')),
  CONSTRAINT `chk_rider_pw_len` CHECK ((length(`password`) = 64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_rider`
--

LOCK TABLES `delivery_rider` WRITE;
/*!40000 ALTER TABLE `delivery_rider` DISABLE KEYS */;
INSERT INTO `delivery_rider` VALUES ('RDR-9F62B298','dexter_rider','e5e5d2381d4d81c483c7f106c60c360eec4e90370779be300576f2f9c91bca7d','dexter@fooddb.com','09721324451','2026-04-05 03:32:29','Dexter','Grace');
/*!40000 ALTER TABLE `delivery_rider` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_rider_insert` AFTER INSERT ON `delivery_rider` FOR EACH ROW BEGIN
    INSERT INTO users (rider_id, is_active) VALUES (NEW.rider_id, 'Active');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `delivery_tracking_center`
--

DROP TABLE IF EXISTS `delivery_tracking_center`;
/*!50001 DROP VIEW IF EXISTS `delivery_tracking_center`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `delivery_tracking_center` AS SELECT 
 1 AS `delivery_id`,
 1 AS `order_id`,
 1 AS `customer_name`,
 1 AS `customer_contact`,
 1 AS `rider_name`,
 1 AS `total_price`,
 1 AS `delivery_status`,
 1 AS `operational_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `food_menu`
--

DROP TABLE IF EXISTS `food_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_menu` (
  `item_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'FOD-',upper(hex(random_bytes(4))))),
  `item_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `status` enum('available','Unavailable') NOT NULL DEFAULT 'available',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `item_name_UNIQUE` (`item_name`),
  CONSTRAINT `chk_menu_price_positive` CHECK ((`price` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_menu`
--

LOCK TABLES `food_menu` WRITE;
/*!40000 ALTER TABLE `food_menu` DISABLE KEYS */;
INSERT INTO `food_menu` VALUES ('FOD-14DB4BD1','Special Halo-Halo',95.00,'Shaved ice with sweetened beans, fruits, ube halaya, and leche flan.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-3B55382D','Chicken Adobo',180.00,'Tender chicken braised in soy sauce, vinegar, garlic, and peppercorns.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-3EF6DC2D','Lumpiang Shanghai',120.00,'10 pieces of golden-brown fried pork spring rolls.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-75EE18E0','Pork Sisig Classic',220.00,'Sizzling chopped pork face and liver seasoned with calamansi and chili.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-828A0171','Leche Flan',75.00,'Creamy caramel custard topped with a dark amber syrup.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-956219C1','Crispy Pata (Large)',650.00,'Deep-fried pork knuckle served with a soy-vinegar dipping sauce.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-A1205866','Beef Sinigang sa Sampa',250.00,'Beef ribs in a sour tamarind broth with gabi and local vegetables.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-C1A75161','Lechon Kawali',210.00,'Crispy pan-roasted pork belly served with liver sauce.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-CC87D6B5','Pansit Bihon Guisado',150.00,'Stir-fried rice noodles with chicken, shrimp, and crisp vegetables.','available','2026-04-05 21:30:39','2026-04-05 21:30:39'),('FOD-CEBCE18D','Kare-Kareng Baka',280.00,'Beef and tripe stewed in a rich peanut sauce with bagoong alamang.','available','2026-04-05 21:30:39','2026-04-05 21:30:39');
/*!40000 ALTER TABLE `food_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_detail_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'DET-',upper(hex(random_bytes(4))))),
  `order_id` varchar(20) NOT NULL,
  `item_id` varchar(20) NOT NULL,
  `quantity` int NOT NULL,
  `subtotal` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`order_detail_id`),
  KEY `fk_order_detail_idx` (`order_id`),
  KEY `fk_item_detail_idx` (`item_id`),
  CONSTRAINT `fk_item_referenced` FOREIGN KEY (`item_id`) REFERENCES `food_menu` (`item_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_order_parent` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_quantity_positive` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_subtotal_positive` CHECK ((`subtotal` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES ('DET-7E4BCA18','ORD-5EE4CC73','FOD-75EE18E0',2,440.00);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auto_calc_subtotal` BEFORE INSERT ON `order_detail` FOR EACH ROW BEGIN
    DECLARE found_price DECIMAL(10,2);

    -- 1. Fetch the price from the food_menu table
    SELECT price INTO found_price 
    FROM food_menu 
    WHERE item_id = NEW.item_id;

    -- 2. Debug Check: If item doesn't exist, found_price will be NULL
    -- 3. Force the calculation into the subtotal column
    IF found_price IS NOT NULL THEN
        SET NEW.subtotal = found_price * NEW.quantity;
    ELSE
        -- This will throw an error so you know the item_id was wrong
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: item_id not found in food_menu';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_order_total` AFTER INSERT ON `order_detail` FOR EACH ROW UPDATE orders 
SET total_price = total_price + NEW.subtotal 
WHERE order_id = NEW.order_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'ORD-',upper(hex(random_bytes(4))))),
  `cust_id` varchar(20) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Pending','Ready For Delivery','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `address` varchar(255) NOT NULL,
  `payment` enum('cash','credit card') NOT NULL DEFAULT 'cash',
  PRIMARY KEY (`order_id`),
  KEY `fk_customer_id_idx` (`cust_id`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_orders_price` CHECK ((`total_price` >= 0)),
  CONSTRAINT `chk_payment_logic` CHECK ((((`payment` = _utf8mb4'credit card') and (`total_price` > 0)) or (`payment` = _utf8mb4'cash')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('ORD-5EE4CC73','CST-BBF89E0F','2026-04-05 23:50:16','Completed',440.00,'calumpang, gsc','cash');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_order_insert` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    DECLARE current_cust_id VARCHAR(20);

    -- Find the customer_id associated with the logged-in MySQL user
    SELECT customer_id INTO current_cust_id 
    FROM customer 
    WHERE username = SUBSTRING_INDEX(USER(), '@', 1);

    -- If the inserted cust_id doesn't match the logged-in user, block it
    -- (Skip this check if the user is an 'Administrator')
    IF current_cust_id IS NOT NULL AND NEW.cust_id <> current_cust_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: You can only create orders for yourself.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auto_assign_customer` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    DECLARE found_id VARCHAR(20);

    -- Find the ID belonging to the current MySQL user
    SELECT customer_id INTO found_id 
    FROM customer 
    WHERE username = SUBSTRING_INDEX(USER(), '@', 1);

    -- If we found an ID, set it. This prevents the customer 
    -- from accidentally (or intentionally) using someone else's ID.
    IF found_id IS NOT NULL THEN
        SET NEW.cust_id = found_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_order_update` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
    -- 1. Prevent editing completed or cancelled orders
    IF OLD.status IN ('Completed', 'Cancelled') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Locked: Cannot modify a completed or cancelled order.';
    END IF;

    -- 2. Prevent changing the cust_id (Orders shouldn't change owners)
    IF NEW.cust_id <> OLD.cust_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Security: Cannot transfer order to a different customer.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `rider_delivery_view`
--

DROP TABLE IF EXISTS `rider_delivery_view`;
/*!50001 DROP VIEW IF EXISTS `rider_delivery_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `rider_delivery_view` AS SELECT 
 1 AS `delivery_id`,
 1 AS `order_id`,
 1 AS `customer_name`,
 1 AS `address`,
 1 AS `delivery_status`,
 1 AS `customer_phone`,
 1 AS `total_price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `track_my_order`
--

DROP TABLE IF EXISTS `track_my_order`;
/*!50001 DROP VIEW IF EXISTS `track_my_order`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `track_my_order` AS SELECT 
 1 AS `cust_id`,
 1 AS `customer_name`,
 1 AS `rider_name`,
 1 AS `delivery_id`,
 1 AS `order_id`,
 1 AS `delivery_status`,
 1 AS `total_price`,
 1 AS `address`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(20) NOT NULL DEFAULT (concat(_utf8mb4'USR-',upper(hex(random_bytes(4))))),
  `customer_id` varchar(20) DEFAULT NULL,
  `cashier_id` varchar(20) DEFAULT NULL,
  `rider_id` varchar(20) DEFAULT NULL,
  `admin_id` varchar(20) DEFAULT NULL,
  `is_active` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`user_id`),
  KEY `fk_user_customer` (`customer_id`),
  KEY `fk_user_cashier` (`cashier_id`),
  KEY `fk_user_rider` (`rider_id`),
  CONSTRAINT `fk_user_cashier` FOREIGN KEY (`cashier_id`) REFERENCES `cashier` (`cashier_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_rider` FOREIGN KEY (`rider_id`) REFERENCES `delivery_rider` (`rider_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('USR-114EC0C3',NULL,'CSH-9EA39641',NULL,NULL,'Active'),('USR-14FCC627','CST-BBF89E0F',NULL,NULL,NULL,'Active'),('USR-863FBB0A',NULL,NULL,'RDR-9F62B298',NULL,'Active'),('USR-D17EB70B',NULL,NULL,NULL,'ADM-875F1D58','Active');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_order_detail`
--

DROP TABLE IF EXISTS `vw_order_detail`;
/*!50001 DROP VIEW IF EXISTS `vw_order_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_order_detail` AS SELECT 
 1 AS `order_detail_id`,
 1 AS `order_id`,
 1 AS `item_id`,
 1 AS `item_name`,
 1 AS `quantity`,
 1 AS `subtotal`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_orders`
--

DROP TABLE IF EXISTS `vw_orders`;
/*!50001 DROP VIEW IF EXISTS `vw_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_orders` AS SELECT 
 1 AS `order_id`,
 1 AS `order_date`,
 1 AS `status`,
 1 AS `total_price`,
 1 AS `address`,
 1 AS `payment`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'fooddb'
--

--
-- Dumping routines for database 'fooddb'
--

--
-- Final view structure for view `all_users`
--

/*!50001 DROP VIEW IF EXISTS `all_users`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_users` AS select `u`.`user_id` AS `user_id`,coalesce(`adm`.`username`,`csh`.`username`,`cst`.`username`,`rdr`.`username`) AS `username`,coalesce(`adm`.`email`,`csh`.`email`,`cst`.`email`,`rdr`.`email`) AS `email`,(case when (`u`.`admin_id` is not null) then 'Administrator' when (`u`.`cashier_id` is not null) then 'Cashier' when (`u`.`rider_id` is not null) then 'Rider' when (`u`.`customer_id` is not null) then 'Customer' else 'Unassigned' end) AS `role`,`u`.`is_active` AS `is_active`,coalesce(`adm`.`created_at`,`csh`.`created_at`,`cst`.`created_at`,`rdr`.`created_at`) AS `joined_at` from ((((`users` `u` left join `administrator` `adm` on((`u`.`admin_id` = `adm`.`admin_id`))) left join `cashier` `csh` on((`u`.`cashier_id` = `csh`.`cashier_id`))) left join `customer` `cst` on((`u`.`customer_id` = `cst`.`customer_id`))) left join `delivery_rider` `rdr` on((`u`.`rider_id` = `rdr`.`rider_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `delivery_tracking_center`
--

/*!50001 DROP VIEW IF EXISTS `delivery_tracking_center`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `delivery_tracking_center` AS select `d`.`delivery_id` AS `delivery_id`,`d`.`order_id` AS `order_id`,concat(`c`.`first_name`,' ',`c`.`last_name`) AS `customer_name`,`c`.`phone` AS `customer_contact`,concat(`r`.`first_name`,' ',`r`.`last_name`) AS `rider_name`,`o`.`total_price` AS `total_price`,`d`.`delivery_status` AS `delivery_status`,(case when (`d`.`delivery_status` = 'Delivering') then 'In Progress' when (`d`.`delivery_status` = 'Completed') then 'Finished' when (`d`.`delivery_status` = 'Cancelled') then 'Voided' end) AS `operational_status` from (((`delivery` `d` left join `orders` `o` on((`d`.`order_id` = `o`.`order_id`))) left join `customer` `c` on((`o`.`cust_id` = `c`.`customer_id`))) left join `delivery_rider` `r` on((`d`.`rider_id` = `r`.`rider_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rider_delivery_view`
--

/*!50001 DROP VIEW IF EXISTS `rider_delivery_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rider_delivery_view` AS select `d`.`delivery_id` AS `delivery_id`,`d`.`order_id` AS `order_id`,concat(`c`.`first_name`,' ',`c`.`last_name`) AS `customer_name`,`o`.`address` AS `address`,`d`.`delivery_status` AS `delivery_status`,`c`.`phone` AS `customer_phone`,`o`.`total_price` AS `total_price` from (((`delivery` `d` join `orders` `o` on((`d`.`order_id` = `o`.`order_id`))) join `customer` `c` on((`o`.`cust_id` = `c`.`customer_id`))) join `delivery_rider` `r` on((`d`.`rider_id` = `r`.`rider_id`))) where (`r`.`username` = substring_index(user(),'@',1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `track_my_order`
--

/*!50001 DROP VIEW IF EXISTS `track_my_order`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `track_my_order` AS select `o`.`cust_id` AS `cust_id`,concat(`c`.`first_name`,' ',`c`.`last_name`) AS `customer_name`,concat(`dr`.`first_name`,' ',`dr`.`last_name`) AS `rider_name`,`d`.`delivery_id` AS `delivery_id`,`o`.`order_id` AS `order_id`,`d`.`delivery_status` AS `delivery_status`,`o`.`total_price` AS `total_price`,`o`.`address` AS `address` from (((`orders` `o` join `delivery` `d` on((`o`.`order_id` = `d`.`order_id`))) join `customer` `c` on((`o`.`cust_id` = `c`.`customer_id`))) left join `delivery_rider` `dr` on((`d`.`rider_id` = `dr`.`rider_id`))) where (`c`.`username` = substring_index(user(),'@',1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_order_detail`
--

/*!50001 DROP VIEW IF EXISTS `vw_order_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_order_detail` AS select `od`.`order_detail_id` AS `order_detail_id`,`od`.`order_id` AS `order_id`,`od`.`item_id` AS `item_id`,`f`.`item_name` AS `item_name`,`od`.`quantity` AS `quantity`,`od`.`subtotal` AS `subtotal` from (((`order_detail` `od` join `food_menu` `f` on((`od`.`item_id` = `f`.`item_id`))) join `orders` `o` on((`od`.`order_id` = `o`.`order_id`))) join `customer` `c` on((`o`.`cust_id` = `c`.`customer_id`))) where (`c`.`username` = substring_index(user(),'@',1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_orders`
--

/*!50001 DROP VIEW IF EXISTS `vw_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_orders` AS select `o`.`order_id` AS `order_id`,`o`.`order_date` AS `order_date`,`o`.`status` AS `status`,`o`.`total_price` AS `total_price`,`o`.`address` AS `address`,`o`.`payment` AS `payment` from (`orders` `o` join `customer` `c` on((`o`.`cust_id` = `c`.`customer_id`))) where (`c`.`username` = substring_index(user(),'@',1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-15 20:34:12
