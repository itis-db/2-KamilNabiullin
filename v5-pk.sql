/**
  @author Набиуллин К.
 */

-- Замена суррогатных ключей на доменные
BEGIN;

-- 1. Удаление суррогатных ключей и создание доменных (суперключей)
ALTER TABLE reader
DROP CONSTRAINT reader_pkey,
ADD PRIMARY KEY (email),
DROP COLUMN reader_id;

ALTER TABLE author
DROP CONSTRAINT author_pkey,
ADD PRIMARY KEY (name, birthdate),
DROP COLUMN author_id;

ALTER TABLE category
DROP CONSTRAINT category_pkey,
ADD PRIMARY KEY (name),
DROP COLUMN category_id;

ALTER TABLE book
DROP CONSTRAINT book_pkey,
ADD COLUMN author_name TEXT,
ADD COLUMN author_birthdate DATE,
ADD COLUMN category_name TEXT;

-- Обновление данных для новых столбцов
UPDATE book b
SET
    author_name = a.name,
    author_birthdate = a.birthdate,
    category_name = c.name
    FROM author a, category c
WHERE b.author_id = a.author_id AND b.category_id = c.category_id;

ALTER TABLE book
DROP COLUMN author_id,
DROP COLUMN category_id,
DROP COLUMN book_id,
ADD PRIMARY KEY (title, author_name, author_birthdate, category_name);

ALTER TABLE issue_record
    ADD COLUMN reader_email TEXT,
ADD COLUMN book_title TEXT,
ADD COLUMN book_author_name TEXT,
ADD COLUMN book_author_birthdate DATE,
ADD COLUMN book_category_name TEXT;

UPDATE issue_record ir
SET
    reader_email = r.email,
    book_title = b.title,
    book_author_name = b.author_name,
    book_author_birthdate = b.author_birthdate,
    book_category_name = b.category_name
    FROM reader r, book b
WHERE ir.reader_id = r.reader_id AND ir.book_id = b.book_id;

ALTER TABLE issue_record
DROP COLUMN record_id,
DROP COLUMN book_id,
DROP COLUMN reader_id,
ADD PRIMARY KEY (book_title, book_author_name, book_author_birthdate, book_category_name, reader_email, issue_date);

COMMIT;

-- ################################################################
-- Откат миграции
BEGIN;


ALTER TABLE reader
    ADD COLUMN reader_id SERIAL PRIMARY KEY,
DROP CONSTRAINT reader_pkey;

ALTER TABLE author
    ADD COLUMN author_id SERIAL PRIMARY KEY,
DROP CONSTRAINT author_pkey;

ALTER TABLE category
    ADD COLUMN category_id SERIAL PRIMARY KEY,
DROP CONSTRAINT category_pkey;

ALTER TABLE book
    ADD COLUMN book_id SERIAL PRIMARY KEY,
ADD COLUMN author_id INT,
ADD COLUMN category_id INT;

UPDATE book b
SET
    author_id = a.author_id,
    category_id = c.category_id
    FROM author a, category c
WHERE b.author_name = a.name AND b.author_birthdate = a.birthdate
  AND b.category_name = c.name;

ALTER TABLE book
DROP COLUMN author_name,
DROP COLUMN author_birthdate,
DROP COLUMN category_name,
DROP CONSTRAINT book_pkey;

ALTER TABLE book
    ADD FOREIGN KEY (author_id) REFERENCES author(author_id),
ADD FOREIGN KEY (category_id) REFERENCES category(category_id);

ALTER TABLE issue_record
    ADD COLUMN record_id SERIAL PRIMARY KEY,
ADD COLUMN book_id INT,
ADD COLUMN reader_id INT;

UPDATE issue_record ir
SET
    reader_id = r.reader_id,
    book_id = b.book_id
    FROM reader r, book b
WHERE ir.reader_email = r.email
  AND ir.book_title = b.title
  AND ir.book_author_name = b.author_name
  AND ir.book_author_birthdate = b.author_birthdate
  AND ir.book_category_name = b.category_name;

ALTER TABLE issue_record
DROP COLUMN reader_email,
DROP COLUMN book_title,
DROP COLUMN book_author_name,
DROP COLUMN book_author_birthdate,
DROP COLUMN book_category_name,
DROP CONSTRAINT issue_record_pkey;

ALTER TABLE issue_record
    ADD FOREIGN KEY (book_id) REFERENCES book(book_id),
ADD FOREIGN KEY (reader_id) REFERENCES reader(reader_id);

COMMIT;