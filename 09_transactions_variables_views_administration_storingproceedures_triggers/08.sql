use shop;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# create procedure in current database

drop procedure if exists my_version;
create procedure my_version()
begin
    select version();
end;

# call procedure
call my_version();

# show all procedures
show procedure status;

# show procedures with name matches regex
show procedure status like 'my_ver%';

# show from information_schema all routines
select SPECIFIC_NAME, ROUTINE_TYPE
from information_schema.routines;

# show created
show create procedure my_version;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# create function in current database

drop function if exists get_version;
create function get_version()
    returns varchar(255) deterministic -- type can be text, can be 'not deterministic' if random value is needed
begin
    return version(); -- function body
end;


# select function or its results
set @current_version := get_version();
select get_version() as version;
select @current_version as version;

# in order to make function in command line client and avoid ';' mistake
# mysql> delimiter //
# mysql> select get_version() as version//
# +-----------+
# | version   |
# +-----------+
# | 8.0.23    |
# +-----------+
# 1 row in set (0.00 sec)
# mysql> delimiter ;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# treating parameters:
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 1) in
# variable in outer scope doesnt change. not necessary to determine 'in' implicitly
create procedure set_x(in value int)
begin
    set @x = value;
end;

call set_x(123456);
select @x;

drop procedure if exists set_x;

create procedure set_x(in value int)
begin
    set @x = value;
    set value = value - 1000;
end;

set @y = 10000;

call set_x(@y);

select @x;
select @y;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 2) out
# a)
set @y = 10000;

drop procedure if exists set_x;
create procedure set_x(out value int)
begin
    set @x = value;
    set value = 1000;
end;

call set_x(@y);

select @x, @y;
# @x is 'null', bcz first set @x depending on @y, then @y changed;

# b)
set @y = 10000;
drop procedure if exists set_x;
create procedure set_x(out value int)
begin
    set value = 1000;
    set @x = value;
end;

call set_x(@y);
# both are not null, bcz first set @y, then set @x depending on @y
select @x, @y;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# inout
set @y = 10000;
drop procedure if exists set_x;
create procedure set_x(inout value int)
begin
    set @x = value;
    set value = value - 1000;
end;

call set_x(@y);
# both are not null, bcz inout, doesnt depend on assigning order
select @x, @y;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# declare var default

drop procedure if exists declare_var;
create procedure declare_var()
begin
    declare var tinytext default 'outer scope';
    begin
        declare var tinytext default 'inner scope';
        set @boom = var;
    end;
    select var;
end;

call declare_var();
select @boom;


drop procedure if exists one_declare_var;
create procedure one_declare_var()
begin
    declare var tinytext default 'outer scope';
    begin
        select var;
        -- in command line returns 'outer scope'
#       set @booom = var;       -- setting outer from inner not possible
    end;
    select var;
end;

call declare_var();
select @booom;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# set @var = 100;
drop function if exists second_format;
create function second_format(seconds int)
    returns varchar(255) deterministic
begin
    declare days, hours, minutes int;
    set days = floor(seconds / 86400);
    set seconds = seconds - days * 86400;
    set hours = floor(seconds / 3600);
    set seconds = seconds - hours * 3600;
    set minutes = floor(seconds / 60);
    set seconds = seconds - minutes * 60;
    return concat(days, ' days ', hours, ' hours ', minutes, ' minutes ', seconds, ' seconds ');
end;

select second_format(100000);

# select id, data into @x, @y from test
# 1 parameter
drop procedure if exists numcatalogs;
create procedure numcatalogs(out total int)
begin
    select count(*) into total from catalogs;
end;

call numcatalogs(@a);

select @a;

# several parameters
drop procedure if exists name_numcatalogs;
create procedure name_numcatalogs(out shmotal varchar(255), out total int)
begin
    select name into shmotal from catalogs where name like '%проц%';
    select count(*) into total from catalogs;
end;

