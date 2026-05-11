-- showing users

select user from mysql.db where db = 'fooddb';


delete from users
where username = 'venz_customer';
select * from users;

select * from customer;

insert into users (`username`, `email`, `phone`, `password`, `roles`)
values ('april_cashier', 'april@fooddb.com', '09246571222', SHA2('april1234', 256), 'Cashier');

insert into users (`username`, `email`, `phone`, `password`, `roles`)
values ('victor_customer', 'victor@fooddb.com', '09123467878', sha2('victor1234', 256), 'Customer');

insert into users (`username`, `email`, `phone`, `password`, `roles`)
values ('dexter_rider', 'dexter@fooddb.com', '09898765213', sha2('dexter1234', 256), 'Rider');


select * from users;


