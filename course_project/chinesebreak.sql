/*
Требования к курсовому проекту:
1) Составить общее текстовое описание БД и решаемых ею задач;
2) минимальное количество таблиц - 10;
3) скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
4) создать ERDiagram для БД;
5) скрипты наполнения БД данными;
6) скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
7) представления (минимум 2);
8) хранимые процедуры / триггеры;

9) Примеры: описать модель хранения данных популярного веб-сайта: кинопоиск, booking.com, wikipedia, интернет-магазин, geekbrains, госуслуги...


База должна хранить данные

    -о ролях
        -админ (учитель) - имеет доступ к админке для наполнения уч материалом курс)
        -пользователь (ученик) - использует web\mobile app

    -о медиафайлах. для каждого изучаемого элемента (слова, иероглифа, грамматики), предложения есть аудио, для иероглифов есть анимация начертания, для упраждений с картинками - картика, с видео - видео и тд
        -аудио
        -видео
        -картинка (растр\вектор)
        -анимация (растр\вектор)

    -о структуре и составе учебного материала, который формируется и заполняется админом в админке
        -общая иерархия учебного материала
            -язык
            -курс(группа топиков)
            -топик(тематика)
            -урок
            -задание

        -контента учебного материала (элементы, из которых составляются задания которые пользователь проходит в практических упражнениях)
            -слово
            -иероглиф
            -грамматика


    -о видах заданий, которыми будут наполняться уроки "для прохождения", и которые будут запускаться "для повторения"
        -упражнений при прохождении элементов
        -упражнений при повторении элементов

    персональные данные касаемые учебного прогресса пользователя
        -список пройденных элементов (когда впервые пользователь прошел элемент - он доступен к просмотру в виде карточки элемента, в которой указана основная информация об этом элементе и примере его использования =правильные ответы на задания при прохождении)
        -счетчик правильных\неправильных ответов в элементах (сколько раз пользователь правильно\неправильно ответил на задание при прохождении или повторении этого элемента)
        -данные о взаимосвязи элемента и времени когда он был пройден\повторен (когда по истечению определенной временной воронки элемент должен попасть в "пул повторения" для возможности запуска упражнений на повторение.

 */

DROP DATABASE IF EXISTS chinesebreak;
CREATE DATABASE chinesebreak;
USE chinesebreak;

DROP TABLE IF EXISTS admin;
CREATE TABLE admin
(
    id            SERIAL PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         BIGINT UNSIGNED,
    status        ENUM ('super', 'manager') COMMENT 'у супера права на публикацию и удаление опубликованных разделов, у менджеров права на формирование учебного материала',
    registered_at DATETIME DEFAULT NOW(),
    updated_at    DATETIME ON UPDATE NOW(),
    INDEX admin_first_last_name (first_name, last_name)
) COMMENT 'админ (учитель) - имеет доступ к админке для наполнения уч материалом курс)';

DROP TABLE IF EXISTS user;
CREATE TABLE user
(
    id            SERIAL PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         BIGINT UNSIGNED,
    registered_at DATETIME              DEFAULT NOW(),
    updated_at    DATETIME ON UPDATE NOW(),
    status        ENUM (
        'trial',
        'premium_1',
        'premium_6',
        'premium_12')          NOT NULL DEFAULT 'trial' COMMENT 'по умолчанию у пользователя статус подписки trial, если по подписке - то есть на месяц, пол года или на год',
    purchased_at  DATETIME     NOT NULL,
    INDEX user_first_last_name (first_name, last_name),
    INDEX user_email (email),
    INDEX user_status (status)
) COMMENT 'пользователь (ученик) - использует web/mobile app';

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(50) NOT NULL,
    type      ENUM ('audio', 'video', 'image bitmap', 'image svg', 'anim gif', 'anim svg') COMMENT '-аудио, -видео, -картинка (растр/вектор), -анимация (растр/вектор)',
    file_path VARCHAR(2083),
    INDEX name_ind (name)
) COMMENT 'медиафайлы. для каждого изучаемого элемента (слова, иероглифа, грамматики), предложения есть аудио, для иероглифов есть анимация начертания, для упраждений с картинками - картика, с видео - видео и тд';

DROP TABLE IF EXISTS language;
CREATE TABLE language
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED NOT NULL,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    is_published     BIT      DEFAULT 0,
    published_at     DATETIME        NOT NULL,
    INDEX name_ind (name)
) COMMENT 'общая иерархия учебного материала, на самом верху язык. предполагаем, что материал китайскому языку будем обучать не только русских, но в перспективе людей говорящих на других языках';


DROP TABLE IF EXISTS course;
CREATE TABLE course
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED NOT NULL,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    is_published     BIT      DEFAULT 0,
    published_at     DATETIME        NOT NULL,
    INDEX name_ind (name)
) COMMENT 'курс(группа топиков)';

DROP TABLE IF EXISTS topic;
CREATE TABLE topic
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED NOT NULL,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    media_id         BIGINT UNSIGNED NOT NULL COMMENT 'svg иконка',
    INDEX name_ind (name)
) COMMENT 'топик(тематика уроков)';

DROP TABLE IF EXISTS lesson;
CREATE TABLE lesson
(
    id               SERIAL PRIMARY KEY,
    creator_admin_id BIGINT UNSIGNED NOT NULL,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW()
) COMMENT 'урок';

