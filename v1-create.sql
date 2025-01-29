/**
 @author Набиуллин К.
 */
drop table if exists issue_record;
drop table if exists book;
drop table if exists author;
drop table if exists category;
drop table if exists reader;

create table if not exists reader
(
    reader_id serial primary key,
    name      text not null,
    email     text unique,
    phone     text,
    address   text
);

create table if not exists author
(
    author_id serial primary key,
    name      text not null,
    birthdate date
);

create table if not exists category
(
    category_id serial primary key,
    name        text unique not null
);

create table if not exists book
(
    book_id    serial primary key,
    title      text not null,
    price      numeric(10, 2) not null,
    count      integer check (count >= 0),
    author_id  integer references author(author_id),
    category_id integer references category(category_id)
    );

create table if not exists issue_record
(
    record_id serial primary key,
    book_id   integer references book(book_id),
    reader_id integer references reader(reader_id),
    issue_date date not null default current_date,
    return_date date
    );


insert into reader(name, email, phone, address)
values
    ('Иван Иванов', 'ivan@example.com', '+70001234567', 'Москва'),
    ('Мария Смирнова', 'maria@example.com', '+70007654321', 'Санкт-Петербург');

insert into author(name, birthdate)
values
    ('Лев Толстой', '1828-09-09'),
    ('Фёдор Достоевский', '1821-11-11');

insert into category(name)
values
    ('Классика'),
    ('Фантастика'),
    ('Детектив');

insert into book(title, price, count, author_id, category_id)
values
    ('Война и мир', 500.00, 5, 1, 1),
    ('Преступление и наказание', 400.00, 3, 2, 1);

insert into issue_record(book_id, reader_id, issue_date, return_date)
values
    (1, 1, '2024-01-01', '2024-02-01'),
    (2, 2, '2024-01-15', null);