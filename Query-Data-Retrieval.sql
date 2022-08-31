# ----DATA RETRIEVAL
select film_id, title, rating, category_id 
from film f 
where rating = 'PG'
limit 5

select film_id, title, rating, name as genre
from film f 
inner join category c on f.category_id = c.category_id 
where rating = 'PG'
order by film_id desc
limit 5

# CTE, seperti membuat function. pakai function ini sebelum di join udah ambil 5, kalo pakai limit nanti tetep nampilin semua karna limit baru diproses di akhir
with film_top5 as (
	SELECT film_id, title, rating, category_id
	from film f 
	WHERE rating = 'PG'
	limit 5
)

SELECT *
FROM film_top5 f
inner join category c on f.category_id = c.category_id

# left join, akan mengikuti tabel kiri (kategori ada 19, jd yang gaada filmnya isi null)
with film_top5 as (
	SELECT film_id, title, rating, category_id
	from film f 
	WHERE rating = 'PG'
	limit 5
)

SELECT *
FROM category c
left join film_top5 f on f.category_id = c.category_id

# CTE baru, inner bakal ambil id yang sama, outer=semua yg dipunyai kiri + semua yg dipunyai kanan
with film_top5 as (
	SELECT film_id, title, rating, category_id
	from film f 
	WHERE rating = 'PG'
	limit 5
)
, category_subset as (
	select *
	from category c 
	where category_id in (1,2,6,7,11,12)
)

SELECT *
FROM film_top5 f 
inner join category_subset c on f.category_id = c.category_id

# in, not in
select *
from category c 
where category_id not in (1,2,6,7,11,12)

# group by = agregrasi, bisa untuk mencari insight
select * from rental 

select film_id, title, name as genre
from film f left join category c on f.category_id = c.category_id 

	# mengetahui jumlah film tiap genre
with all_films as (
	select film_id, title, name as genre
	from film f left join category c on f.category_id = c.category_id
)

select genre, count(film_id) as total_film 
from all_films
group by genre
order by total_film desc

	# mengetahui jumlah genre anim + children
with all_films as (
	select film_id, title, name as genre
	from film f left join category c on f.category_id = c.category_id
)
, total_genre as(
	select genre, count(film_id) as total_film 
	from all_films
	group by genre
	order by total_film desc
)

select sum(total_film) as animation_and_children 
from total_genre
where genre in ('Animation','Children')

	# menjoin 3 table sekaligus = payment, rental, customer dengan inti payment
select p.payment_id, p.amount, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 

	# mengetahui customer mana yang paling banyak rental film
with rental_customer as ( 
select p.payment_id, p.amount, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 
)

select customer_id, first_name, last_name, sum(amount) as total_value 
from rental_customer
group by customer_id, first_name, last_name
order by total_value desc

	# mengetahui customer mana yang paling sering rental film
with rental_customer as ( 
select p.payment_id, p.amount, r.rental_id, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 
)

select customer_id, first_name, last_name, count(distinct rental_id) as total_rental 
from rental_customer
group by customer_id, first_name, last_name
order by total_rental desc

	# mengetahui rata-rata customer spent untuk rental
with rental_customer as ( 
select p.payment_id, p.amount, r.rental_id, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 
)

select customer_id, first_name, last_name, avg(amount) as avg_value
from rental_customer
group by customer_id, first_name, last_name
order by avg_value desc

	# mengetahui amount tiap film
with rental_customer as ( 
select p.payment_id, p.amount, r.rental_id, r.film_id, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 
)

select distinct film_id, amount
from rental_customer
order by film_id

	# mengetahui harga rental termahal dan customernya
with rental_customer as ( 
select p.payment_id, p.amount, r.rental_id, r.film_id, r.customer_id, c.first_name, c.last_name  
from payment p 
left join rental r on p.rental_id = r.rental_id 
left join customer c on r.customer_id = c.customer_id 
)

select customer_id, amount
from rental_customer
where amount = (
	select max(amount)
	from rental_customer
)
