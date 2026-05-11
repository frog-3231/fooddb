CREATE OR REPLACE VIEW vw_customer_order_tracking AS
SELECT 
    o.customer_id,
    o.order_id,
    o.order_date,
    o.total_price,
    o.status AS 'order_status',
    d.delivery_status,
    dr.first_name AS 'rider_name', 
    o.payment,
    o.address
FROM `fooddb`.`orders` o
INNER JOIN `fooddb`.`users` u ON o.customer_id = u.user_id
LEFT JOIN `fooddb`.`delivery` d ON o.order_id = d.order_id
LEFT JOIN `fooddb`.`delivery_rider` dr ON d.rider_id = dr.rider_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

CREATE OR REPLACE ALGORITHM=UNDEFINED 
DEFINER=`root`@`localhost` 
SQL SECURITY DEFINER VIEW `vw_rider_delivery_tasks` AS 
SELECT 
    `d`.`rider_id` AS `rider_id`,
    `d`.`order_id` AS `order_id`,
    `o`.`address` AS `delivery_address`,
    `u_cust`.`phone` AS `customer_contact`, -- Customer's phone
    `o`.`total_price` AS `cod_amount`,
    `d`.`delivery_status` AS `delivery_status`,
    `fm`.`item_name` AS `item_name`,
    `od`.`quantity` AS `quantity` 
FROM `delivery` `d` 
JOIN `orders` `o` ON `d`.`order_id` = `o`.`order_id`
JOIN `users` `u_cust` ON `o`.`customer_id` = `u_cust`.`user_id` -- Join for customer info
JOIN `users` `u_rider` ON `d`.`rider_id` = `u_rider`.`user_id` -- NEW: Join for rider info
JOIN `order_detail` `od` ON `o`.`order_id` = `od`.`order_id`
JOIN `food_menu` `fm` ON `od`.`item_id` = `fm`.`item_id`
WHERE `u_rider`.`username` = SUBSTRING_INDEX(USER(), '@', 1); -- Filter by Username



CREATE OR REPLACE VIEW `vw_customer_profile` AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.phone,
    c.first_name,
    c.last_name,
    u.created_at
FROM `fooddb`.`users` u
JOIN `fooddb`.`customer` c ON u.user_id = c.customer_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1) -- Match the session to the username column
   OR CURRENT_ROLE() LIKE '%admin_role%';
select * from customer;


CREATE OR REPLACE VIEW vw_my_order_details AS
SELECT 
    od.order_detail_id,
    od.order_id,
    fm.item_name,
    od.quantity,
    od.subtotal,
    o.order_date,
    o.status AS order_status
FROM 
    order_detail od
JOIN 
    orders o ON od.order_id = o.order_id
JOIN 
    food_menu fm ON od.item_id = fm.item_id
JOIN 
    users u ON o.customer_id = u.user_id
WHERE 
    u.username = SUBSTRING_INDEX(USER(), '@', 1);