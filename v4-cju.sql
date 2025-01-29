/**
  @author Набиуллин К.
 */

-- Найти читателей, которые взяли больше 3 книг
WITH reader_activity AS (
    SELECT
        r.reader_id,
        r.name,
        r.email,
        COUNT(ir.record_id) AS total_books_borrowed
    FROM reader r
             LEFT JOIN issue_record ir ON r.reader_id = ir.reader_id
    GROUP BY r.reader_id
)
SELECT name, email, total_books_borrowed
FROM reader_activity
WHERE total_books_borrowed > 3;

-- Вывести информацию о выданных книгах (невозвращенных)
SELECT
    b.title AS book_title,
    a.name AS author_name,
    c.name AS category_name,
    r.name AS reader_name,
    ir.issue_date
FROM issue_record ir
         JOIN book b ON ir.book_id = b.book_id
         JOIN author a ON b.author_id = a.author_id
         JOIN category c ON b.category_id = c.category_id
         JOIN reader r ON ir.reader_id = r.reader_id
WHERE ir.return_date IS NULL;

-- Получить объединенный список всех уникальных имен (читателей и авторов)
SELECT name FROM reader
UNION
SELECT name FROM author;