DROP TABLE IF EXISTS task_type;
CREATE TABLE task_type
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) COMMENT 'типы заданий';
# 22 типа задания "на прохождение". добавляются админами в админке/ условно все типы можно разделить на работу со словами (в фигме это желтые), с предложениями (коричневые), с диалогами (фиолетовые), с паззлами(розовые), и ривалка иероглифов'
# 3 типа заданий. формируются при создании соответствующего элеметна. 2 запускаются при "повторе с носителями" (слова, грамматика) и при запуске "рисовалки"(иероглиф). рисовалку можно запустить "при прохождении" уроков.
# 2 типа на "повторение" слов / 4 доп. типа на "повтор сложного".

INSERT INTO task_type
VALUES (1, 'word_image'),
       (2, 'word_char_from_lang'),
       (3, 'word_lang_from_char'),
       (4, 'word_char_from_video'),
       (5, 'word_match'),
       (6, 'sent_image'),
       (7, 'sent_char_from_lang'),
       (8, 'sent_lang_from_char'),
       (9, 'sent_lang_from_video'),
       (10, 'sent_say_from_char'),
       (11, 'sent_say_from_video'),
       (12, 'sent_paste_from_char'),
       (13, 'sent_choose_from_char'),
       (14, 'sent_delete_from_char'),
       (15, 'dialog_A_char_from_char'),
       (16, 'dialog_B_char_from_video'),
       (17, 'dialog_A_puzzle_char_from_char'),
       (18, 'dialog_B_puzzle_char_from_char'),
       (19, 'puzzle_char_from_lang'),
       (20, 'puzzle_lang_from_char'),
       (21, 'puzzle_char_from_video'),
       (22, 'draw_character');

DROP TABLE IF EXISTS task;
CREATE TABLE task
(
    elements        JSON NOT NULL,
    right_sentences JSON NOT NULL,
    wrong_sentences JSON NOT NULL,
    media           JSON NOT NULL
) COMMENT 'задания в уроках и при повторении';

INSERT INTO task (elements, right_sentences, wrong_sentences, media)
VALUES ('{
  "words": [],
  "words_are_active_or_to_del": [],
  "words_to_display": [],
  "grammar": [],
  "wrong_words": [],
  "character": []
}',
        '{
          "sent_char_A": [],
          "sent_pinyin_A": [],
          "sent_lang_A": [],
          "sent_lit_A": [],
          "sent_char_B": [],
          "sent_pinyin_B": [],
          "sent_lang_B": [],
          "sent_lit_B": []
        }',
        '{
          "sent_lang": [],
          "pinyin": [],
          "sent_char": []
        }',
        '{
          "sent_images": [],
          "sent_images_right": [],
          "video": [],
          "sent_audio_A": [],
          "sent_audio_B": []
        }');

DROP TABLE IF EXISTS lessons_tasks;
CREATE TABLE lessons_tasks
(
    language_id  BIGINT UNSIGNED NOT NULL,
    course_id    BIGINT UNSIGNED NOT NULL,
    topic_id     BIGINT UNSIGNED NOT NULL,
    lesson_id    BIGINT UNSIGNED NOT NULL,
    task_type_id BIGINT UNSIGNED NOT NULL,
    task_id      BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (language_id, course_id, topic_id, lesson_id, task_type_id, task_id)
)
    COMMENT 'типы заданий';


DROP TABLE IF EXISTS word;
CREATE TABLE word
(
    id             SERIAL PRIMARY KEY,
    pinyin         VARCHAR(50)     NOT NULL,
    `char`         VARCHAR(50)     NOT NULL,
    lang           VARCHAR(50)     NOT NULL,
    lit            VARCHAR(50)     NOT NULL,
    audio_media_id BIGINT UNSIGNED NOT NULL,
    image_media_id BIGINT UNSIGNED NOT NULL,
    INDEX word_pinyin_ind (pinyin),
    INDEX word_char_ind (`char`),
    INDEX word_lang_ind (lang),
    INDEX word_lit_ind (lit)
);

DROP TABLE IF EXISTS grammar;
CREATE TABLE grammar
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(512) NOT NULL,
    explanation TEXT,
    `char`      VARCHAR(512) NOT NULL,
    pinyin      VARCHAR(512) NOT NULL,
    lang        VARCHAR(512) NOT NULL,
    structure   VARCHAR(512) NOT NULL,
    INDEX grammar_name_ind (name)
);

DROP TABLE IF EXISTS `character`;
CREATE TABLE `character`
(
    id                      SERIAL PRIMARY KEY,
    pinyin                  VARCHAR(50)     DEFAULT NULL,
    `char`                  VARCHAR(50)     DEFAULT NULL,
    lang                    VARCHAR(50)     DEFAULT NULL,
    image_media_id          BIGINT UNSIGNED DEFAULT NULL,
    audio_media_id          BIGINT UNSIGNED DEFAULT NULL,
    char_animation_media_id JSON            NOT NULL,
    INDEX character_pinyin_ind (pinyin),
    INDEX character_char_ind (`char`),
    INDEX character_lang_ind (lang)
);

INSERT INTO `character`(char_animation_media_id) VALUES (
    '{
      "svg_animation_id_set": []
    }'
    );


