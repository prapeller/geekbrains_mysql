# ddl - data definition language
# create, alter, drop

DROP DATABASE IF EXISTS vk;
CREATE DATABASE VK;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
#     id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    id            SERIAL PRIMARY KEY,
    firstname     VARCHAR(100),
    lastname      VARCHAR(100) COMMENT 'Фамилия',
    email         VARCHAR(150) UNIQUE,
    password_hash VARCHAR(100),
    phone         BIGINT UNSIGNED,
    INDEX users_firstname_lastname_ind (lastname, firstname)
);

ALTER TABLE users
    ADD COLUMN is_deleted bit DEFAULT 0;

# 1 - 1
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles`
(
    user_id    SERIAL PRIMARY KEY,
#     FOREIGN KEY (user_id) REFERENCES users (id)
    gender     CHAR(1),
    birthday   DATE,
    photo_id   BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW()
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;


# ON DELETE, ON UPDATE;
# NO ACTION
# CASCADE
# RESTRICT
# SET NULL
# SET DEFAULT

# 1 - M
DROP TABLE IF EXISTS messages;
CREATE TABLE messages
(
    id           SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id   BIGINT UNSIGNED NOT NULL,
    body         TEXT,
    created_at   DATETIME DEFAULT NOW(),
    FOREIGN KEY (from_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests
(
#     id                SERIAL PRIMARY KEY,
    initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id    BIGINT UNSIGNED NOT NULL,
    requested_at      DATETIME DEFAULT NOW(),
    updated_at        DATETIME ON UPDATE NOW(),                                 # CURRENT_TIMESTAMP
    `status`          ENUM ('requested', 'approved', 'declined', 'unfriended'), # под каждый статкс 1байт
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users (id),
    FOREIGN KEY (target_user_id) REFERENCES users (id)
);


DROP TABLE IF EXISTS communities;
CREATE TABLE communities
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(150),
    admin_user_id BIGINT UNSIGNED NOT NULL,
    INDEX communities_name_ind (name),
    FOREIGN KEY (admin_user_id) REFERENCES users (id)
);

# M - M
DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities
(
    user_id      BIGINT UNSIGNED NOT NULL,
    community_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (user_id, community_id), -- 1 user cant be associated with the same community twice
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (community_id) REFERENCES communities (id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id            SERIAL PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    body          TEXT,
#     filename BLOB,
    media_type_id BIGINT UNSIGNED,
    filename      VARCHAR(255),
    `size`        INT,
    metadata      JSON,
    created_at    DATETIME DEFAULT NOW(),
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (media_type_id) REFERENCES media_types (id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes
(
    id         SERIAL PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    media_id   BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums`
(
    `id`      SERIAL PRIMARY KEY,
    `name`    VARCHAR(255)    DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos`
(
    id         SERIAL PRIMARY KEY,
    `album_id` BIGINT unsigned NOT NULL,
    `media_id` BIGINT unsigned NOT NULL,
    FOREIGN KEY (album_id) REFERENCES photo_albums (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS music_genres;
CREATE TABLE music_genres
(
    id         SERIAL PRIMARY KEY,
    genre_name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

DROP TABLE IF EXISTS music_tracks;
CREATE TABLE music_tracks
(
    id             SERIAL PRIMARY KEY,
    user_id        BIGINT UNSIGNED COMMENT 'кто загрузил аудиотрэк, может быть null если user загрузил трек и удалился',
    music_genre_id BIGINT UNSIGNED NOT NULL COMMENT 'если админы соцсети решат, что какойто жанр плохо влияет на пользователей, то при удалении жанра в таблице жанров - все треки этого жанра должны удалиться))',
    name           VARCHAR(255),
    lyrics         TEXT COMMENT 'если пользователь захотел еще и текст песен добавить',
    INDEX name_genre_index (name, music_genre_id) COMMENT 'в этом случае поиск быстрей будет по имени нежели по жанру?',
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (music_genre_id) REFERENCES music_genres (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS spam;
CREATE TABLE spam
(
    id         SERIAL PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL COMMENT 'кто спамит, не может быть null)) главное отследить кто спамит))',
    message_id BIGINT UNSIGNED NOT NULL COMMENT 'если юзер удаляет сообщение, то оно удаляется и из списка спама',
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (message_id) REFERENCES messages (id) ON UPDATE CASCADE ON DELETE CASCADE
);
