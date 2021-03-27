-- DML (data manipulation language) - язык манипулирования данными
-- CRUD (create, read, update, delete, truncate)

-- Create – INSERT
-- Read  – SELECT
-- Update – UPDATE
-- Delete – DELETE, TRUNCATE


USE vk;

# insert
INSERT IGNORE INTO users (id, firstname, lastname, email, password_hash, phone)
VALUES ('1', 'Dean', 'Satterfield', 'orin69@example.net', 'kjhlkjglkglgk123kljgkj123', '9160120629');

INSERT INTO users (id, firstname, lastname, email, password_hash, phone)
VALUES ('3', 'Dean', 'Satterfield', 'orin69@example1.net', 'kjhlkjglkglgk123kljgkj123', '9160120629');

INSERT INTO users (firstname, lastname, email, password_hash)
VALUES ('Dean', 'Satterfield', 'orin69@example2.net', 'kjhlkjglkglgk123kljgkj123');

INSERT INTO users (firstname, lastname, email, password_hash, phone)
VALUES ('Dean', 'Satterfield', 'orin69@example3.net', 'kjhlkjglkglgk123kljgkj123', NULL);

INSERT INTO users (firstname, lastname, email)
VALUES ('Dean', 'Satterfield', 'orin69@example4.net');

INSERT INTO users (firstname, lastname, email, password_hash, phone, is_deleted)
VALUES ('Bob', 'Marley', 'sobaka@mail.ru', 'skdjhfskdjfsdfsg', DEFAULT, NULL);

INSERT INTO users (firstname, lastname, email, password_hash, phone, is_deleted)
VALUES ('Bob', 'Marley', 'smoke@mail.ru', 'skdjhfskdjfsdfsg', DEFAULT, DEFAULT);

INSERT users (id, firstname, lastname, email, is_deleted)
VALUES (8, 'Dean', 'Satterfield8', 'orin76@example.net', 1);

INSERT IGNORE users
VALUES (11, 'Dean', 'Satterfield9', 'orin77@example.net', 'lklkjkl', '9160120629', 1);

-- INSERT users
-- VALUES ('Dean', 'Satterfield10', 'orin78@example.net', 'lklkjkl', '9160120629', 1);

INSERT users (firstname, lastname, email)
VALUES ('Dean', 'orin76@example.net', 'Satterfield8');

INSERT users (firstname, lastname, email, phone, is_deleted)
VALUES ('Reuben', 'Nienow1', 'arlo500@example.org', NULL, 0),
       ('Reuben', 'Nienow2', 'arlo501@example.org', '911234456', 1),
       ('Reuben', 'Nienow3', 'arlo502@example.org', '911234457', 1),
       ('Reuben', 'Nienow4', 'arlo503@example.org', NULL, 0);

INSERT INTO users
SET firstname='Ivan',
    lastname='Divanov',
    email= 'ivandivanov@mail.ru',
    phone= DEFAULT;


# select
INSERT users (firstname, lastname, email)
SELECT first_name, last_name, email
FROM sakila.staff;

SELECT 'hello world';

SELECT *
FROM users;

SELECT firstname, lastname
FROM users;

SELECT DISTINCT firstname
FROM users;

SELECT DISTINCT id, firstname
FROM users;

SELECT *
FROM users
WHERE id = 1
   OR id = 9
HAVING firstname = 'Bob';

SELECT *
FROM users
LIMIT 5 OFFSET 2;

SELECT *
FROM users
WHERE phone = 911234457;

SELECT *
FROM users
WHERE is_deleted = false;

SELECT *
FROM users
WHERE firstname = '';

SELECT *
FROM users
WHERE phone IS NULL;

SELECT *
FROM users
WHERE phone IS NOT NULL;

# отправить запрос на добавление в друзья
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, `status`)
VALUES ('1', '3', 'requested'),
       ('1', '5', 'requested'),
       ('1', '6', 'requested'),
       ('1', '7', 'requested');

INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`)
VALUES ('1', '8'),
       ('1', '9');

UPDATE friend_requests
SET status = 'approved'
WHERE initiator_user_id = 1
  AND target_user_id = 3;

UPDATE friend_requests
SET status = 'declined'
WHERE initiator_user_id = 1
  AND target_user_id = 5;

INSERT INTO messages (from_user_id, to_user_id, body)
VALUES (1, 3,
        'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.'),
       (3, 1,
        'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.'),
       ('4', '1',
        'Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.'),
       ('1', '5',
        'Quod dicta omnis placeat id et officiis et. Beatae enim aut aliquid neque occaecati odit. Facere eum distinctio assumenda omnis est delectus magnam.'),
       ('7', '6',
        'Voluptas omnis enim quia porro debitis facilis eaque ut. Id inventore non corrupti doloremque consequuntur. Molestiae molestiae deleniti exercitationem sunt qui ea accusamus deserunt.');


DELETE
FROM messages
WHERE from_user_id = 1;

DELETE
FROM messages
WHERE from_user_id IN (SELECT id
                       FROM users
                       WHERE firstname = 'DEAN');

# [42000][1701] Cannot truncate a table referenced in a foreign key constraint (`vk`.`spam`, CONSTRAINT `spam_ibfk_2`)
# то есть если на текущую таблицу ссылаются внешние ключи, она не может быть truncate...
TRUNCATE messages;
