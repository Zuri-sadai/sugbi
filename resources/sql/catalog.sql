-- :name insert-book! :! :1
insert into catalog.book (title, isbn) values (:title, :isbn)
returning *;

-- :name delete-book! :! :n
delete from catalog.book where isbn = :isbn;

-- :name search :? :*
select isbn, true as "available"
from catalog.book
where lower(title) like :title;

-- :name get-book :? :1
select isbn, true as "available"
from catalog.book
where isbn = :isbn

-- :name get-books :? :*
select isbn, true as "available"
from catalog.book;

-- hacer query, buscar en la BD --- Tarea 2
-- inserta copias
-- :name insert-copy :! :1
insert into catalog.copia (book_id, available) values (:book_id, true)
returning *;

-- :name up-available :! :n
update catalog.copia
set available = :available
where copia_id = :copia_id;

-- Solicitar un libro en préstamo (`checkout-book user-id book-item-id`).
-- :name checkout-book :! :1 
insert into catalog.prestamo (copia_id, user_id, prestamo_fecha, vencimiento_fecha) 
values (:copia_id, :user_id, current_timestamp, current_timestamp + interval '2 weeks')
returning *;

--Devolver un libro en préstamo.
-- :name return-book :! :n
update catalog.prestamo 
set vencimiento_fecha = current_timestamp
where user_id = :user_id and copia_id = :copia_id;

--Obtener los préstamos de un usuario (`get-book-lendings user-id`).
-- :name get-book-lendings :? :*
select * from catalog.prestamo 
where user_id = :user_id and vencimiento_fecha >= current_date;
 
-- :name cuenta-book :? :1
select count(*) from catalog.copia where book_id = (select book_id from catalog.book where isbn = :isbn) and available = true;

