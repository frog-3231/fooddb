-- == ORDERS ==

DELIMITER //

CREATE TRIGGER trg_AutoAssignOrderCustomer
BEFORE INSERT ON `fooddb`.`orders`
FOR EACH ROW
BEGIN
    DECLARE v_uid VARCHAR(20);

    -- Find the HEX ID for the person currently logged in
    SELECT user_id INTO v_uid 
    FROM `fooddb`.`users` 
    WHERE username = SUBSTRING_INDEX(SESSION_USER(), '@', 1);

    -- Automatically set the customer_id column
    SET NEW.customer_id = v_uid;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_PreventInactiveOrders
BEFORE INSERT ON `fooddb`.`orders`
FOR EACH ROW
BEGIN
    DECLARE v_active_status TINYINT;

    -- Check the status of the user attempting to order
    SELECT is_active INTO v_active_status 
    FROM `fooddb`.`users` 
    WHERE user_id = NEW.customer_id;

    -- If the account is inactive/banned, block the insert
    IF v_active_status = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order Rejected: This account has been deactivated or banned by an administrator.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_ProtectOrderModification
BEFORE UPDATE ON fooddb.orders
FOR EACH ROW
BEGIN
    IF CURRENT_ROLE() LIKE '%customer_role%' THEN
        IF OLD.customer_id != SUBSTRING_INDEX(USER(), '@', 1) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security Alert: Unauthorized access.';
        END IF;
    END IF;
END //

DELIMITER ;


DELIMITER //
CREATE TRIGGER trg_AutoCreateDelivery
AFTER UPDATE ON `orders`
FOR EACH ROW
BEGIN
    -- Only create a delivery record if one doesn't exist and status is 'Ready For Delivery'
    IF NEW.status = 'Ready For Delivery' AND OLD.status != 'Ready For Delivery' THEN
        -- Check if a delivery record already exists to prevent duplicate key errors
        IF NOT EXISTS (SELECT 1 FROM `delivery` WHERE order_id = NEW.order_id) THEN
            INSERT INTO `delivery` (order_id, delivery_status)
            VALUES (NEW.order_id, 'Delivering');
        END IF;
    END IF;
END //
DELIMITER ;

-- == USERS == 
DELIMITER //


DELIMITER //

CREATE TRIGGER trg_ProtectUsers
BEFORE UPDATE ON `fooddb`.`users`
FOR EACH ROW
BEGIN
    -- Apply restriction to Customers, Riders, and Cashiers
    IF CURRENT_ROLE() LIKE '%customer_role%' 
       OR CURRENT_ROLE() LIKE '%rider_role%' 
       OR CURRENT_ROLE() LIKE '%cashier_role%' THEN
        
        -- Block the update if the username doesn't match the person logged in
        IF OLD.username != SUBSTRING_INDEX(USER(), '@', 1) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Security Alert: Access Denied. You can only modify your own account.';
        END IF;
    END IF;
END //

DELIMITER ;

DELIMITER ;


-- customer


DELIMITER //

CREATE TRIGGER trg_ProtectCustomerProfile
BEFORE UPDATE ON `fooddb`.`customer`
FOR EACH ROW
BEGIN
    DECLARE v_username_of_record VARCHAR(45);
    DECLARE v_session_user VARCHAR(45);

    -- 1. Get the owner of the record we are trying to change
    SELECT username INTO v_username_of_record 
    FROM `fooddb`.`users` 
    WHERE user_id = OLD.customer_id;

    -- 2. Get the current logged in user (using SESSION_USER() for better accuracy)
    SET v_session_user = SUBSTRING_INDEX(SESSION_USER(), '@', 1);

    -- 3. The Security Logic
    -- If the record owner is not the session user, check role status
    IF v_username_of_record != v_session_user THEN
        
        -- If the user is NOT an admin, they MUST be the owner to proceed
        IF NOT EXISTS (SELECT 1 FROM mysql.role_edges WHERE TO_USER = v_session_user AND FROM_USER = 'admin_role') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CRITICAL SECURITY ERROR: You are attempting to modify a profile you do not own.';
        END IF;
        
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_LockOrderAddress
BEFORE UPDATE ON `orders`
FOR EACH ROW
BEGIN
    -- Check if the address is actually being changed
    IF NEW.address <> OLD.address THEN
        -- If the status is NOT 'Pending', block the address change
        IF OLD.status != 'Pending' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Address Update Denied: Cannot change delivery address once the order is being processed or delivered.';
        END IF;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_LockFinishedOrders_Update
