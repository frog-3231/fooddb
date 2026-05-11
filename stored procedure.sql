DELIMITER //


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_RegisterUnifiedUser`(
    IN p_username VARCHAR(45),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(11),
    IN p_password VARCHAR(255), 
    IN p_first_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_role_type ENUM('admin', 'rider', 'customer', 'cashier')
)
BEGIN
    DECLARE v_user_id VARCHAR(20);

    -- 1. Insert into the Business Table (users) with encrypted password
    INSERT INTO `fooddb`.`users` (username, email, phone, password) 
    VALUES (p_username, p_email, p_phone, SHA2(p_password, 256));

    -- Capture the generated USR-HEX ID
    SET v_user_id = (SELECT user_id FROM `fooddb`.`users` WHERE username = p_username);

    -- 2. Insert into the specific Role Table
    CASE p_role_type
        WHEN 'admin' THEN
            INSERT INTO `fooddb`.`administrator` (admin_id, first_name, last_name) VALUES (v_user_id, p_first_name, p_last_name);
            SET @target_role = 'admin_role';
        WHEN 'rider' THEN
            INSERT INTO `fooddb`.`delivery_rider` (rider_id, first_name, last_name) VALUES (v_user_id, p_first_name, p_last_name);
            SET @target_role = 'rider_role';
        WHEN 'customer' THEN
            INSERT INTO `fooddb`.`customer` (customer_id, first_name, last_name) VALUES (v_user_id, p_first_name, p_last_name);
            SET @target_role = 'customer_role';
        WHEN 'cashier' THEN
            INSERT INTO `fooddb`.`cashier` (cashier_id, first_name, last_name) VALUES (v_user_id, p_first_name, p_last_name);
            SET @target_role = 'cashier_role';
    END CASE;

    -- 3. CREATE THE AUTHENTICATION ACCOUNT (New Logic)
    -- This creates the actual login for the database
    SET @create_user_sql = CONCAT('CREATE USER ', QUOTE(p_username), '@"localhost" IDENTIFIED BY ', QUOTE(p_password));
    PREPARE stmt0 FROM @create_user_sql;
    EXECUTE stmt0;
    DEALLOCATE PREPARE stmt0;

    -- 4. Grant the Database Role
    SET @grant_sql = CONCAT('GRANT ', @target_role, ' TO ', QUOTE(p_username), '@"localhost"');
    PREPARE stmt1 FROM @grant_sql;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    -- 5. Set Default Role
    SET @default_role_sql = CONCAT('SET DEFAULT ROLE ALL TO ', QUOTE(p_username), '@"localhost"');
    PREPARE stmt2 FROM @default_role_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    -- Refresh privileges
    FLUSH PRIVILEGES;

END//


DELIMITER ;