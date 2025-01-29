/**
  @author Набиуллин К.
 */
insert into reader(name, email, phone, address)
select
    'Читатель' || generate_series(1, 50) as name,
    'reader' || generate_series(1, 50) || '@example.com' as email,
    '+7' || (1000000000 + trunc(random() * 9000000000)) as phone,
    'Улица' || generate_series(1, 50) as address;

insert into author(name, birthdate)
select
    'Автор' || generate_series(1, 20) as name,
    generate_series('1799-06-06'::date,
                    '1818-06-06'::date, '1 year') as birthdate;

insert into category(name)
select
    'Категория' || generate_series(1, 10);

insert into book(title, price, count, author_id, category_id)
select
    'Книга' || generate_series(1, 100) as title,
    100 + trunc(random() * 900) as price,
    1 + trunc(random() * 20) as count,
    1 + trunc(random() * 20) as author_id,
    1 + trunc(random() * 10) as category_id;

insert into issue_record (book_id, reader_id, issue_date, return_date)
SELECT
    1 + trunc(random() * 100) AS book_id,
    1 + trunc(random() * 50) AS reader_id,
    generate_series('2024-01-01'::date,
                    '2024-03-31'::date,
                    interval '1 day') as issue_date,
    generate_series('2024-01-01'::date,
                    '2024-03-31'::date,
                    interval '1 day') + (7 + trunc(random() * 24)) * interval '1 day' as return_date;