BEFORE UPDATE ON `order_detail`
FOR EACH ROW
BEGIN
    DECLARE v_order_status VARCHAR(20);

    -- 1. Check the current status of the parent order
    SELECT status INTO v_order_status 
    FROM `orders` 
    WHERE order_id = OLD.order_id;

    -- 2. If the order is beyond the 'Pending' stage, block all changes
    IF v_order_status IN ('Ready For Delivery', 'Completed', 'Cancelled') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction Denied: Cannot modify items because the order is already being processed or is finished.';
    END IF;
END //

DELIMITER ;


-- == cashier == 

DELIMITER //

CREATE TRIGGER trg_ProtectCashierProfile
BEFORE UPDATE ON `fooddb`.`cashier`
FOR EACH ROW
BEGIN
    DECLARE v_username_of_record VARCHAR(45);

    -- Find the username linked to this cashier_id
    SELECT username INTO v_username_of_record 
    FROM `fooddb`.`users` 
    WHERE user_id = OLD.cashier_id;

    -- If a Cashier is trying to edit a profile that isn't theirs, block it
    IF CURRENT_ROLE() LIKE '%cashier_role%' THEN
        IF v_username_of_record != SUBSTRING_INDEX(USER(), '@', 1) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Security Alert: You are not authorized to edit another staff member\'s profile.';
        END IF;
    END IF;
END //

DELIMITER ;

-- == rider == 
DELIMITER //

CREATE TRIGGER trg_ProtectRiderProfile
BEFORE UPDATE ON `fooddb`.`delivery_rider`
FOR EACH ROW
BEGIN
    DECLARE v_username_of_record VARCHAR(45);

    -- 1. Find the username linked to this rider_id
    SELECT username INTO v_username_of_record 
    FROM `fooddb`.`users` 
    WHERE user_id = OLD.rider_id;

    -- 2. Check if the user is a Rider
    IF CURRENT_ROLE() LIKE '%rider_role%' THEN
        -- 3. If they don't own this record, block the update
        IF v_username_of_record != SUBSTRING_INDEX(USER(), '@', 1) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Security Alert: You cannot modify another rider\'s profile data.';
        END IF;
    END IF;
END //

DELIMITER ;

-- == Order Details == 
DELIMITER //

-- Step A: Calculate Subtotal BEFORE the record is saved
CREATE TRIGGER trg_CalcSubtotalBeforeInsert
BEFORE INSERT ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    DECLARE v_item_price DECIMAL(10,2);

    -- Fetch price from food_menu using the FOD- item_id
    SELECT price INTO v_item_price 
    FROM `fooddb`.`food_menu` 
    WHERE item_id = NEW.item_id;

    -- Calculate subtotal (Price * Quantity)
    SET NEW.subtotal = v_item_price * NEW.quantity;
END //

