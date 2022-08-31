create database dvd_rental

use dvd_rental

show tables

select * from actor 
desc actor 

select * from category
desc category 

select * from film 
desc film 

select * from film_actor  
desc film_actor 

select * from payment 
desc payment

select * from rental 
desc rental 

select * from customer
desc customer

# Mengubah tipe data dan menambah PK dan FK 
alter table actor add primary key (actor_id)
alter table actor modify column last_update timestamp;

alter table category add primary key (category_id)
alter table category modify column last_update timestamp;

alter table film add primary key (film_id)
alter table film modify column language_id varchar(50);
alter table film modify column rental_rate int;
alter table film modify column release_year int;
alter table film modify column replacement_cost int;
alter table film modify column last_update timestamp;
alter table film add foreign key (category_id) references category (category_id)
ALTER TABLE film DROP COLUMN language_id
ALTER TABLE film DROP COLUMN original_language_id

alter table film_actor add primary key (film_id, actor_id)
alter table film_actor add foreign key (actor_id) references actor (actor_id)
alter table film_actor add foreign key (film_id) references film (film_id)
alter table film_actor modify column last_update timestamp;

alter table payment add primary key (payment_id)
alter table payment modify column payment_date datetime;
alter table payment modify column last_update timestamp;
alter table payment modify column rental_id int;
alter table payment add foreign key (rental_id) references rental (rental_id)

alter table rental add primary key (rental_id)
alter table rental modify column rental_date datetime;
alter table rental modify column last_update timestamp;
alter table rental add foreign key (film_id) references film (film_id)
alter table rental add foreign key (customer_id) references customer (customer_id)
ALTER TABLE rental DROP COLUMN inventory_id

alter table customer add primary key (customer_id)
alter table customer modify column create_date timestamp;

delete from payment  WHERE rental_id in (select rental_id  FROM  rental r 
WHERE return_date = (SELECT min(return_date) from rental r2 )
)

delete from rental WHERE return_date  = ''

ALTER TABLE rental 
MODIFY COLUMN return_date datetime