call name_numcatalogs(@a, @b);
select @a, @b;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# if
drop procedure if exists format_now;
create procedure format_now(format char(4))
begin
    if (format = 'date') then
        select date_format(now(), '%d.%m.%Y') as format_now;
    end if;
    if (format = 'time') then
        select date_format(now(), '%h:%i:%s') as format_now;
    end if;
end;

call format_now('date');
call format_now('time');

# if else
drop procedure if exists format_now;
create procedure format_now(format char(4))
begin
    if (format = 'date') then
        select date_format(now(), '%d.%m.%Y') as format_now;
    else
        select date_format(now(), '%h:%i:%s') as format_now;
    end if;
end;

call format_now('date');
call format_now('some');

# if elseif else
drop procedure if exists format_now;
create procedure format_now(format char(4))
begin
    if (format = 'date') then
        select date_format(now(), '%d.%m.%Y') as format_now;
    elseif (format = 'time') then
        select date_format(now(), '%h:%i:%s') as format_now;
    else
        select unix_timestamp(now()) as format_now;
    end if;
end;

call format_now('date');
call format_now('time');
call format_now('some');

# case
drop procedure if exists format_now;
create procedure format_now(format char(4))
begin
    case format
        when 'date' then select date_format(now(), '%d.%m.%Y') as format_now;
        when 'time' then select date_format(now(), '%h:%i:%s') as format_now;
        when 'secs' then select unix_timestamp(now()) as format_now;
        else select 'format error';
        end case;
end;

call format_now('date');
call format_now('time');
call format_now('secs');
call format_now('some');

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# while
drop procedure if exists now_3;
create procedure now_3()
begin
    declare i int default 3;
    while i > 0
        do
            select now();
            set i = i - 1;
        end while;
end;

call now_3();

# # # # # # # # # # # # # # # # # # # #
# (in) while ...
drop procedure if exists now_n;
create procedure now_n(in num int)
begin
    declare i int default 0;
    if (num > 0) then
        while i < num
            do
                select now();
                set i = i + 1;
            end while;
    else
        select 'parameter value error';
    end if;
end;

call now_n(2);

# # # # # # # # # # # # # # # # # # # #
# (in) cycle: while .. end while cycle
drop procedure if exists now_n;
create procedure now_n(in num int)
begin
    declare i int default 0;
    if (num > 0) then
        cycle:
        while i < num
            do
                if i >= 2 then
                    leave cycle;
                end if;
                select now();
                set i = i + 1;
            end while cycle;
    else
        select 'parameter value error';
    end if;
end;

call now_n(1000);
-- will select only 2 times


# # # # # # # # # # # # # # # # # # # #
# (in) while ... iterate.
drop procedure if exists numbers_string;
create procedure numbers_string(in num int)
begin
    declare i int default 0;
    declare bin tinytext default '';
    if (num > 0) then
        cycle:
        while i < num
            do
                set i = i + 1;
                set bin = concat(bin, i);
                if i > ceiling(num / 2) then
                    iterate cycle;
                end if;
                set bin = concat(bin, i);
            end while cycle;
        select bin;
    else
        select 'error parameter value';
    end if;
end;

call numbers_string(8);
call numbers_string(9);

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# repeat until

drop procedure if exists now_3;
create procedure now_3()
begin
    declare i int default 3;
    repeat
        select now();
        set i = i - 1;
    until i = 0
        end repeat;
end;

call now_3();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# loop

drop procedure if exists now_3;
create procedure now_3()
begin
    declare i int default 3;
    cycle:
    loop
        select now();
        set i = i - 1;
        if i <= 0 then
            leave cycle;
        end if;
    end loop cycle;
end;

call now_3();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# error handling

show create table catalogs;
select *
from catalogs;

drop procedure if exists insert_to_catalogs;
create procedure insert_to_catalogs(in id int, in name varchar(255))
begin
    declare continue handler for sqlstate '23000' set @error = 'OOOOOOOOH, some entering error';
    insert into catalogs values (id, name);
    if @error is not null then
        select @error;
    end if;
end;

call insert_to_catalogs(6, 'ram ddr');
call insert_to_catalogs(6, 'ram ddr');

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# select .. into .. from