-- Step B: Update the Order Total AFTER the detail is saved
CREATE TRIGGER trg_UpdateOrderTotalAfterInsert
AFTER INSERT ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    UPDATE `fooddb`.`orders`
    SET total_price = (
        SELECT SUM(subtotal) 
        FROM `fooddb`.`order_detail` 
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;

DELIMITER //

-- Handle Quantity Changes
CREATE TRIGGER trg_UpdateOrderTotalAfterUpdate
AFTER UPDATE ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    UPDATE `fooddb`.`orders`
    SET total_price = (
        SELECT SUM(subtotal) 
        FROM `fooddb`.`order_detail` 
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END //

-- Handle Item Removal
CREATE TRIGGER trg_UpdateOrderTotalAfterDelete
AFTER DELETE ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    UPDATE `fooddb`.`orders`
    SET total_price = IFNULL(
        (SELECT SUM(subtotal) FROM `fooddb`.`order_detail` WHERE order_id = OLD.order_id), 
        0.00
    )
    WHERE order_id = OLD.order_id;
END //

DELIMITER ;
DELIMITER //

-- 1. Handle Subtotal on Insert
CREATE TRIGGER trg_CalcSubtotalBeforeInsert
BEFORE INSERT ON `fooddb`.`order_detail` -- Corrected Name
FOR EACH ROW
BEGIN
    DECLARE v_item_price DECIMAL(10,2);
    SELECT price INTO v_item_price FROM `fooddb`.`food_menu` WHERE item_id = NEW.item_id;
    SET NEW.subtotal = v_item_price * NEW.quantity;
END //

-- 2. Handle Subtotal on Update (In case they change quantity)
CREATE TRIGGER trg_CalcSubtotalBeforeUpdate
BEFORE UPDATE ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    DECLARE v_item_price DECIMAL(10,2);
    SELECT price INTO v_item_price FROM `fooddb`.`food_menu` WHERE item_id = NEW.item_id;
    SET NEW.subtotal = v_item_price * NEW.quantity;
END //

-- 3. Sync the Grand Total to the Orders table
CREATE TRIGGER trg_SyncOrderTotal
AFTER INSERT ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    UPDATE `fooddb`.`orders`
    SET total_price = (
        SELECT IFNULL(SUM(subtotal), 0) 
        FROM `fooddb`.`order_detail` 
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_HandleOrderCalculations
BEFORE INSERT ON `order_detail` -- Note: Changed to BEFORE to calculate subtotal first
FOR EACH ROW
BEGIN
    DECLARE v_item_price DECIMAL(10,2);

    -- 1. Fetch the official price from the menu
    SELECT price INTO v_item_price 
    FROM `fooddb`.`food_menu` 
    WHERE item_id = NEW.item_id;

    -- 2. Calculate the subtotal for this specific row
    SET NEW.subtotal = v_item_price * NEW.quantity;
END //

DELIMITER ;


-- == Delivery == 


DELIMITER //
CREATE TRIGGER trg_SyncDeliveryToOrder
AFTER UPDATE ON `delivery`
FOR EACH ROW
BEGIN
    -- Only sync back to orders if the delivery is truly completed
    IF NEW.delivery_status = 'Completed' AND OLD.delivery_status != 'Completed' THEN
        UPDATE `orders` 
        SET status = 'Completed' 
        WHERE order_id = NEW.order_id 
        AND status != 'Completed';
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_LockOrderDetails
BEFORE INSERT ON `fooddb`.`order_detail`
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(50);
    
    SELECT status INTO v_status FROM `fooddb`.`orders` WHERE order_id = NEW.order_id;
    
    IF v_status IN ('Ready For Delivery', 'Completed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order Lockdown: Cannot add items to an order in delivery.';
    END IF;
END //

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_SyncDeliveryToOrder
AFTER UPDATE ON delivery
FOR EACH ROW
BEGIN
    -- If Rider marks it Completed, Order is marked Completed automatically
    IF NEW.delivery_status = 'Completed' AND OLD.delivery_status != 'Completed' THEN
        UPDATE `fooddb`.`orders` 
        SET status = 'Completed' 
        WHERE order_id = NEW.order_id 
        AND status != 'Completed'; -- Loop Prevention
    END IF;
END $$

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_SyncOrderToDelivery
AFTER UPDATE ON `orders`
FOR EACH ROW
BEGIN
    -- 1. Create the delivery record if status moves to 'Ready For Delivery'
    IF NEW.status = 'Ready For Delivery' AND OLD.status != 'Ready For Delivery' THEN
        IF NOT EXISTS (SELECT 1 FROM `delivery` WHERE order_id = NEW.order_id) THEN
            INSERT INTO `delivery` (order_id, delivery_status)
            VALUES (NEW.order_id, 'Delivering');
        END IF;
    END IF;

    -- 2. Sync Cancellation: If Order is Cancelled, Delivery is Cancelled
    IF NEW.status = 'Cancelled' AND OLD.status != 'Cancelled' THEN
        UPDATE `delivery` 
        SET delivery_status = 'Cancelled' 
        WHERE order_id = NEW.order_id 
        AND delivery_status != 'Cancelled';
    END IF;
END //

DELIMITER ;
-- ==================AUDIT LOGS====================================


-- 1. Food Menu
DELIMITER //
CREATE TRIGGER trg_AuditMenuUpdate
AFTER UPDATE ON `food_menu`
FOR EACH ROW
BEGIN
    DECLARE v_desc VARCHAR(255) DEFAULT 'Menu Item Updated';
    
    IF OLD.price != NEW.price THEN 
        SET v_desc = CONCAT('Price changed for ', OLD.item_name, ' (', OLD.price, ' -> ', NEW.price, ')');
    ELSEIF OLD.status != NEW.status THEN 
        SET v_desc = CONCAT(OLD.item_name, ' status changed to ', NEW.status);
    END IF;

    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data, new_data)
    VALUES ('food_menu', 'UPDATE', v_desc, OLD.item_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('price', OLD.price, 'status', OLD.status), 
            JSON_OBJECT('price', NEW.price, 'status', NEW.status));
END //

-- Menu Insertion
CREATE TRIGGER trg_AuditMenuInsert AFTER INSERT ON `food_menu` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, new_data)
    VALUES ('food_menu', 'INSERT', CONCAT('New menu item added: ', NEW.item_name), NEW.item_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('price', NEW.price, 'status', NEW.status));
END //


-- Menu Deletion
CREATE TRIGGER trg_AuditMenuDelete AFTER DELETE ON `food_menu` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('food_menu', 'DELETE', CONCAT('Item removed: ', OLD.item_name), OLD.item_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('price', OLD.price, 'description', OLD.description));
END //
DELIMITER ;


-- 2. Delivery
DELIMITER //
CREATE TRIGGER trg_AuditDeliveryUpdate
AFTER UPDATE ON `delivery`
FOR EACH ROW
BEGIN
    DECLARE v_desc VARCHAR(255) DEFAULT 'Delivery Update';
    
    IF OLD.rider_id IS NULL AND NEW.rider_id IS NOT NULL THEN
        SET v_desc = 'Rider assigned to order';
    ELSEIF OLD.delivery_status != NEW.delivery_status THEN
        SET v_desc = CONCAT('Delivery status changed to ', NEW.delivery_status);
    END IF;

    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data, new_data)
    VALUES ('delivery', 'UPDATE', v_desc, OLD.delivery_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('rider', OLD.rider_id, 'status', OLD.delivery_status), 
            JSON_OBJECT('rider', NEW.rider_id, 'status', NEW.delivery_status));
END //

CREATE TRIGGER trg_AuditDeliveryDelete AFTER DELETE ON `delivery` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('delivery', 'DELETE', 'Delivery record deleted', OLD.delivery_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('order_id', OLD.order_id, 'rider_id', OLD.rider_id));
END //

CREATE TRIGGER trg_AuditDeliveryInsert AFTER INSERT ON `delivery` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, new_data)
    VALUES ('delivery', 'INSERT', 'New delivery record initialized', NEW.delivery_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('order_id', NEW.order_id, 'status', NEW.delivery_status));
