-- DML (data manipulation language) - язык манипулирования данными
-- CRUD (create, read, update, delete, truncate)

-- Create – INSERT 
-- Read  – SELECT
-- Update – UPDATE
-- Delete – DELETE, TRUNCATE


-- insert
USE vk;

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`) 
VALUES ('1', 'Dean', 'Satterfield', 'orin69@example.net', 'kjhlkjglkglgk123kljgkj123', '9160120629');

INSERT INTO users (firstname, lastname, email, phone) 
VALUES ('Dean', 'Satterfield2', 'orin70@example.net', NULL);

INSERT INTO users (firstname, lastname, email) 
VALUES ('Dean', 'Satterfield3', 'orin71@example.net');

-- ALTER TABLE users 
-- ADD COLUMN is_deleted bit DEFAULT 0; 

INSERT users (firstname, lastname, email, phone) 
VALUES ('Dean', 'Satterfield4', 'orin72@example.net', 0);

INSERT users (firstname, lastname, email, is_deleted) 
VALUES ('Dean', 'Satterfield5', 'orin73@example.net', NULL );

INSERT users (firstname, lastname, email, is_deleted) 
VALUES ('Dean', 'Satterfield6', 'orin74@example.net', DEFAULT );

INSERT users (firstname, lastname, email) 
VALUES ('Dean', 'Satterfield7', 'orin75@example.net');

INSERT users (id, firstname, lastname, email, is_deleted) 
VALUES (8, 'Dean', 'Satterfield8', 'orin76@example.net', 1);


INSERT ignore users 
VALUES (11, 'Dean', 'Satterfield9', 'orin77@example.net', 'lklkjkl', '9160120629', 1);

-- INSERT users 
-- VALUES ('Dean', 'Satterfield10', 'orin78@example.net', 'lklkjkl', '9160120629', 1);

INSERT users (firstname, lastname, email) 
VALUES ('Dean', 'orin76@example.net', 'Satterfield8');

INSERT users (firstname, lastname, email, phone, is_deleted) 
VALUES
('Reuben', 'Nienow1', 'arlo500@example.org', NULL, 0),
('Reuben', 'Nienow2', 'arlo501@example.org', '911234456', 1),
('Reuben', 'Nienow3', 'arlo502@example.org', '911234457', 1),
('Reuben', 'Nienow4', 'arlo503@example.org', NULL, 0);

INSERT INTO users
SET
	firstname = 'Иван',
	lastname = 'Диванов',
	email = 'ivan@mail.ru',
	phone = '987654321';


INSERT INTO users 
	(firstname, lastname, email, phone) 
select 
      'Reuben', 'Nienow4', 'arlo555@example.org', 3333333333;

     
INSERT INTO users 
	(firstname, lastname, email) 
select first_name, last_name, email  from  sakila.staff;
     


-- select

Select 1;

Select 10+20;

Select 'hello_world';

SELECT * FROM users;

SELECT distinct firstname, lastname
FROM users;

SELECT distinct firstname
FROM users;

SELECT distinct id, firstname
FROM users;

SELECT * FROM users
WHERE id = 1;

SELECT * FROM users
WHERE id >=2 AND id<15;


SELECT *
FROM users
-- LIMIT 5 offset 0;
-- LIMIT 5 offset 5;
-- LIMIT 5 offset 10;
LIMIT 5 offset 15;


SELECT *
FROM users
WHERE phone is not Null;


SELECT *
FROM users
WHERE id = 5 OR firstname = 'Reuben';

SELECT *
FROM users
WHERE id IN (1,2,30,4);

-- update

-- отправка запроса в друзья
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, `status`)
VALUES ('1', '3', 'requested');
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, `status`)
VALUES ('1', '5', 'requested');
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, `status`)
VALUES ('1', '6', 'requested');
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, `status`)
VALUES ('1', '7', 'requested');


ALTER TABLE vk.friend_requests MODIFY COLUMN status enum('requested','approved','declined','unfriended') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'requested' NULL;

INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`)
VALUES ('1', '6');
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`)
VALUES ('1', '7');


/* UPDATE friend_requests
SET 
	status = 'approved';

UPDATE friend_requests
SET 
	status = 'requested';
*/	


-- принять запрос о дружбе
UPDATE friend_requests
SET 
	status = 'approved'
WHERE
	initiator_user_id = 1 and target_user_id = 2;


UPDATE friend_requests
SET 
	status = 'approved',
	updated_at = requested_at 
WHERE
	initiator_user_id = 1 and target_user_id = 2;




-- отклонить запрос в друзья
UPDATE friend_requests
SET 
	status = 'declined'
WHERE
	initiator_user_id = 1 and target_user_id = 3;




-- DELETE

-- добавим несколько сообщений
INSERT INTO messages (from_user_id, to_user_id, body) 
values 
(1, 2, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.'),
(2, 1,'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.'),
('3','1','Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.'),
('1','3','Quod dicta omnis placeat id et officiis et. Beatae enim aut aliquid neque occaecati odit. Facere eum distinctio assumenda omnis est delectus magnam.'),
('1','5','Voluptas omnis enim quia porro debitis facilis eaque ut. Id inventore non corrupti doloremque consequuntur. Molestiae molestiae deleniti exercitationem sunt qui ea accusamus deserunt.');


-- delete from messages;

delete from messages
where from_user_id = 1;

delete from messages
where from_user_id IN (
select id from users 
where lastname='Satterfield2');

delete from users;
truncate messages; 

























