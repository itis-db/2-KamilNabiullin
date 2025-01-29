/**
  @author Набиуллин К.
 */

BEGIN;

-- 1. Изменение типов столбцов
ALTER TABLE reader
ALTER COLUMN phone TYPE VARCHAR(20);

-- 2. Добавление новых столбцов
ALTER TABLE author
    ADD COLUMN country VARCHAR(50) NOT NULL DEFAULT 'Unknown';

ALTER TABLE book
    ADD COLUMN publication_year INT;

ALTER TABLE issue_record
    ADD COLUMN due_date DATE NOT NULL DEFAULT CURRENT_DATE + INTERVAL '14 days';

-- 3. Добавление ограничений
-- Ограничение на год издания (не больше текущего)
ALTER TABLE book
    ADD CONSTRAINT chk_book_publication_year
        CHECK (publication_year <= EXTRACT(YEAR FROM CURRENT_DATE));

COMMIT;


-- Откат изменений (rollback)
BEGIN;

-- Удаление ограничений
ALTER TABLE book
DROP CONSTRAINT IF EXISTS chk_book_publication_year;

-- Удаление добавленных столбцов
ALTER TABLE author
DROP COLUMN country;

ALTER TABLE book
DROP COLUMN publication_year;

ALTER TABLE issue_record
DROP COLUMN due_date;

-- Возврат исходного типа для phone
ALTER TABLE reader
ALTER COLUMN phone TYPE TEXT;

COMMIT;
