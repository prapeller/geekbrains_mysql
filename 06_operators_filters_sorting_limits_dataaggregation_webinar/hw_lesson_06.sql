# Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

#1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался
# с нашим пользователем.

# на примере пользователя с id = 18,
# с 38м дружили до этого, появилась у него парочка друзей после: 37, 16

# INSERT INTO friend_requests (initiator_user_id, target_user_id, status, confirmed_at)
# VALUES (18, 37, 'approved', NOW()),
#        (16, 18, 'approved', NOW());

# собрались они на вечеринку ))

# INSERT INTO messages (from_user_id, to_user_id, body)
# VALUES (18, 38, 'hello'),
#        (38, 18, 'heeelllloooo'),
#        (18, 38, 'lets go party!'),
#        (38, 18, 'ok!'),
#        (38, 18, 'and please call Mike, you recently met, you are friends recently'),
#        (18, 38, 'ok!'),
#        (18, 16, 'lets go party!'),
#        (18, 38, 'hey, you should also call Mike!'),
#        (38, 18, 'ok!'),
#        (38, 16, 'lets go party!');

#1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался
# с нашим пользователем.

# а)

SELECT friend, COUNT(*) qty
FROM
#     кто писал 18му
(SELECT from_user_id friend
 FROM messages
 WHERE from_user_id IN (SELECT target_user_id
                        FROM friend_requests
                        WHERE initiator_user_id = 18
                          AND status = 'approved'
                        UNION
                        SELECT initiator_user_id
                        FROM friend_requests
                        WHERE target_user_id = 18
                          AND status = 'approved')
   AND to_user_id = 18

 UNION ALL

#     кому писал 18й
 SELECT to_user_id friend
 FROM messages
 WHERE to_user_id IN (SELECT target_user_id
                      FROM friend_requests
                      WHERE initiator_user_id = 18
                        AND status = 'approved'
                      UNION
                      SELECT initiator_user_id
                      FROM friend_requests
                      WHERE target_user_id = 18
                        AND status = 'approved')
   AND from_user_id = 18
) total
GROUP BY friend
ORDER BY qty DESC
LIMIT 1;


# б) созданим таблицу друзей
DROP VIEW IF EXISTS 18_and_friends;
CREATE VIEW 18_and_friends AS
SELECT target_user_id friend
FROM friend_requests
WHERE initiator_user_id = 18
  AND status = 'approved'
UNION
SELECT initiator_user_id friend
FROM friend_requests
WHERE target_user_id = 18
  AND status = 'approved';

# преписка с участием 18го
DROP VIEW IF EXISTS `18_and_friends_chat`;
CREATE VIEW 18_and_friends_chat AS
SELECT *
FROM messages
WHERE (from_user_id IN (SELECT * FROM 18_and_friends) AND to_user_id = 18)
   OR (to_user_id IN (SELECT * FROM 18_and_friends) AND from_user_id = 18)
ORDER BY from_user_id;

# лучший друг и количество сообщений (ему + от него)
SELECT friend, COUNT(*) sum
FROM (SELECT from_user_id friend
      FROM 18_and_friends_chat
      WHERE from_user_id != 18
      UNION ALL
      SELECT to_user_id
      FROM 18_and_friends_chat
      WHERE to_user_id != 18) AS 18_chat
GROUP BY friend
ORDER BY sum DESC
LIMIT 1;


# 2.Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
SELECT COUNT(*) AS users_below_10_received_likes
FROM likes
WHERE media_id IN (SELECT id
                   FROM media
                   WHERE user_id IN (SELECT user_id
                                     FROM profiles
                                     WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10));


# Подсчитать общее количество лайков, которые поставили пользователи младше 10 лет.

SELECT SUM(like_quantity) AS 'users_below_10_gave_likes'
FROM (SELECT user_id, COUNT(*) AS 'like_quantity'
      FROM likes
      GROUP BY user_id
      HAVING user_id IN (SELECT user_id
                         FROM profiles
                         WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10)) AS users_quantity;

# 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT (SELECT SUM(women_like) AS total_women_like
        FROM (SELECT user_id, COUNT(*) as women_like
              FROM likes
              GROUP BY user_id
              HAVING user_id IN (SELECT user_id AS women_id
                                 FROM profiles
                                 WHERE gender = 'f')) AS likes_per_woman) AS total_women_likes,
       (SELECT SUM(men_like) AS total_men_like
        FROM (SELECT user_id, COUNT(*) as men_like
              FROM likes
              GROUP BY user_id
              HAVING user_id IN (SELECT user_id AS men_id
                                 FROM profiles
                                 WHERE gender = 'm')) AS likes_per_man)   AS total_men_likes;