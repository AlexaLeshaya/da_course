select 
    e.employee_id,
    e.first_name || ' ' || e.last_name as full_name,
    e.title,
    e.reports_to as manager_id,
    m.first_name || ' ' || m.last_name as manager_name,
    m.title as manager_position
from
    employee e
left join 
    employee m on e.reports_to = m.employee_id
order by 
    e.employee_id
;


with avg_invoice_2023 as (
    select AVG(total) as avg_total_2023
    from invoice
    where extract(year from invoice_date) = 2023
)
select
    invoice_id,
    invoice_date,
    extract(year from invoice_date) * 100 + extract(month from invoice_date) as monthkey,
    customer_id,
    total
from 
    invoice
where 
    total > (select avg_total_2023 from avg_invoice_2023)
    and extract(year from invoice_date) = 2023
;


with avg_invoice_2023 as (
    select AVG(total) as avg_total_2023
    from invoice
    where extract(year from invoice_date) = 2023
)
select
    i.invoice_id,
    i.invoice_date,
    extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey,
    i.customer_id,
    i.total,
    c.email
from 
    invoice i
join 
    customer c on i.customer_id = c.customer_id
where 
    i.total > (select avg_total_2023 from avg_invoice_2023)
    and extract(year from i.invoice_date) = 2023
;


with avg_invoice_2023 as (
    select AVG(total) as avg_total_2023
    from invoice
    where extract(year from invoice_date) = 2023
)
select 
    i.invoice_id,
    i.invoice_date,
    extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey,
    i.customer_id,
    i.total,
    c.email
from
    invoice i
join 
    customer c on i.customer_id = c.customer_id
where 
    i.total > (select avg_total_2023 from avg_invoice_2023)
    and extract(year from i.invoice_date) = 2023
    and not c.email like '%@gmail.com'
;


with total_revenue_2024 as (
    select SUM(total) as revenue_2024
    from invoice
    where extract(year from invoice_date) = 2024
)
select 
    invoice_id,
    total,
    (total / (select revenue_2024 from total_revenue_2024) * 100) as revenue_percentage
from 
    invoice
where 
    extract(year from invoice_date) = 2024
;

with total_revenue_2024 as (
    select SUM(total) as revenue_2024
    from invoice
    where extract(year from invoice_date) = 2024
)
select 
    customer_id,
    SUM(total) as customer_total,
    (SUM(total) / (select revenue_2024 from total_revenue_2024) * 100) as customer_revenue_percentage
from 
    invoice
where 
    extract(year from invoice_date) = 2024
group by 
    customer_id
order by 
    customer_revenue_percentage desc
;




