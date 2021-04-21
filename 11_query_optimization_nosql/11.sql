DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название раздела',
    UNIQUE unique_name (name(10))
) COMMENT = 'Разделы интернет-магазина' ENGINE = InnoDB; -- implicitly showing engine

/*
core -
    support clients connection pool (for giving session to everyone),
    implementing sql rules and logic
        if query in cache
        analyzer (if query not in cache and - divide query to lexemes, build parse tree using sql syntax
        preprocessor - checking if tables and columns exist, links are unambiguous, user has privileges
        optimizer - choosing way of query, indexing, checking with server statistics

    low-level engine call

engine - data keeping, indexing, low-level processing
    InnoDB - default
    Memory - for placing to RAM
    Archive - to compress
 */

show variables like 'datadir'; -- C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\

/*
single table space
-rw-r--r-- 1 prape 197609 12582912 Apr 19 17:23  ibdata1

temporary tables
-rw-r--r-- 1 prape 197609 12582912 Apr 18 13:42  ibtmp1

transactions log files
-rw-r--r-- 1 prape 197609 50331648 Apr 19 17:23  ib_logfile0
-rw-r--r-- 1 prape 197609 50331648 Apr  6 14:46  ib_logfile1



prape@DESKTOP-F2U5O7B MINGW64 /c/ProgramData/MySQL/MySQL Server 8.0/Data/shop

.ibd - datafiles
.frm - structure files
.trn - triggers files

-rw-r--r-- 1 prape 197609 147456 Apr 16 15:39 catalogs.ibd                 <----datafile
-rw-r--r-- 1 prape 197609 163840 Apr 14 15:23 discounts.ibd
-rw-r--r-- 1 prape 197609 147456 Apr 14 15:23 orders.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 14 15:23 orders_products.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 16 16:13 prices.ibd
-rw-r--r-- 1 prape 197609 147456 Apr 16 17:29 products.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 14 15:23 storehouses.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 14 15:23 storehouses_products.ibd
-rw-r--r-- 1 prape 197609 114688 Apr 18 01:25 tbl1.ibd
-rw-r--r-- 1 prape 197609 114688 Apr 18 01:25 tbl2.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 15 18:24 upcase_catalogs.ibd
-rw-r--r-- 1 prape 197609 131072 Apr 14 15:23 users.ibd

.MYD - data
.MYI - indexes
.frm - table structure

mysql> show table status like 'catalogs'\G
*************************** 1. row ***************************
           Name: catalogs
         Engine: InnoDB                                         <----- ENGINE
        Version: 10
     Row_format: Dynamic
           Rows: 8
 Avg_row_length: 2048
    Data_length: 16384
Max_data_length: 0
   Index_length: 32768
      Data_free: 0
 Auto_increment: 11
    Create_time: 2021-04-14 15:23:20
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options:
        Comment: Разделы интернет-магазина



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

mysql> show engines\G
*************************** 1. row ***************************
      Engine: MEMORY                                                                < ----- very fast
     Support: YES
     Comment: Hash based, stored in memory, useful for temporary tables
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 2. row ***************************
      Engine: MRG_MYISAM                                                            < ----- like union query, union of many MYISAM tables
     Support: YES
     Comment: Collection of identical MyISAM tables
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 3. row ***************************
      Engine: CSV
     Support: YES
     Comment: CSV storage engine
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 4. row ***************************
      Engine: FEDERATED
     Support: NO
     Comment: Federated MySQL storage engine
Transactions: NULL
          XA: NULL
  Savepoints: NULL
*************************** 5. row ***************************
      Engine: PERFORMANCE_SCHEMA
     Support: YES
     Comment: Performance Schema
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 6. row ***************************
      Engine: MyISAM                                                               <------- for better performance bcz without transactions
     Support: YES
     Comment: MyISAM storage engine
Transactions: NO
          XA: NO
  Savepoints: NO

cashing indexes + data
*************************** 7. row ***************************
      Engine: InnoDB
     Support: DEFAULT
     Comment: Supports transactions, row-level locking, and foreign keys         <-------------
Transactions: YES
          XA: YES
  Savepoints: YES
*************************** 8. row ***************************
      Engine: BLACKHOLE                                                          <------------- for setting multiple slave servers
     Support: YES
     Comment: /dev/null storage engine (anything you write to it disappears)
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 9. row ***************************
      Engine: ARCHIVE                                                             < -------- have big buffer, for protocols and data gathering
     Support: YES
     Comment: Archive storage engine
Transactions: NO
          XA: NO
  Savepoints: NO


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
indexing - helps to get data from big data
    main instrument - cache blocks, bringing data from hdd(ssd) to ram

a)  part of caches blocks - for core (i.e. caches for indexes)
query_cache_size = 0 +
key_buffer_size = 8M +
innodb_buffer_pool_size = 1024M                 --- indexes and data caches
innodb_additional_mem_pool_size = 8M +
innodb_log_buffer_size = 8M
    total = 1056M

b)  part of caches blocks - for every connections (caches for sorting)
read_buffer_size = 1M
read_rnd_buffer_size = 1M
sort_buffer_size = 2M
thread_stack = 256K
join_buffer_size = 128K
    total 1 connection = 3.5M *

c)  quantity of connections
max_connections = 200
    total 200 connection = 700M



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
MyISAM:
indexes and data are separate ((.MYD) (.MYI) )
data always     - at hhd/ssd,
caching indexes - at ram


mysql> show variables like 'key%';
+--------------------------+---------+
| Variable_name            | Value   |
+--------------------------+---------+
| key_buffer_size          | 8388608 | --- for caching indexes
| key_cache_age_threshold  | 300     |
| key_cache_block_size     | 1024    |
| key_cache_division_limit | 100     |
| keyring_operations       | ON      |
+--------------------------+---------+

MyISAM cache efficiency:

mysql> show status like 'key%';
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| Key_blocks_not_flushed | 0            |
| Key_blocks_unused      | 6698         | -- free blocks
| Key_blocks_used        | 0            | -- used blocks
| Key_read_requests      | 18472428924  | -- read blocks from ram (cache)
| Key_reads              | 381826182    | -- read blocks from hdd to ram           -- here 1 read from hhd, 48 reads from ram
| Key_write_requests     | 3382057      | -- write blocks to ram (cache)
| Key_writes             | 777999       | -- write blocks to hdd
+------------------------+-------+


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

InnoDB:
indexes together with data (.ibd)
data + caching indexes  - at ram

mysql> show variables like 'innodb_buffer_pool_size';
+-------------------------+-----------+
| Variable_name           | Value     |
+-------------------------+-----------+
| innodb_buffer_pool_size | 134217728 | -- size for caching indexes and data (recommended 50-80% of ram)
+-------------------------+-----------+

InnoDB cache efficiency:

mysql> show status like 'Innodb_buffer_pool_%';
+---------------------------------------+--------------------------------------------------+
| Variable_name                         | Value                                            |
+---------------------------------------+--------------------------------------------------+
| Innodb_buffer_pool_pages_data         | 1330                                             | -- used blocks
| Innodb_buffer_pool_pages_free         | 6840                                             | -- free blocks
| Innodb_buffer_pool_pages_total        | 8192                                             | -- total cache blocks
| Innodb_buffer_pool_read_requests      | 1433344                                          | -- read from cache
| Innodb_buffer_pool_write_requests     | 6388                                             | --     / write to cache  = 224
| Innodb_buffer_pool_reads              | 1235                                             | -- reads from hdd
| Innodb_buffer_pool_dump_status        | Dumping of buffer pool not started               |
| Innodb_buffer_pool_load_status        | Buffer pool(s) load completed at 210418 13:42:05 |
| Innodb_buffer_pool_resize_status      |                                                  |
| Innodb_buffer_pool_bytes_data         | 21790720                                         |
| Innodb_buffer_pool_pages_dirty        | 0                                                |
| Innodb_buffer_pool_bytes_dirty        | 0                                                |
| Innodb_buffer_pool_pages_flushed      | 1012                                             |
| Innodb_buffer_pool_pages_misc         | 22                                               |
| Innodb_buffer_pool_read_ahead_rnd     | 0                                                |
| Innodb_buffer_pool_read_ahead         | 0                                                |
| Innodb_buffer_pool_read_ahead_evicted | 0                                                |
| Innodb_buffer_pool_wait_free          | 0                                                |
+---------------------------------------+--------------------------------------------------+
*/
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# optimizing ways:
#     -small tables data
#     -small intermediate tables
#     -less text / blob (slower bcz keeps separately from all other table columns)
#     -less null (larger)/ varchar (variable length)
#     -avoid full table scan

