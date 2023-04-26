-- crear tablas de préstamos y copias del libro

-- Copias para cada libro
create table catalog.copia (
    copia_id bigint generated always as identity primary key,
    book_id bigint not null references catalog.book(book_id)
    available boolean not null 
)

-- Préstamos
--libro, ususario, dia prestamo, vencimiento
create table catalog.prestamo (
    prestamo_id bigint generated always as identity primary key,
    copia_id bigint not null references copia(id),
    user_id integer not null,
    prestamo_fecha date not null,
    vencimiento_fecha date not null 
);

