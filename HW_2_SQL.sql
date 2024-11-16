select 
	phone 
from customer
where phone not like '%(%' and phone not like '%)%'
;

select 
	initcap(substr('lorem ipsum', 1, 1)) || lower(substr('lorem ipsum', 2)) as formatted_text
;

select
	name 
from track
where name ilike '%run%'
;


select 
	first_name
	, last_name
	, email 
from customer
where email like '%@gmail.com'
;

select 
	name 
from track
order by length(name) desc
limit 1
;


select extract(month from invoice_date) as month_id
	, sum(total) as sales_sum
from invoice
where extract(year from invoice_date) = 2021
group by month_id
order by month_id
;


select extract(month from invoice_date) as month_id,
       to_char(invoice_date, 'month') as month_name,
       sum(total) as sales_sum
from invoice
where extract(year from invoice_date) = 2021
group by month_id, month_name
order by month_id
;

select first_name || ' ' || last_name as full_name
	, birth_date AS birth_date
	, extract(year from age(current_date, birth_date)) as age_now
from employee
order by age_now desc
limit 3
;

select 
	avg(extract(year from age((current_date + interval '3 years 4 months'), birth_date))) as avg_age_future
from employee
;

select extract(month from invoice_date) as sale_year
	, billing_country
	, sum(total) as sales_sum
from invoice
group by 
	sale_year
	, billing_country
having sum(total) > 20
order by 
	sale_year asc
	, sales_sum desc 
;