END //
DELIMITER ;


-- 3. Orders


DELIMITER //

CREATE TRIGGER trg_AuditOrdersDetailed
AFTER UPDATE ON `orders`
FOR EACH ROW
BEGIN
    DECLARE v_description VARCHAR(255);
    SET v_description = 'General Update';

    -- Logic to determine the "Kind of Change"
    IF OLD.status != NEW.status THEN
        SET v_description = CONCAT('Status changed from ', OLD.status, ' to ', NEW.status);
    ELSEIF OLD.total_price != NEW.total_price THEN
        SET v_description = 'Order total updated/recalculated';
    ELSEIF OLD.payment != NEW.payment THEN
        SET v_description = 'Payment status modified';
    END IF;

    INSERT INTO audit_logs (
        table_name, 
        action_type, 
        description,
        record_id, 
        changed_by, 
        old_data, 
        new_data
    )
    VALUES (
        'orders',
        'UPDATE',
        v_description,
        OLD.order_id,
        SUBSTRING_INDEX(USER(), '@', 1),
        JSON_OBJECT('status', OLD.status, 'price', OLD.total_price),
        JSON_OBJECT('status', NEW.status, 'price', NEW.total_price)
    );
END //

CREATE TRIGGER trg_AuditOrderDelete AFTER DELETE ON `orders` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('orders', 'DELETE', 'Order permanently removed from system', OLD.order_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('customer_id', OLD.customer_id, 'total_price', OLD.total_price));
END //

