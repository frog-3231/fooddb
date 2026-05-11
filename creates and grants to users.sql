-- ==ROLES==

create role 'admin_role';
create role 'rider_role';
create role 'customer_role';
create role 'cashier_role'; 

-- ==USERS==
create user 'alvin_admin'@'localhost' identified by 'alvin1234';
create user 'dexter_rider'@'localhost' identified by 'dexter1234';
create user 'victor_customer'@'localhost' identified by 'victor1234';
create user 'april_cashier'@'localhost' identified by 'april1234'; 

-- == GRANTS ==

-- == grant roles ==

grant 'admin_role' to 'alvin_admin'@'localhost';
grant 'rider_role' to 'dexter_rider'@'localhost';
grant 'customer_role' to 'victor_customer'@'localhost';
grant 'cashier_role' to 'april_cashier'@'localhost';

 -- == admin privileges ==
grant all privileges on fooddb.* to 'admin_role';


-- == cashier privileges ==
grant select, update (`status`, payment) on fooddb.orders to 'cashier_role';

revoke delete on orders from 'cashier_role';
show grants for cashier_role;
revoke update on orders from 'cashier_role';

grant select, update (`rider_id`) on fooddb.delivery to 'cashier_role';
grant select on fooddb.delivery_rider to 'cashier_role';

show grants for 'cashier_role';
-- == customer privileges == 

grant insert (order_id, item_id, quantity), update (quantity), delete on fooddb.order_detail to 'customer_role';
grant insert (address), update(address) on fooddb.orders to 'customer_role';
grant select on fooddb.food_menu to 'customer_role';
grant select on vw_customer_order_tracking to 'customer_role';
grant select on vw_my_order_details to customer_role;

show grants for customer_role;
-- == rider privileges == 


grant select (delivery_status), update(delivery_status) on delivery to 'rider_role';
grant select on fooddb.vw_rider_delivery_tasks to 'rider_role';
show grants for rider_role;
-- == defaults == 
SET DEFAULT ROLE ALL TO 'alvin_admin'@'localhost';
SET DEFAULT ROLE ALL TO 'dexter_rider'@'localhost';
SET DEFAULT ROLE ALL TO 'victor_customer'@'localhost';
SET DEFAULT ROLE ALL TO 'april_cashier'@'localhost';

flush privileges;

select * from users;
