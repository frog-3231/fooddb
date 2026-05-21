

-- GRANT USAGE ON *.* TO `cashier_role`@`%`
-- GRANT SELECT ON `fooddb`.`delivery_rider` TO `cashier_role`@`%`
-- GRANT SELECT, INSERT (`delivery_status`, `order_id`, `rider_id`), UPDATE (`rider_id`) ON `fooddb`.`delivery` TO `cashier_role`@`%`
-- GRANT SELECT, UPDATE (`payment`, `status`) ON `fooddb`.`orders` TO `cashier_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`assign_delivery` TO `cashier_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_delivery_riders` TO `cashier_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_order_list` TO `cashier_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`update_order_status` TO `cashier_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`view_delivery` TO `cashier_role`@`%`

-- GRANT USAGE ON *.* TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`administrator` TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`audit_logs` TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`cashier` TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`customer` TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`delivery_rider` TO `admin_role`@`%`
-- GRANT SELECT, INSERT, UPDATE, DELETE ON `fooddb`.`food_menu` TO `admin_role`@`%`
-- GRANT SELECT ON `fooddb`.`orders` TO `admin_role`@`%`
-- GRANT SELECT, UPDATE (`is_active`) ON `fooddb`.`users` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`add_food_item_to_menu` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_audit_logs` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_user_list` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`search_food_menu` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`sp_registerunifieduser` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`update_food_item_from_menu` TO `admin_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`update_user_account_status` TO `admin_role`@`%`

-- GRANT USAGE ON *.* TO `rider_role`@`%`
-- GRANT SELECT (`delivery_status`, `order_id`), UPDATE (`delivery_status`) ON `fooddb`.`delivery` TO `rider_role`@`%`
-- GRANT SELECT ON `fooddb`.`vw_rider_delivery_tasks` TO `rider_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_assigned_delivery` TO `rider_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`update_delivery_status` TO `rider_role`@`%`

-- GRANT USAGE ON *.* TO `customer_role`@`%`
-- GRANT SELECT (`description`, `item_id`, `item_name`, `price`, `status`) ON `fooddb`.`food_menu` TO `customer_role`@`%`
-- GRANT SELECT, INSERT (`item_id`, `order_id`, `quantity`), UPDATE (`quantity`), DELETE ON `fooddb`.`order_detail` TO `customer_role`@`%`
-- GRANT SELECT (`order_id`), INSERT (`address`), UPDATE (`address`) ON `fooddb`.`orders` TO `customer_role`@`%`
-- GRANT SELECT ON `fooddb`.`vw_customer_order_tracking` TO `customer_role`@`%`
-- GRANT SELECT ON `fooddb`.`vw_my_order_details` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`add_item_to_order` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_order_details` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`browse_orders` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`delete_item_from_order` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`place_order` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`search_food_menu` TO `customer_role`@`%`
-- GRANT EXECUTE ON PROCEDURE `fooddb`.`update_item_from_order` TO `customer_role`@`%`
