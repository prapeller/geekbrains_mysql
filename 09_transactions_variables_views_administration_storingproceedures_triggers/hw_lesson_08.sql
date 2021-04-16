# Практическое задание по теме “Хранимые процедуры и функции, триггеры"
# 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
# С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
# "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

drop function if exists hello;
create
    definer = root@localhot function shop.hello()
    returns varchar(20) deterministic
begin
    set @current_hour := date_format(now(), '%H');
    if (@current_hour between 6 and 12) then
        return 'Доброе утро';
    elseif (@current_hour between 12 and 18) then
        return 'Добрый день';
    elseif (@current_hour between 18 and 24) then
        return 'Добрый вечер';
    else
        return 'Доброй ночи';
    end if;
end;

select hello();

# 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо
# присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
# Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
# NULL-значение необходимо отменить операцию.

drop trigger if exists check_products_name_desc_insert;
create trigger check_products_name_desc_insert
    before insert
    on products
    for each row
begin
    set @prod_name := new.name;
    set @prod_description := new.description;
    if (@prod_name is null) and (@prod_description is null) then
        signal sqlstate '45000' set message_text = 'both name and description cant be null';
    end if;
end;

drop trigger if exists check_products_name_desc_update;
create trigger check_products_name_desc_update
    before update
    on products
    for each row
begin
    set @prod_name := new.name;
    set @prod_description := new.description;
    if (@prod_name is null) and (@prod_description is null) then
        signal sqlstate '45000' set message_text = 'both name and description cant be null';
    end if;
end;

delete
from products
where name like 'name%' and description like 'desc%'
   or name is null
   or description is null;


insert into products (name, description, price, catalog_id) VALUE ('name1', 'desc1', 1000, 1); -- ok
insert into products (name, description, price, catalog_id) VALUE (null, 'desc2', 1000, 1); -- ok
insert into products (name, description, price, catalog_id) VALUE ('name3', null, 1000, 1); -- ok

select * from products;

insert into products (name, description, price, catalog_id) VALUE (null, null, 1000, 1); -- will raise error
update products set name = null, description = null where name = 'name1'; -- will raise error
update products set description = null where description = 'desc2'; -- will raise error
update products set name = null where name = 'name3'; -- will raise error


# 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется
# последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать
# число 55.
# 0   1   2   3   4   5   6   7   8   9   10
# 0   1   1   2   3   5   8   13  21  34  55

drop function if exists fibonacci;
create
    definer = root@localhost function fibonacci(n int)
    returns int deterministic
begin
    return ((pow(1.618034, n) - pow(-0.618034, n)) / SQRT(5));
end;

select fibonacci(10);
