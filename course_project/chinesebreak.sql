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

приложение для изучения китайского. копия основного функционала на прохождение уроков существующего приложение hellochinese
думаю имеет смысл разделить на данные админки, и пользовательные данные
табличное представление данных из первого курса: https://docs.google.com/spreadsheets/d/1la_atKTDrziyPFU22DQsm25utBWK5ppYP3MRAMS280U/edit?usp=sharing
экранчики фронта тут: https://www.figma.com/file/EhIEXnGEn2S70FqKshyjZE/chinesego?node-id=937%3A0


База должна хранить данные

    -об администраторах (учитель) - имеет доступ к админке для наполнения уч материалом курс)

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


    -о пользователях (учениках) - использует web\mobile app

    -данные касаемые учебного прогресса пользователя
        -какие уроки в каких топиках пройдены (наверное, лучше через зависимость топиков от заданий) то есть если пройдены все задания урока - открывается следующий урок, если пройдены все уроки топика - открывается следующий топик, если все топики курса - следущий курс. но должна быть предусмеотрена возможность досрочного прохождения курсового теста с открытием всех топиков всех уроков всех элементов внутри курса
        -какие элементы пройдены (пользователь впервые прошел задание, в котором элемент активен - этот элемент становится доступен к просмотру в виде карточки элемента, в которой указана основная информация об этом элементе и примере его использования = правильные ответы на задания при прохождении)
        -счетчик правильных\неправильных ответов в элементах (сколько раз пользователь правильно\неправильно ответил на задание при прохождении или повторении этого элемента)
        -данные о попадании элемента в "пул повторения" для возможности запуска упражнений на повторение этого элемента.

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

INSERT INTO admin (first_name, last_name, email, password_hash, phone, status, registered_at, updated_at)
VALUES ('admin1', 'adminov1', 'ololo@gmail.com', 'alaululuakakakaukauka123', 89230030303, 'super', NOW(), NOW());


DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(50) NOT NULL,
    type      ENUM ('audio', 'video', 'bitmap','svg', 'gif') COMMENT '-аудио, -видео, -картинка (растр/вектор), -анимация (растр/вектор)',
    file_path VARCHAR(2083),
    INDEX name_ind (name)
) COMMENT 'медиафайлы. для каждого изучаемого элемента (слова, иероглифа, грамматики), предложения есть аудио, для иероглифов есть анимация начертания, для упраждений с картинками - картика, с видео - видео и тд';

INSERT INTO media (name, type, file_path)
VALUES ('привет.png', 'bitmap', 'https://i.ibb.co/Y8VzyBg/1.png'),
       ('привет.mp3', 'audio', 'https://docs.google.com/uc?id=1Q0kH8043OFYYzoo7xgyTaLx4vEHE2mlE');

