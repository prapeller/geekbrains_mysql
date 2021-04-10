# Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

# 1.	Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
#
USE shop;

SELECT * FROM catalogs
WHERE EXISTS (SELECT 1 FROM products WHERE products.catalog_id = catalogs.id);

SELECT id, name, price, catalog_id FROM products
WHERE (5060, products.catalog_id) IN (SELECT products.price, catalogs.id FROM catalogs);


# DROP TABLE IF EXISTS users;
# CREATE TABLE users
# (
#     id          SERIAL PRIMARY KEY,
#     name        VARCHAR(255) COMMENT 'Имя покупателя',
#     birthday_at DATE COMMENT 'Дата рождения',
#     created_at  DATETIME, # DEFAULT CURRENT_TIMESTAMP,
#     updated_at  DATETIME  # DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
# ) COMMENT = 'Покупатели';
#
# INSERT INTO users (name, birthday_at)
# VALUES ('Геннадий', '1990-10-05'),
#        ('Наталья', '1984-11-12'),
#        ('Александр', '1985-05-20'),
#        ('Сергей', '1988-02-14'),
#        ('Иван', '1998-01-12'),
#        ('Мария', '2003-08-29');

UPDATE users
SET created_at = NOW(),
    updated_at = NOW();


# 2.	Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

# DROP TABLE IF EXISTS users;
# CREATE TABLE users
# (
#     id          SERIAL PRIMARY KEY,
#     name        VARCHAR(255) COMMENT 'Имя покупателя',
#     birthday_at VARCHAR(20) COMMENT 'Дата рождения',
#     created_at  VARCHAR(20), # DEFAULT CURRENT_TIMESTAMP,
#     updated_at  VARCHAR(20)  # DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
# ) COMMENT = 'Покупатели';
#
# INSERT INTO users (name, birthday_at, created_at, updated_at)
# VALUES ('Геннадий', '1990-10-05', '20.10.2017 8:10', '21.10.2017 8:10'),
#        ('Наталья', '1984-11-12', '21.10.2017 8:10', '22.10.2017 8:10'),
#        ('Александр', '1985-05-20', '22.10.2017 8:10', '23.10.2017 8:10'),
#        ('Сергей', '1988-02-14', '23.10.2017 8:10', '24.10.2017 8:10'),
#        ('Иван', '1998-01-12', '24.10.2017 8:10', '25.10.2017 8:10'),
#        ('Мария', '2003-08-29', '25.10.2017 8:10', '26.10.2017 8:10');

UPDATE users
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');
UPDATE users
SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
SELECT *
FROM users;

# 3.	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

# DROP TABLE IF EXISTS storehouses;
# CREATE TABLE storehouses (
#   id SERIAL PRIMARY KEY,
#   name VARCHAR(255) COMMENT 'Название',
#   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
#   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
# ) COMMENT = 'Склады';
# INSERT INTO storehouses (name, created_at, updated_at)
# VALUES ('sh-1', NOW(), NOW()),
#        ('sh-2', NOW(), NOW()),
#        ('sh-3', NOW(), NOW());
#
# DROP TABLE IF EXISTS storehouses_products;
# CREATE TABLE storehouses_products
# (
#     id            SERIAL PRIMARY KEY,
#     storehouse_id INT UNSIGNED,
#     product_id    INT UNSIGNED,
#     value         INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
#     created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
#     updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
# ) COMMENT = 'Запасы на складе';
#
# INSERT INTO storehouses_products (storehouse_id, product_id, value, created_at, updated_at)
# VALUES (1, 1, 0, NOW(), NOW()),
#        (1, 2, 2500, NOW(), NOW()),
#        (2, 3, 0, NOW(), NOW()),
#        (2, 4, 30, NOW(), NOW()),
#        (3, 5, 500, NOW(), NOW()),
#        (3, 6, 1, NOW(), NOW());

SELECT *
FROM storehouses_products
ORDER BY FIELD(value, 0), value;

# 4.	(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at VARCHAR(20) COMMENT 'Дата рождения',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at)
VALUES ('Геннадий', '1990-october-05'),
       ('Наталья', '1984-november-12'),
       ('Александр', '1985-may-20'),
       ('Сергей', '1988-february-14'),
       ('Иван', '1998-january-12'),
       ('Мария', '2003-august-29');

SELECT *
FROM users
WHERE birthday_at LIKE '%may%'
   OR birthday_at LIKE '%august%';

# 5.	(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

SELECT *
FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY CASE id
             WHEN 5 THEN 1
             WHEN 1 THEN 2
             ELSE 3
             END;

# Практическое задание теме «Агрегация данных»

# 1.	Подсчитайте средний возраст пользователей в таблице users.

SELECT FLOOR(AVG(DATEDIFF(NOW(), birthday_at)) / 365.25) AS average_age
FROM users;

# 2.	Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT CASE DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at)))
           WHEN 1 THEN 'Sunday'
           WHEN 2 THEN 'Monday'
           WHEN 3 THEN 'Tuesday'
           WHEN 4 THEN 'Wednesday'
           WHEN 6 THEN 'Thursday'
           WHEN 7 THEN 'Friday'
           ELSE 'Saturday'
           END
                AS day_of_week,
       COUNT(*) AS birthdays
FROM users
GROUP BY day_of_week
ORDER BY birthdays DESC;

# 3.	(по желанию) Подсчитайте произведение чисел в столбце таблицы.

DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers
(
    value TINYINT UNSIGNED
);

INSERT INTO numbers
VALUES (1),
       (2),
       (3),
       (4),
       (5);

SELECT CEILING(EXP(SUM(LOG(value)))) AS product
FROM numbers;