select * from users; -- less effective than
select id, firstname, lastname from vk.users; -- less effective than
select id, firstname, lastname from vk.users order by id limit 5;
select id, firstname, lastname from vk.users order by id desc limit 5;
select id, firstname, lastname from vk.users order by id asc limit 5;
select id, firstname, lastname from vk.users limit 5;

# explain for select queries
explain select * from vk.users;
explain select * from vk.users union select * from vk.users;
/*
select_type - primary/union
table - used table
type -  all(full table scan),
        index (full table scan by index),
        range (not full scan by index in queries like 'between' or 'in (10 < index and index < 20)' ,
        ref (excess not unique data by index),
        eq_ref (excess unique data by index),
        const (if some data can be constant),
        null (if query was returned while optimizer work)
possible keys - which indexes could be used for query (in simple query only 1 index can be used)
key - chosen by optimizer key from possible keys
key_len - how many index' bytes mysql used
ref - what columns and constants from previous tables are used for search in index
rows - how many rows should be read
filtered - how many rows satisfy the query condition
extra - additional info
        using index (can not to gain from table)
        using where (additional filtration where from core)
        using temporary (tmp_table_size)
        using filesort (usual sorting)


*/
explain select u1.id, u1.firstname, u1.lastname from vk.users u1 join vk.users u2 on u2.firstname = u2.firstname;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

/*
NoSQL DB:

1) key-value bd: react, dynamodb, memcached, redis
2) wide column store db: cassandra, hbase, clickhouse
3) document store bd (json, xml, yaml): coach db, mongo db
4) graph store bd: float db, neo4j, polyglot
5) object oriented bd: db4o, intersystems cache
6) full-text search engine bd: solr, elasticsearch

CAP: consistency - availability - partition tolerance
CA: rbd mysql, postgre
AP: cassandra, riak
PC: redis, mongodb

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

redis:
key-value
high performance up to 100000rps
ram operating
key life-time
transactions support
replication and sentinel-clasterisation
pops-up subscribe mechanism
Lua scripts

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
mongodb:
document store
opensource
json documents using javascript
high performance
without strict schema
replication and sharding support

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
clickhouse:
column store

*/