CREATE TRIGGER trg_AuditOrderInsert
AFTER INSERT ON `orders`
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (
        table_name, 
        action_type, 
        description, 
        record_id, 
        changed_by, 
        new_data
    )
    VALUES (
        'orders',
        'INSERT',
        CONCAT('New order placed for address: ', NEW.address),
        NEW.order_id,
        SUBSTRING_INDEX(USER(), '@', 1),
        JSON_OBJECT(
            'customer_id', NEW.customer_id,
            'initial_price', NEW.total_price,
            'status', NEW.status
        )
    );
END //

DELIMITER ;

-- 4. Profiles

-- 4.1. Customer

DELIMITER //

-- INSERT
CREATE TRIGGER trg_AuditCustomerInsert AFTER INSERT ON `customer` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, new_data)
    VALUES ('customer', 'INSERT', 'New customer profile registered', NEW.customer_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- UPDATE
CREATE TRIGGER trg_AuditCustomerUpdate AFTER UPDATE ON `customer` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data, new_data)
    VALUES ('customer', 'UPDATE', 'Customer name/details modified', OLD.customer_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- DELETE
CREATE TRIGGER trg_AuditCustomerDelete AFTER DELETE ON `customer` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('customer', 'DELETE', 'Customer profile removed from system', OLD.customer_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)));
END //

DELIMITER ;
-- 4.2. Cashier
DELIMITER //

-- INSERT
CREATE TRIGGER trg_AuditCashierInsert AFTER INSERT ON `cashier` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, new_data)
    VALUES ('cashier', 'INSERT', 'New cashier profile registered', NEW.cashier_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- UPDATE
CREATE TRIGGER trg_AuditCashierUpdate AFTER UPDATE ON `cashier` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data, new_data)
    VALUES ('cashier', 'UPDATE', 'Cashier name/details modified', OLD.cashier_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- DELETE
CREATE TRIGGER trg_AuditCashierDelete AFTER DELETE ON `cashier` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('cashier', 'DELETE', 'Cashier profile removed from system', OLD.cashier_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)));
END //

DELIMITER ;


-- 4.3. Rider
DELIMITER //

-- INSERT
CREATE TRIGGER trg_AuditRiderInsert AFTER INSERT ON `delivery_rider` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, new_data)
    VALUES ('delivery_rider', 'INSERT', 'New rider profile registered', NEW.rider_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- UPDATE
CREATE TRIGGER trg_AuditRiderUpdate AFTER UPDATE ON `delivery_rider` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data, new_data)
    VALUES ('delivery_rider', 'UPDATE', 'Rider name/details modified', OLD.rider_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)), 
            JSON_OBJECT('name', CONCAT(NEW.first_name, ' ', NEW.last_name)));
END //

-- DELETE
CREATE TRIGGER trg_AuditRiderDelete AFTER DELETE ON `delivery_rider` FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, action_type, description, record_id, changed_by, old_data)
    VALUES ('delivery_rider', 'DELETE', 'Rider profile removed from system', OLD.rider_id, SUBSTRING_INDEX(USER(), '@', 1), 
            JSON_OBJECT('name', CONCAT(OLD.first_name, ' ', OLD.last_name)));
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_ProtectOrderDetailInsert
BEFORE INSERT ON `order_detail`
FOR EACH ROW
BEGIN
    DECLARE v_order_owner_id VARCHAR(20);
    DECLARE v_session_user_id VARCHAR(20);

    -- 1. Find out who actually owns the order being targeted
    SELECT customer_id INTO v_order_owner_id 
    FROM `orders` 
    WHERE order_id = NEW.order_id;

    -- 2. Find the user_id of the person currently logged in
    SELECT user_id INTO v_session_user_id 
    FROM `users` 
    WHERE username = SUBSTRING_INDEX(USER(), '@', 1);

    -- 3. Security Check: 
    -- If the logged-in user is NOT the owner of the order, block the insert.
    -- (We allow it to pass if they are an Admin or Cashier, depending on your needs)
    IF v_order_owner_id != v_session_user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission Denied: You cannot add items to an order that belongs to another customer.';
    END IF;
END //

DELIMITER ;