drop procedure if exists catalog_id;
create procedure catalog_id(out total int)
begin
    select id into total from catalogs;
end;

call catalog_id(@total);
-- [2021-04-15 18:11:02] [42000][1172] Result consisted of more than one row

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# cursors
create table upcase_catalogs
(
    id   serial primary key,
    name varchar(255) comment 'catalog name'
) comment = 'e-shop catalogs written with upper case';

create procedure copy_catalogs()
begin
    declare id int;
    declare is_end int default 0;
    declare name tinytext;

    declare curcat cursor for select * from catalogs;
    declare continue handler for not found set is_end = 1;

    open curcat;

    cycle :
    loop
        fetch curcat into id, name;
        if is_end then
            leave cycle;
        end if;
        insert into upcase_catalogs values (id, upper(name));
    end loop;

    close curcat;
end;

call copy_catalogs();
select *
from upcase_catalogs;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# triggers
select *
from products;

# show
show triggers;

# # # # # # # # # # # # # # # # # # # # # #
# before ... new.name
# after ... old.name

# # # # # # # # # # # # # # # # # # # # # #
# before insert

select coalesce(null, null, 1, 2, 3);

drop trigger if exists check_catalog_id_insert;
create trigger check_catalog_id_insert
    before insert
    on products
    for each row
begin
    declare cat_id int;
    select id into cat_id from catalogs order by id limit 1; -- smallest id = 1.
    set new.catalog_id = coalesce(new.catalog_id, cat_id); -- coalesce(args) returns first 'is not null' arg
end;

insert into products (name, description, price)
values ('amd ryzon 5 1600', 'processor amd', 13200.00);

insert into products (name, description, price, catalog_id)
values ('amd card 2000', 'motherboard amd', 15000.00, 2);

# still possible to update with null
update products
set catalog_id = null
where name = 'amd ryzon 5 1600';

# # # # # # # # # # # # # # # # # # # # # #
# after insert

drop trigger if exists catalogs_count;
create trigger catalogs_count
    after insert
    on catalogs
    for each row
begin
    select count(*) into @catalog_counter from catalogs;
end;

select *
from catalogs;

delete
from catalogs
where name = 'one more more catalog';

insert into catalogs
values (null, 'one more more catalog');

select @catalog_counter;

# # # # # # # # # # # # # # # # # # # # # #
# before update

drop trigger if exists check_catalog_id_update;
create trigger check_catalog_id_update
    before update
    on products
    for each row
begin
    declare cat_id int;
    select id into cat_id from catalogs order by id limit 1;
    set new.catalog_id = coalesce(new.catalog_id, old.catalog_id, cat_id);
end;

update products
set catalog_id = null
where name = 'amd card 4000';

# # # # # # # # # # # # # # # # # # # # # #
# after update

# # # # # # # # # # # # # # # # # # # # # #
# before delete

create trigger check_last_row
    before delete
    on catalogs
    for each row
begin
    declare total int;
    select count(*) into total from catalogs;
    if total <=1 then
        signal sqlstate '45000' set message_text = 'delete canceled';
    end if;
end;

# # # # # # # # # # # # # # # # # # # # # #
# after delete


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# triggers instead of 'stored'

drop table if exists prices;
create table prices
(
    id        serial primary key,
    processor decimal(11, 2) comment 'processor price',
    mother    decimal(11, 2) comment 'motherboard price',
    memory    decimal(11, 2) comment 'ram price',
    total     decimal(11, 2) comment 'total price'
);

drop trigger if exists auto_update_price_on_insert;
create trigger auto_update_price_on_insert
    before insert
    on prices
    for each row
begin
    set new.total = new.processor + new.mother + new.memory;
end;

drop trigger if exists auto_update_price_on_update;
create trigger auto_update_price_on_update
    before update
    on prices
    for each row
begin
    set new.total = new.processor + new.mother + new.memory;
end;

insert into prices (processor, mother, memory)
values (111.00, 222.00, 333.00);

update prices
set memory = 444
where id = 1;

select *
from prices;
