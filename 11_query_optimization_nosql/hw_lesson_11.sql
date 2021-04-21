# 1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в
# таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое
# поля name.
use shop;

drop table if exists logs;
create table logs
(
    id                serial unique,
    created_at        datetime     not null,
    table_name        varchar(512) not null,
    table_primary_key bigint       not null,
    name_column       varchar(512) not null

) comment = 'Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.'
    engine = ARCHIVE
;

drop trigger if exists archiving_insert_to_users;
create trigger archiving_insert_to_users
    after insert
    on users
    for each row
begin
    insert into logs (created_at, table_name, table_primary_key, name_column)
    values (now(), 'users', new.id, new.name);
end;

drop trigger if exists archiving_insert_to_catalogs;
create trigger archiving_insert_to_catalogs
    after insert
    on catalogs
    for each row
begin
    insert into logs (created_at, table_name, table_primary_key, name_column)
    values (now(), 'catalogs', new.id, new.name);
end;

drop trigger if exists archiving_insert_to_products;
create trigger archiving_insert_to_products
    after insert
    on products
    for each row
begin
    insert into logs (created_at, table_name, table_primary_key, name_column)
    values (now(), 'products', new.id, new.name);
end;



insert into users (name, birthday_at)
values ('petya', '1980-12-01');

insert into products (name, desription, price, catalog_id)
values ('zhelezyaka', 'description', 0, 1);

insert into catalogs (name)
values ('best catalog');


select last_insert_id();
select *
from catalogs;

# 2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

drop procedure if exists generate_mln_users;
create procedure generate_mln_users()
begin
    declare i int default 0;
    while i < 1000000
        do
            insert into users (name, birthday_at) values ('clone', now());
            set i = i + 1;
        end while;
end;

call generate_mln_users();

select *
from users;