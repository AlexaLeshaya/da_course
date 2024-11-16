/*
Александра Лешукович
Описание задачи: Домашнее задание по SQL, выполнение запросов по манипуляции и выборке данных из таблицы track.
*/


select 
	name
	, genre_id
from track
;


select
	name as song
	, unit_price as price
	, composer as author 
from track
;


select
	name
	, (milliseconds / 60000.0) as duration_min 
from track
order by
	duration_min desc
;


select
	name
	, genre_id 
from track
limit 15
;


select * 
from track
offset 49
;


select 
	name 
from track
where bytes > 100 * 1024 * 1024
;


select 
	name
	, composer 
from track
where composer <> 'U2'
limit 11 offset 9
;

select 
	MIN(invoice_date) as first_purchase
	, MAX(invoice_date) as last_purchase 
from invoice
;


select 
	avg(total) as avg_total 
from invoice
where billing_country = 'USA'
;


select 
	city
from customer
group by city
having 
	COUNT(customer_id) > 1
;



