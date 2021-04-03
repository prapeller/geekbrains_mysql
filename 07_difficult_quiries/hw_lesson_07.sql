# 1.	Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

USE shop;

# DROP TABLE IF EXISTS orders;
# CREATE TABLE orders
# (
#     id         SERIAL PRIMARY KEY,
#     user_id    INT UNSIGNED,
#     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
#     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
#     KEY index_of_user_id (user_id)
# ) COMMENT = 'Заказы';
#
# INSERT INTO orders
#     (user_id)
# VALUES (1),
#        (1),
#        (2),
#        (2),
#        (3),
#        (4),
#        (5),
#        (5),
#        (5);
#
# DROP TABLE IF EXISTS orders_products;
# CREATE TABLE orders_products
# (
#     id         SERIAL PRIMARY KEY,
#     order_id   INT UNSIGNED,
#     product_id BIGINT UNSIGNED,
#     total      INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
#     created_at DATETIME     DEFAULT CURRENT_TIMESTAMP,
#     updated_at DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
#     CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products (id)
# ) COMMENT = 'Состав заказа';
#
# INSERT INTO orders_products (order_id, product_id, total)
# VALUES (1, 1, 1),
#        (1, 2, 1),
#        (2, 3, 1),
#        (3, 4, 1),
#        (3, 7, 1),
#        (4, 5, 2),
#        (5, 7, 1),
#        (6, 6, 1),
#        (7, 6, 2),
#        (8, 6, 1),
#        (9, 6, 1);

# а) subquery

SELECT id, name
FROM users
WHERE id in (SELECT user_id FROM orders GROUP BY user_id);

# б) join

SELECT u.id, u.name
FROM users u
         INNER JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

# 2.	Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.id, p.name, c.id, c.name
from products p
         LEFT JOIN catalogs c ON c.id = p.catalog_id;

# 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label
# содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

# DROP TABLE IF EXISTS flights;
# CREATE TABLE flights
# (
#     id SERIAL PRIMARY KEY,
#     `from` VARCHAR(50) NOT NULL,
#     `to`   VARCHAR(50) NOT NULL
# );
#
# INSERT INTO flights (`from`, `to`)
# VALUES ('moscow', 'omsk'),
#        ('novgorod', 'kazan'),
#        ('irkutsk', 'moscow'),
#        ('omsk', 'irkutsk'),
#        ('moscow', 'kazan');
#
# DROP TABLE IF EXISTS cities;
# CREATE TABLE cities
# (
#     label VARCHAR(50) NOT NULL,
#     name  VARCHAR(50) NOT NULL,
#     PRIMARY KEY (label, name)
# );
#
# INSERT INTO cities (label, name)
# VALUES ('moscow', 'Москва'),
#        ('irkutsk', 'Иркутск'),
#        ('novgorod', 'Новгород'),
#        ('kazan', 'Казань'),
#        ('omsk', 'Омск');

SELECT c.name `from`, c2.name `to`
FROM flights f
         LEFT JOIN cities c ON c.label = f.from
         LEFT JOIN cities c2 ON c2.label = f.to;
