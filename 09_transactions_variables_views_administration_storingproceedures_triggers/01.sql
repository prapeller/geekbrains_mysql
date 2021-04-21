# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# transactions
use bank;

select *
from accounts;

start transaction;
update accounts
set total = total - 2000
where user_id = 4;

update accounts
set total = total + 2000
where user_id is null;

# commit;
rollback;

start transaction;
update accounts
set total = total - 2000
where user_id is null;

update accounts
set total = total + 2000
where user_id = 4;

commit;
# rollback;

select *
from accounts;

# non rollbackable/implicitly committing:
#     create database /table / index
#     drop database / table / index
#     alter database / table
#     rename table
#     truncate table

# implicitly committing:
#     begin
#     start transaction
#     set autocommit = 1
#     lock tables
#     load master data

# savepoint
start transaction;
savepoint before_transaction;
update accounts
set total = total - 2000
where user_id is null;
update accounts
set total = total + 2000
where user_id = 4;
rollback to savepoint before_transaction;

# any command becomes withing transaction, start transaction not needed, 'commit' to save changes
set autocommit = 0;
update accounts
set total = total - 2000
where user_id is null;
update accounts
set total = total + 2000
where user_id = 4;
commit;
rollback; -- will not work bcz already committed

select *
from accounts;

# return back to autocommit after any command
set autocommit = 1;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ACID within transactions:
#     atomicity - whole transaction as single unit - or commit, or rollback
#     consistency - transferring from one consistent state to another consistent state - or commit, or rollback, without any bugs
#     isolation - cant see other transactions till commit - or commit to let other see changes, or rollback
#     durability - if commit - then cant rollback


# isolation levels:
# 1) read uncommitted - transaction can see other uncommitted transactions
set transaction isolation level read uncommitted;

# 2) read committed - transaction can see changes committed when this one started, but what this one changed - cant be
# seen by others till commit (can make one command and get 2 different results)
set transaction isolation level read committed;

# 3) repeatable read - the same as previous, but all commands give the same result, set as default in mysql (can see
# phantom row if chosen row sets and other transaction added / deleted rows)
set transaction isolation level repeatable read;
-- default

# 4) serializable - the same as previous, but without phantom rows conflict, it blocks every row that this transaction
# is reading (so conflicts can happen while blocking)
set transaction isolation level serializable;


show variables like 'innodb_log_%'; -- shows table 'innodb_log_%' about transactions
show variables like 'datadir';
-- shows the data catalogue directory


# prape@DESKTOP-F2U5O7B MINGW64 /c/ProgramData/MySQL/MySQL Server 8.0/Data
# ll
# -rw-r--r-- 1 prape 197609 50331648 Apr 12 13:28  ib_logfile0      <-transaction log files, all transaction goes here first, and then to table space (during server launch). the more size of these files, the more time it takes to launch the server
# -rw-r--r-- 1 prape 197609 50331648 Apr  6 14:46  ib_logfile1      <-
# -rw-r--r-- 1 prape 197609 12582912 Apr 12 13:26  ibdata1          <-innodb drive keeps all database' tables in this table space


/* 3 types of saving transaction log files:
   innodb_flush_log_at_trx_commit
   0 - 1 time/second
   1 - after each transaction
   2 - 1 time/second and after each transaction
 */
show variables like 'innodb_flush_log_at_trx_commit';
set global innodb_flush_log_at_trx_commit = 0;

# mvcc -  multiversion concurrency control (многоверсионный контроль многопоточности) also used in postgresql and oracle.
# mvcc is being supported only at 'repeatable read' and 'read committed' isolation levels


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# variables

use shop;

select @total := count(*)
from products;

select @total;

select @price := max(price)
from products;
select *
from products
where price = @price;

select @id := id
from products;
select @id;

set @id := 5;
select @id;

select *
from tbl1;

set @start = 0;
select @start := @start + 1 as id, value
from tbl1;

show variables; -- select system variables
show variables like 'read_buffer%';
show variables like 'read_%';

# global - for the whole server
# session - for current session (current client-server connection)
set global read_buffer_size = 2097152;
set @@global.read_buffer_size = 2097152;
set @@global.read_buffer_size = default;

set session read_buffer_size = 2097152;
set @@session.read_buffer_size = 2097152;
set @@session.read_buffer_size = default;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# temporary table

create temporary table temp
(
    id   int,
    name varchar(255)
);
show tables; -- theres no temp in tables
describe temp;
-- but we can describe temp

# prape@DESKTOP-F2U5O7B MINGW64 /c/ProgramData/MySQL/MySQL Server 8.0/Data
# ll
# -rw-r--r-- 1 prape 197609 12582912 Apr  9 17:18  ibtmp1       <-- table space for temporary tables


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# dynamic request

use shop;
prepare ver from 'select version()';
execute ver;

prepare prd from 'select id, name, price from products where catalog_id = ?';
set @catalog_id = 1;
execute prd using @catalog_id;
drop prepare prd;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# view

select *
from catalogs;
create view cat as
select *
from catalogs
order by name;
show tables; -- can be seen in tables

create view cat_reverse (catalog, catalog_id) as
select name, id
from catalogs;
select *
from cat_reverse;

create or replace view namecat (id, name, total) as
select id, name, length(name)
from catalogs;

select *
from namecat;

describe products;
create or replace view prod as
select id, name, price, catalog_id
from products
order by catalog_id, name;
select *
from prod;
select *
from prod
order by name desc;

create or replace view processors as
select id, name, price, catalog_id
from products
where catalog_id = 1;

select *
from processors;

create or replace view v1 as
select *
from tbl1
where value < 'fst5'
with check option;

insert into v1
values ('fst4');

insert into v1
values ('fst5'); -- check option failure

alter view v1 as select *
                 from tbl1
                 where value > 'fst4' with check option;
insert into v1
values ('fst5'); -- ok

create or replace view v1 as -- the same as alter view
select *
from tbl1
where value < 'fst4'
with check option;
insert into v1
values ('fst5'); -- check option failure

drop view cat, cat_reverse, namecat, prod, processors, shop.v1;
drop view if exists cat, cat_reverse, namecat, prod, processors, shop.v1;


