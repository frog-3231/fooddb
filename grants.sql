-- grants for cashier
GRANT SELECT (`phone`, `rider_id`, `username`) ON `fooddb`.`delivery_rider` TO `cashier_role`;
GRANT SELECT, INSERT, UPDATE (`rider_id`) ON `fooddb`.`delivery` TO `cashier_role`@`%`;
GRANT SELECT, UPDATE (`status`) ON `fooddb`.`orders` TO `cashier_role`@`%`;

-- grants for customer
GRANT SELECT ON `fooddb`.`food_menu` TO `customer_role`@`%`;
GRANT INSERT, UPDATE ON `fooddb`.`order_detail` TO `customer_role`@`%`;
GRANT INSERT, UPDATE ON `fooddb`.`orders` TO `customer_role`@`%`;
GRANT SELECT ON `fooddb`.`track_my_order` TO `customer_role`@`%`;
GRANT SELECT ON `fooddb`.`vw_order_detail` TO `customer_role`@`%`;
GRANT SELECT ON `fooddb`.`vw_orders` TO `customer_role`@`%`;
-- grants for rider
GRANT SELECT, UPDATE (`delivery_status`) ON `fooddb`.`delivery` TO `rider_role`@`%`;
GRANT SELECT ON `fooddb`.`rider_delivery_view` TO `rider_role`@`%`;

-- something
