--;;
create table catalog.copia (
    copia_id bigint generated always as identity primary key,
    book_id bigint not null references catalog.book(book_id),
    available boolean not null 
);

--;; 
create table catalog.prestamo (
    prestamo_id bigint generated always as identity primary key,
    copia_id bigint not null references catalog.copia(copia_id),
    user_id bigint not null,
    prestamo_fecha date not null,
    vencimiento_fecha date not null 
);

