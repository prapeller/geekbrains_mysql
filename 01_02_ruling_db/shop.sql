CREATE DATABASE IF NOT EXISTS shop;

DROP TABLE IF EXISTS catalogues;
CREATE TABLE catalogues (
#     id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'название раздела',
    UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

# INSERT INTO catalogues VALUES (NULL, 'GPU');
# INSERT INTO catalogues (id, name) VALUES (NULL, 'motherboards');
# INSERT INTO catalogues (name, id) VALUES ('CPU', NULL);
# INSERT INTO catalogues VALUES (DEFAULT, 'keyboards');
INSERT IGNORE INTO catalogues VALUES
#    will be error of duplicate entry 'keyboards' if try to insert without IGNORE keyword
    (DEFAULT, 'CPU'),
    (DEFAULT, 'GPU'),
    (DEFAULT, 'motherboards'),
    (DEFAULT, 'keyboards'),
    (DEFAULT, 'keyboards');

DELETE FROM catalogues;
# DELETE FROM catalogues LIMIT 3;
# DELETE FROM catalogues WHERE id > 2;
# DELETE FROM catalogues WHERE id > 2 LIMIT 1;

INSERT IGNORE INTO catalogues VALUES
    (DEFAULT, 'CPU'),
    (DEFAULT, 'GPU');

TRUNCATE catalogues; -- clears id auto-incrementing

INSERT IGNORE INTO catalogues VALUES
    (DEFAULT, 'CPU'),
    (DEFAULT, 'GPU');

UPDATE catalogues SET name = 'CPU Intel' WHERE name = 'CPU';


# SELECT id, name FROM catalogues;
# SELECT name, id FROM catalogues;
# SELECT name FROM catalogues;

SELECT * FROM catalogues;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'имя покупателя',
    birthday_date DATE COMMENT 'день рождения',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'день регистрации пользователя',
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'дата последнего обновления'
) COMMENT = 'Покупатели';

INSERT INTO users (id, name, birthday_date) VALUES (1, 'FIRST buyer', '1989-09-13');
INSERT INTO users (id, name, birthday_date) VALUES (2, 'SECOND buyer', '1987-05-24');
INSERT INTO users (id, name, birthday_date) VALUES (3, 'THIRD buyer', '2019-11-12');
SELECT * FROM users;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'название',
    description TEXT COMMENT 'описание',
    price DECIMAL (11,2) COMMENT 'цена',
    catalogue_id INT UNSIGNED NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY ind_of_catalogue_id(catalogue_id)
) COMMENT = 'Товарные позиции';

# CREATE INDEX ind_of_catalogue_id ON products (catalogue_id);
# CREATE INDEX index_of_catalogue_btree USING BTREE ON products (catalogue_id);
# CREATE INDEX index_of_catalogue_hash USING HASH ON products (catalogue_id);
# DROP INDEX index_of_catalogue ON products;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
#     id INT UNSIGNED NOT NULL,
    id SERIAL PRIMARY KEY ,
    user_id INT UNSIGNED,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_user_id (user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
#     id INT UNSIGNED NOT NULL,
    id SERIAL PRIMARY KEY,
    order_id INT UNSIGNED,
    product_id INT UNSIGNED,
    qty INT UNSIGNED DEFAULT 1 COMMENT 'количество заказанных товарных позиций',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
#     KEY order_id(order_id),
#     KEY product_id(product_id)
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
#     id INT UNSIGNED NOT NULL,
    id SERIAL PRIMARY KEY,
    user_id INT UNSIGNED,
    product_id INT UNSIGNED,
    discount FLOAT UNSIGNED COMMENT 'величина скидки от 0.0 до 1.0',
    started_at DATETIME,
    finished_at DATETIME,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_user_id(user_id),
    KEY index_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse (
#     id INT UNSIGNED NOT NULL,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'название',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS warehouse_balance;
CREATE TABLE warehouse_balance (
#     id INT UNSIGNED,
    id SERIAL PRIMARY KEY,
    warehouse_id INT UNSIGNED,
    product_id INT UNSIGNED,
    balance INT UNSIGNED COMMENT 'остаток товара на складе',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склад и остатки';