show grants for 'admin_role';

grant select on audit_logs to 'admin_role';
grant select on orders to 'admin_role';
grant select, insert, update, delete on food_menu to 'admin_role';
grant select, update(is_active) on users to 'admin_role';

flush privileges;

show grants for 'alvin_admin'@'localhost';

grant execute on procedure `sp_RegisterUnifiedUser` to 'admin_role';