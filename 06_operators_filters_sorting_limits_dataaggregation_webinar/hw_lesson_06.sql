USE vk;

#1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался
# с нашим пользователем.

# на примере пользователя с id = 33, определим кто ему больше всех написал...

SELECT from_user_id 'the best friend', COUNT(*) 'messages'
FROM messages
WHERE to_user_id = 33
GROUP BY from_user_id
ORDER BY messages DESC
LIMIT 1;

# 2.Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
SELECT COUNT(*) AS users_below_10_received_likes FROM likes WHERE media_id IN (SELECT id
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

# 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.


SELECT user_id, COUNT(*) AS user_in_community_qty FROM users_communities GROUP BY user_id;

SELECT user_id, COUNT(*) AS users_photo_albums_qty FROM photo_albums;