DROP TABLE IF EXISTS language;
CREATE TABLE language
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    is_published     BIT      DEFAULT 0,
    published_at     DATETIME,
    INDEX name_ind (name),
    CONSTRAINT language_creator_admin_id_fk FOREIGN KEY (creator_admin_id) REFERENCES admin (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT 'общая иерархия учебного материала, на самом верху язык. предполагаем, что материал китайскому языку будем обучать не только русских, но в перспективе людей говорящих на других языках';

INSERT INTO language (name, creator_admin_id, created_at, updator_admin_id, updated_at, is_published, published_at)
VALUES ('russian', 1, NOW(), 1, NOW(), 0, NULL);

DROP TABLE IF EXISTS course;
CREATE TABLE course
(
    id               SERIAL PRIMARY KEY,
    language_id      BIGINT UNSIGNED,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    is_published     BIT      DEFAULT 0,
    published_at     DATETIME,
    INDEX name_ind (name),
    CONSTRAINT course_creator_admin_id_fk FOREIGN KEY (creator_admin_id) REFERENCES admin (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT language_id_fk FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT 'курс(группа топиков)';

INSERT INTO course (language_id, name, creator_admin_id, created_at, updator_admin_id, updated_at, is_published,
                    published_at)
VALUES (1, 'HSK-1', 1, NOW(), 1, NOW(), 0, NULL);

DROP TABLE IF EXISTS topic;
CREATE TABLE topic
(
    id               SERIAL PRIMARY KEY,
    course_id        BIGINT UNSIGNED,
    name             VARCHAR(50)     NOT NULL,
    creator_admin_id BIGINT UNSIGNED,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    media_id         BIGINT UNSIGNED COMMENT 'svg иконка',
    INDEX name_ind (name),
    CONSTRAINT topic_creator_admin_id_fk FOREIGN KEY (creator_admin_id) REFERENCES admin (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT course_id_fk FOREIGN KEY (course_id) REFERENCES course (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT 'топик(тематика уроков)';

INSERT INTO topic (course_id, name, creator_admin_id, created_at, updator_admin_id, updated_at, media_id)
VALUES (1, 'Привет', 1, NOW(), 1, NOW(), 1);

DROP TABLE IF EXISTS lesson;
CREATE TABLE lesson
(
    id               SERIAL PRIMARY KEY,
    topic_id         BIGINT UNSIGNED,
    creator_admin_id BIGINT UNSIGNED,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    CONSTRAINT lesson_creator_admin_id_fk FOREIGN KEY (creator_admin_id) REFERENCES admin (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT topic_id_fk FOREIGN KEY (topic_id) REFERENCES topic (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT 'урок';

INSERT INTO lesson (topic_id, creator_admin_id, created_at, updator_admin_id, updated_at)
VALUES (1, 1, NOW(), 1, NOW());

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
    id               SERIAL PRIMARY KEY,
    lesson_id        BIGINT UNSIGNED,
    task_type_id     BIGINT UNSIGNED    NOT NULL,
    creator_admin_id BIGINT UNSIGNED,
    created_at       DATETIME DEFAULT NOW(),
    updator_admin_id BIGINT UNSIGNED    NOT NULL,
    updated_at       DATETIME ON UPDATE NOW(),
    elements         JSON               NOT NULL,
    right_sentences  JSON               NOT NULL,
    wrong_sentences  JSON               NOT NULL,
    media            JSON               NOT NULL,
    CONSTRAINT lesson_id_fk FOREIGN KEY (lesson_id) REFERENCES lesson (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT task_type_id_fk FOREIGN KEY (task_type_id) REFERENCES task_type (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT task_creator_admin_id_fk FOREIGN KEY (creator_admin_id) REFERENCES admin (id) ON DELETE SET NULL ON UPDATE CASCADE

) COMMENT 'задание в уроке';

INSERT INTO task (lesson_id, task_type_id, creator_admin_id, created_at, updator_admin_id, updated_at, elements,
                  right_sentences, wrong_sentences, media)
VALUES (1, 1, 1, NOW(), 1, NOW(),
        '{
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

DROP TABLE IF EXISTS word;
CREATE TABLE word
(
    id             SERIAL PRIMARY KEY,
    topic_id       BIGINT UNSIGNED,
    `char`         VARCHAR(50)     NOT NULL,
    pinyin         VARCHAR(50)     NOT NULL,
    lang           VARCHAR(50)     NOT NULL,
    lit            VARCHAR(50),
    image_media_id BIGINT UNSIGNED NOT NULL,
    audio_media_id BIGINT UNSIGNED NOT NULL,
    INDEX word_char_ind (`char`),
    INDEX word_pinyin_ind (pinyin),
    INDEX word_lang_ind (lang),
    INDEX word_lit_ind (lit),
    CONSTRAINT word_topic_id FOREIGN KEY (topic_id) REFERENCES topic (id),
    CONSTRAINT word_image_media_id FOREIGN KEY (image_media_id) REFERENCES media (id),
    CONSTRAINT word_audio_media_id FOREIGN KEY (image_media_id) REFERENCES media (id)
);

INSERT INTO word (topic_id, `char`, pinyin, lang, lit, image_media_id, audio_media_id)
VALUES (1, '你好', 'nǐhǎo', 'привет', 'тебе добро', 1, 2);


DROP TABLE IF EXISTS grammar;
CREATE TABLE grammar
(
    id          SERIAL PRIMARY KEY,
    topic_id    BIGINT UNSIGNED,
    name        VARCHAR(512) NOT NULL,
    explanation VARCHAR(512) NOT NULL,
    `char`      VARCHAR(512) NOT NULL,
    pinyin      VARCHAR(512) NOT NULL,
    lang        VARCHAR(512) NOT NULL,
    lit         VARCHAR(512) NOT NULL,
    structure   VARCHAR(512) NOT NULL,
    INDEX grammar_name_ind (name),
    INDEX gramar_expl_ind (explanation),
    CONSTRAINT grammar_topic_id FOREIGN KEY (topic_id) REFERENCES topic (id)
);

INSERT INTO grammar (topic_id, name, explanation, `char`, pinyin, lang, lit, structure)
VALUES (1, 'Личные местоимения',
        'Личные местоимения не склоняются:
        我 (wǒ) я = мне
        你 (nǐ) ты = тебе
        他 (tā) он = ему
        她 (tā) она = ей',
        '我是张伟。',
        'wǒ shì zhāng wēi',
        'Я - Чжан Вэй.',
        'я есть Чжан Вэй',
        'Я = мне / ты = тебе / он = ему / она = ей');

DROP TABLE IF EXISTS `character`;
CREATE TABLE `character`
(
    id                      SERIAL PRIMARY KEY,
    topic_id                BIGINT UNSIGNED,
    `char`                  VARCHAR(50) NOT NULL,
    pinyin                  VARCHAR(50) NOT NULL,
    lang                    VARCHAR(50) NOT NULL,
    image_media_id          BIGINT UNSIGNED DEFAULT NULL,
    audio_media_id          BIGINT UNSIGNED DEFAULT NULL,
    char_animation_media_id JSON        NOT NULL,
    INDEX character_pinyin_ind (pinyin),
    INDEX character_char_ind (`char`),
    INDEX character_lang_ind (lang),
    CONSTRAINT character_topic_id FOREIGN KEY (topic_id) REFERENCES topic (id),
    CONSTRAINT character_image_media_id FOREIGN KEY (image_media_id) REFERENCES media (id),
    CONSTRAINT character_audio_media_id FOREIGN KEY (image_media_id) REFERENCES media (id)
);

INSERT INTO `character` (topic_id, `char`, pinyin, lang, image_media_id, audio_media_id, char_animation_media_id)
VALUES (1,
        '好',
        'hǎo',
        'хорошо; добро; отлично',
        1,
        2,
        '{
          "svg_animation_id_set": []
        }');

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
        'premium_12')          NOT NULL DEFAULT 'trial' COMMENT 'по умолчанию у пользователя статус подписки trial, если по подписке - то может быть на месяц, пол года или на год',
    purchased_at  DATETIME,
    INDEX user_first_last_name (first_name, last_name),
    INDEX user_email (email),
    INDEX user_status (status)
) COMMENT 'пользователь (ученик) - использует web/mobile app';

INSERT INTO user (first_name, last_name, email, password_hash, phone, registered_at, updated_at, status, purchased_at)
VALUES ('user1', 'userov1', 'pish-pish@gmail.com', 'ololopishpishrealne123', 89235230612, NOW(), NOW(), 'trial', NULL);

DROP TABLE IF EXISTS user_progress_tasks;
CREATE TABLE user_progress_tasks
(
    user_id    BIGINT UNSIGNED NOT NULL,
    task_id    BIGINT UNSIGNED NOT NULL,
    checked    BIT      DEFAULT 0,
    checked_at DATETIME DEFAULT NULL ON UPDATE NOW(),
    PRIMARY KEY (user_id, task_id),
    CONSTRAINT user_progress_task_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id),
    CONSTRAINT user_progress_task_task_id_fk FOREIGN KEY (task_id) REFERENCES task (id)
);

INSERT INTO user_progress_tasks (user_id, task_id)
VALUES (1, 1);
UPDATE user_progress_tasks
SET checked = 1
WHERE user_id = 1
  AND task_id = 1;

DROP TABLE IF EXISTS user_progress_words;
CREATE TABLE user_progress_words
(
    user_id       BIGINT UNSIGNED NOT NULL,
    word_id       BIGINT UNSIGNED NOT NULL,
    checked_at    DATETIME                            DEFAULT NULL ON UPDATE NOW(),
    checked_times ENUM ('0', '1', '2', '3', '4', '5') DEFAULT '0',
    expire_at     DATETIME                            DEFAULT NULL,
    count_right   INT UNSIGNED                        DEFAULT 0,
    count_wrong   INT UNSIGNED                        DEFAULT 0,
    PRIMARY KEY (user_id, word_id),
    CONSTRAINT user_progress_word_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id),
    CONSTRAINT user_progress_word_word_id_fk FOREIGN KEY (word_id) REFERENCES word (id)

) COMMENT 'сначала у всех элементов счетчик правильных ответов (checked_right=0) и все элементы находятся на первой ступени "мнемонической лесетки", после того как элемент проходится впервые в таске - checked_right = 1, и expire_at = NOW() + время первой ступени, после того как у него истечет это "мнемотичекое время" первой ступени - он попадает в пул повторения, после повторения его прохождением упражнение "на повторение" у этого элемента увеличивается checked_right + 1 и checked_times + 1, а expire_at становится равным NOW() + время второй ступени ';

INSERT INTO user_progress_words (user_id, word_id)
VALUES (1, 1);
UPDATE user_progress_words
SET checked_times = '1',
    count_right   = 1,
    expire_at     = ADDTIME(NOW(), '06:00:00')
WHERE user_id = 1
  AND word_id = 1;

DROP TABLE IF EXISTS user_progress_grammar;
CREATE TABLE user_progress_grammar
(
    user_id       BIGINT UNSIGNED NOT NULL,
    grammar_id    BIGINT UNSIGNED NOT NULL,
    checked_at    DATETIME                            DEFAULT NULL ON UPDATE NOW(),
    checked_times ENUM ('0', '1', '2', '3', '4', '5') DEFAULT '0',
    expire_at     DATETIME                            DEFAULT NULL,
    count_right   INT UNSIGNED                        DEFAULT 0,
    count_wrong   INT UNSIGNED                        DEFAULT 0,
    PRIMARY KEY (user_id, grammar_id),
    CONSTRAINT user_progress_grammar_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id),
    CONSTRAINT user_progress_grammar_grammar_id_fk FOREIGN KEY (grammar_id) REFERENCES grammar (id)
);

INSERT INTO user_progress_grammar (user_id, grammar_id)
VALUES (1, 1);
UPDATE user_progress_grammar
SET checked_times = '1',
    count_right   = 1,
    expire_at     = ADDTIME(NOW(), '06:00:00')
WHERE user_id = 1
  AND grammar_id = 1;

DROP TABLE IF EXISTS user_progress_character;
CREATE TABLE user_progress_character
(
    user_id       BIGINT UNSIGNED NOT NULL,
    character_id    BIGINT UNSIGNED NOT NULL,
    checked_at    DATETIME                            DEFAULT NULL ON UPDATE NOW(),
    checked_times ENUM ('0', '1', '2', '3', '4', '5') DEFAULT '0',
    expire_at     DATETIME                            DEFAULT NULL,
    count_right   INT UNSIGNED                        DEFAULT 0,
    count_wrong   INT UNSIGNED                        DEFAULT 0,
    PRIMARY KEY (user_id, character_id),
    CONSTRAINT user_progress_character_user_id_fk FOREIGN KEY (user_id) REFERENCES user (id),
    CONSTRAINT user_progress_character_character_id_fk FOREIGN KEY (character_id) REFERENCES `character` (id)
);

INSERT INTO user_progress_character (user_id, character_id)
VALUES (1, 1);
UPDATE user_progress_character
SET checked_times = '1',
    count_right   = 1,
    expire_at     = ADDTIME(NOW(), '06:00:00')
WHERE user_id = 1
  AND character_id = 1;
