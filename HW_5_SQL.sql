---Задача №1

with customer_count as (
    select 
        e.employee_id,
        e.first_name || ' ' || e.last_name as full_name,
        count(c.customer_id) as customer_count
    from 
        employee e
    LEFT join 
        customer c on e.employee_id = c.support_rep_id
    group by 
        e.employee_id
)
select 
    employee_id,
    full_name,
    customer_count,
    round((customer_count * 100.0) / sum(customer_count) over (), 2) as customer_percentage
from 
    customer_count
ORDER by 
    employee_id
;


----Задача №2

select 
    al.title as album_title,
    ar.name as artist_name
from 
    album al
join 
    artist ar on al.artist_id = ar.artist_id
left join 
    track t on al.album_id = t.album_id
left join
    invoice_line il on t.track_id = il.track_id
where 
    il.track_id is null
order by 
    album_title
;


----Задача №3

with monthly_sales as (
    select 
        c.customer_id
        , c.first_name || ' ' || c.last_name as full_name
        , extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
        , sum(i.total) as total
    from 
        customer c
    join 
        invoice i on c.customer_id = i.customer_id
    group by 
        c.customer_id, full_name, monthkey
),
monthly_percentage as (
    select 
        customer_id
        , full_name
        , monthkey
        , total
        , round(total * 100.0 / sum(total) over (partition by monthkey), 2) as month_percentage
    from 
        monthly_sales
),
cumulative_sales as (
    select 
        customer_id
        , full_name
        , monthkey
        , total
        , month_percentage
        , sum(total) over (partition by customer_id, cast(monthkey / 100 as integer) order by monthkey) as cumulative_total
    from 
        monthly_percentage
),
moving_avg as (
    select
        customer_id
        , full_name
        , monthkey
        , total
        , month_percentage
        , cumulative_total
        , avg(total) over (partition by customer_id order by monthkey rows between 2 preceding and current row) as moving_avg_3
    from 
        cumulative_sales
),
final_table as (
    select
        customer_id
        , full_name
        , monthkey
        , total
        , month_percentage
        , cumulative_total
        , moving_avg_3
        , total - lag(total, 1) over (partition by customer_id order by monthkey) as difference_from_previous
    from 
        moving_avg
)
select *
from final_table
order by customer_id, monthkey 
;

---задача №4


select 
    e.employee_id,
    e.first_name || ' ' || e.last_name as full_name
from 
    employee e
left join 
    employee sub on e.employee_id = sub.reports_to
where 
    sub.employee_id is null
order by 
    e.employee_id
;

---задача №5

select 
    c.customer_id,
    c.first_name || ' ' || c.last_name as full_name,
    min(i.invoice_date) as first_purchase_date,
    max(i.invoice_date) as last_purchase_date,
    extract(year from age(max(i.invoice_date), min(i.invoice_date))) as diff_in_years
from 
    customer c
join
    invoice i on c.customer_id = i.customer_id
group by 
    c.customer_id, full_name
;

----задача №6

with album_sales as (
    select
        al.album_id,
        al.title as album_title,
        ar.name as artist_name,
        extract(year from i.invoice_date) as sale_year,
        count(il.track_id) as track_count
    from 
        album al
    join 
        artist ar on al.artist_id = ar.artist_id
    join 
        track t on al.album_id = t.album_id
    join 
        invoice_line il on t.track_id = il.track_id
    join 
        invoice i on il.invoice_id = i.invoice_id
    group by 
        al.album_id, album_title, artist_name, sale_year
)
select 
    sale_year,
    album_title,
    artist_name,
    track_count
from (
    select 
        sale_year,
        album_title,
        artist_name,
        track_count,
        row_number() over (partition by sale_year order by track_count desc) as rank
    from 
        album_sales
) as ranked_sales
where 
    rank <= 3
;


---задача №7

select 
    t.track_id,
    t.name as track_name
from 
    track t
join
    invoice_line il on t.track_id = il.track_id
join 
    invoice i on il.invoice_id = i.invoice_id
join 
    customer c on i.customer_id = c.customer_id
where 
    c.country = 'USA'
intersect
select 
    t.track_id,
    t.name as track_name
from 
    track t
join 
    invoice_line il on t.track_id = il.track_id
join 
    invoice i on il.invoice_id = i.invoice_id
join 
    customer c on i.customer_id = c.customer_id
where 
    c.country = 'Canada'
;

---задача №8

select 
    t.track_id,
    t.name as track_name
from 
    track t
join 
    invoice_line il on t.track_id = il.track_id
join
    invoice i on il.invoice_id = i.invoice_id
join 
    customer c on i.customer_id = c.customer_id
where 
    c.country = 'Canada'
except
select 
    t.track_id,
    t.name as track_name
from 
    track t
join 
    invoice_line il on t.track_id = il.track_id
join 
    invoice i on il.invoice_id = i.invoice_id
join 
    customer c on i.customer_id = c.customer_id
where 
    c.country = 'USA'
;