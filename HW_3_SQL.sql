create table students (
	student_id serial primary key
    , student_name VARCHAR(100) not null
    , username VARCHAR(50) unique
    , bio TEXT
    , mobile VARCHAR(20)
    , has_picture BOOLEAN
)
;


--create index idx_username on students(username);


insert into students (student_id, student_name, username, bio, mobile, has_picture)
values 
 (1,'Jamik B.', '@Jamik2306', 'Могуч пахуч и волосат', 935242306, true)
 , (2,'Бехзод', '@behzod_31', 'I am always satisfied mith the best', 559009474, true)
 , (3,'Farhod Ismailov', '@fismailov_bjj', 'Programmer_tjk', null, true)
 , (4,'917162800', '@Jahon987', null, 917162800, false)
 , (5,'Alexandra Leshukovich', '@Alexandraleshaya', 'Amor fati - полюби свою судьбу', null, true)
 , (6,'Ibodullo', '@ZAR1509', null, 987925005, true)
 , (7,'Alisher Narzulloev', '@avixon', 'Insta: av1xon', 882280220, true)
 , (8,'Munira K', '@krb_munira', null, 907999777, true)
 , (9,'Murtazoev Alijon', '@M_Alijon', 'I am Batman', null, true)
 , (10, 'Aziz Abdullaev', null, null, null, true)
 , (11, 'Hakim', '@hakim25753', null, 502055054, false)
 , (12, 'Олимов Амир', '@Amir_Olimi', 'Не забывай дни', 803111177, false)
 , (13, 'Farhod JKH', '@FarhodJKH', 'Фарход', null, true)
 , (14, 'Sadriddin Khojazoda', '@khojazodas', null, null, true)
 ;
 

create table lessons (
    lesson_id SERIAL primary key
    , lesson_name VARCHAR(100) not null
    , lesson_date DATE not null
    , attendance BOOLEAN
)
;


insert into lessons (lesson_id, lesson_name, lesson_date, attendance)
values 
(1,'SQL знакомство', '2024-10-16', true)
, (2,'Операторы выборки, фильтрации и агрегации данных', '2024-10-18', true)
, (3,'Работа с текстом и датой', '2024-10-21', true)
, (4, 'Создание, редактирование и удаление таблиц. Работа с БД через Python', '2024-10-23', true)
;


create table scores (
    score_id SERIAL primary key
    , student_id INT references students(student_id)
    , lesson_id INT references lessons(lesson_id)
    , score INT check (score between 1 and 100)
)
;

insert into scores (student_id, lesson_id, score)
values 
(1, 1, null)
, (1, 2, null)
, (2, 1, null)
, (2, 2, null)
, (3, 1, null)
, (3, 2, null)
, (4, 1, null)
, (4, 2, null)
, (5, 1, null)
, (5, 2, null)
, (6, 1, null)
, (6, 2, null)
, (7, 1, null)
, (7, 2, null)
, (8, 1, null)
, (8, 2, null)
, (9, 1, null)
, (9, 2, null)
, (10, 1, null)
, (10, 2, null)
, (11, 1, null)
, (11, 2, null)
, (12, 1, null)
, (12, 2, null)
, (13, 1, null)
, (13, 2, null)
, (14, 1, null)
, (14, 2, null)
;


create index idx_username on students(username);


create view my_results as
select 
    s.student_id,
    s.student_name,
    s.username,
    s.mobile,
    COUNT(l.attendance) filter (where l.attendance = true) as lessons_attended,
    AVG(sc.score) as avg_score
from 
    students s
join 
    scores sc on s.student_id = sc.student_id
join 
    lessons l on sc.lesson_id = l.lesson_id
group by 
    s.student_id
;

