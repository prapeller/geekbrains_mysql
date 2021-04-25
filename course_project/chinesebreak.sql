/*
Требования к курсовому проекту:
1) Составить общее текстовое описание БД и решаемых ею задач;
2) минимальное количество таблиц - 10;
3) скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
4) создать ERDiagram для БД;
5) скрипты наполнения БД данными;
6) скрипты характерных выборок (включающие группировки 5, JOIN'ы 5, вложенные таблицы 10);
7) представления (минимум 2);
8) хранимые процедуры / триггеры;

Тема: приложение для изучения китайского. функционал приложения - копия основного функционала по прохождению уроков существующего приложения hellochinese.
Изначально база пустая, материалом наполняет админ в админке на этапе перед публикацией уроков. А пользователь наполняет данными при работе с приложением в процессе прохождения заданий в уроках.
Экранчики приблизительного фронтэнда админки (на случай если нужно будет понять как админ наполняет данные и как выглядит тот или иной вид урока): https://www.figma.com/file/EhIEXnGEn2S70FqKshyjZE/chinesego?node-id=937%3A0
Повторить приложение хотел давно, но раньше умел только экранчики нарисовать. А сейчас вот и базу данных впринципе немного получилось описать.
Возможно это не лучшая база для демострации и тренировки полученных навыков выборок и тд, но уж сильно захотелось опробовать полученные навыки mysql в старой идее повторить приложение. Так что решил совместить приятное с полезным, может потом какнить pet-project удастся сделать))

База должна хранить данные

    -об админах - учителя, составители программы обученияимеет, имеют доступ к админке для ее наполнени

    -о структуре и составе учебного материала, который формируется и заполняется админом в админке
        -общая иерархия учебного материала:
            -1 язык
            -2 курс(группа топиков)
            -3 топик(тематика)
            -4 урок
            -5 задание

        -контента учебного материала (элементы, из которых составляются задания)
            -слово
            -иероглиф
            -грамматика

    -о медиафайлах. для каждого изучаемого элемента (слова, иероглифа, грамматики, предложения(состоит из слов) есть аудио, для иероглифов есть анимация как чертится, для упраждений с картинками - картика, упражнений с видео - видео и тд
        -аудио
        -видео
        -картинка (растр\вектор)
        -анимация (растр\вектор)

    -о видах заданий, которыми будут наполняться уроки
        -упражнений при прохождении элементов
        -упражнений при повторении элементов (эти упражнения не описаны тут)

    -о пользователях - ученики, проходят задания в уроках
        -данные касаемые учебного прогресса пользователя
            -какие уроки в каких топиках пройдены (наверное, лучше через зависимость топиков от заданий) то есть если пройдены все задания урока - открывается следующий урок, если пройдены все уроки топика - открывается следующий топик, если все топики курса - следущий курс. но должна быть предусмеотрена возможность досрочного прохождения курсового теста с открытием всех топиков всех уроков всех элементов внутри курса
            -какие элементы пройдены (пользователь впервые прошел задание, в котором элемент активен - этот элемент становится доступен к просмотру в виде карточки элемента, в которой указана основная информация об этом элементе и примере его использования = правильные ответы на задания при прохождении)
            -счетчик правильных\неправильных ответов в элементах (сколько раз пользователь правильно\неправильно ответил на задание при прохождении или повторении этого элемента)
            -данные о попадании элемента в "пул повторения" для возможности запуска упражнений на повторение этого элемента.

        -данные пользовательских настроек
 */

drop database if exists chinesebreak;
create database chinesebreak;
use chinesebreak;


drop table if exists admin;
create table admin
(
    id            serial primary key,
    first_name    varchar(100) not null,
    last_name     varchar(100) not null,
    email         varchar(100) not null unique,
    password_hash varchar(512) not null,
    phone         bigint unsigned,
    status        enum ('super', 'manager') comment 'у супера права на публикацию и удаление опубликованных разделов, у менджеров права на формирование учебного материала',
    registered_at datetime default now(),
    updated_at    datetime on update now(),
    index admin_first_last_name_idx (first_name, last_name)
) comment 'админ (учитель) - имеет доступ к админке для наполнения уч материалом курс. есть супер-админ, есть менеджер-админ)';


drop table if exists media;
create table media
(
    id        serial primary key,
    name      varchar(50) not null,
    type      enum ('audio', 'video', 'picture', 'vector', 'gif') comment '-аудио, -видео, -картинка растр, -векторная картинка или анимация, gif',
    file_path varchar(2083),
    index name_idx (name)
) comment 'медиафайлы. для каждого изучаемого элемента (слова, иероглифа, грамматики), предложения есть аудио, для иероглифов есть анимация начертания, для упраждений с картинками - картика, с видео - видео и тд';


drop table if exists language;
create table language
(
    id               serial primary key,
    name             varchar(50) not null,
    creator_admin_id bigint unsigned,
    created_at       datetime        default now(),
    updator_admin_id bigint unsigned default null,
    updated_at       datetime on update now(),
    is_published     bit             default 0,
    published_at     datetime,
    index name_idx (name),
    constraint language_creator_admin_id_fk foreign key (creator_admin_id) references admin (id) on delete set null on update cascade
) comment 'общая иерархия учебного материала, на самом верху язык. предполагаем, что материал китайскому языку будем обучать не только русских, но в перспективе людей говорящих на других языках';


drop table if exists course;
create table course
(
    id               serial primary key,
    language_id      bigint unsigned,
    name             varchar(50) not null,
    creator_admin_id bigint unsigned,
    created_at       datetime        default now(),
    updator_admin_id bigint unsigned default null,
    updated_at       datetime on update now(),
    is_published     bit             default 0,
    published_at     datetime,
    index name_idx (name),
    constraint course_creator_admin_id_fk foreign key (creator_admin_id) references admin (id) on delete set null on update cascade,
    constraint language_id_fk foreign key (language_id) references language (id) on delete set null on update cascade
) comment 'курс(группа топиков)';


drop table if exists topic;
create table topic
(
    id               serial primary key,
    course_id        bigint unsigned,
    name             varchar(50) not null,
    creator_admin_id bigint unsigned,
    created_at       datetime        default now(),
    updator_admin_id bigint unsigned default null,
    updated_at       datetime on update now(),
    media_id         bigint unsigned comment 'svg иконка',
    index name_idx (name),
    constraint topic_creator_admin_id_fk foreign key (creator_admin_id) references admin (id) on delete set null on update cascade,
    constraint course_id_fk foreign key (course_id) references course (id) on delete set null on update cascade
) comment 'топик(тематика уроков)';


drop table if exists lesson;
create table lesson
(
    id               serial primary key,
    topic_id         bigint unsigned,
    creator_admin_id bigint unsigned,
    created_at       datetime        default now(),
    updator_admin_id bigint unsigned default null,
    updated_at       datetime on update now(),
    constraint lesson_creator_admin_id_fk foreign key (creator_admin_id) references admin (id) on delete set null on update cascade,
    constraint topic_id_fk foreign key (topic_id) references topic (id) on delete set null on update cascade
) comment 'урок';


drop table if exists task_type;
create table task_type
(
    id   serial primary key,
    name varchar(50) not null
) comment 'типы заданий';
# 22 типа задания "на прохождение". добавляются админами в админке/ условно все типы можно разделить на работу со словами (в фигме это желтые), с предложениями (коричневые), с диалогами (фиолетовые), с паззлами(розовые), и ривалка иероглифов'
# 3 типа заданий. формируются при создании соответствующего элеметна. 2 запускаются при "повторе с носителями" (слова, грамматика) и при запуске "рисовалки"(иероглиф). рисовалку можно запустить "при прохождении" уроков.
# 2 типа на "повторение" слов / 4 доп. типа на "повтор сложного".


drop table if exists task;
create table task
(
    id               serial primary key,
    lesson_id        bigint unsigned,
    task_type_id     bigint unsigned not null,
    creator_admin_id bigint unsigned,
    created_at       datetime default now(),
    updator_admin_id bigint unsigned,
    updated_at       datetime on update now(),
    elements         json comment 'списки по ключам:
"words_id": [], "grammar_id": [], "character_id": [] - используемые слова/грамматика/иероглифы,
"words_id_active_or_to_del": [] - слова, у которых при прохождении этого задания срабатывает счетчик "правильно"
"words_id_to_display": [] - слова, которые должны отображаться при показе задания пользователю,
"words_id_wrong": [] - неправильные слова',
    right_sentences  json comment 'списки с правильными предложениями:
"sent_char_A": [] - предлоежние на китайском,
"sent_pinyin_A": [] - предложение на pinyin,
"sent_lang_A": [] - или предложение на русском (которое используется для выбора среди правильных/неправильных
предложений и потом полностью отображается во всплывающем окне правильного ответа) ,
или это список элементов пазла которые используются для выбора среди правильных/неправильных элементов пазла и потом
будут отображаться во всплывающем окне правильного ответа. Например sent_lang_A": [{"я": 1}, {"-": 0}, {"Чжан Вэй": 1}, {".": 0}]
будет означать, что пользователь будет собирать предложение из пазлов "я" и "Чжан Вэй" и еще других неправильных,
а во всплывающем окне правильного ответа будет отображаться польностью "Я - Чжан Вэй." ,
"sent_lit_A": [] - предолжение на русском дословно
"sent_char_B": [], "sent_pinyin_B": [], "sent_lang_B": [], "sent_lit_B": [] - все то же самое, используются в случае если задания с диалогами (это вторые реплики)'
,
    wrong_sentences  json comment 'смысл как в right_sentences, только это списки с неправильными вариантами предложений',
    media            json comment ' списки с media_id файлов
"sent_images_id": [] - картинки вариантов ответа предложений,
"sent_images_id_right": [] картинка правильного варианта ответа,
"sent_video_id": [] видео, "sent_audio_A_id": [] аудио, "sent_audio_B_id": [] аудио второй реплики(если есть)
',
    constraint lesson_id_fk foreign key (lesson_id) references lesson (id) on delete set null on update cascade,
    constraint task_type_id_fk foreign key (task_type_id) references task_type (id) on delete cascade on update cascade,
    constraint task_creator_admin_id_fk foreign key (creator_admin_id) references admin (id) on delete set null on update cascade
) comment 'задание в уроке';


drop table if exists word;
create table word
(
    id             serial primary key,
    topic_id       bigint unsigned,
    `char`         varchar(50),
    pinyin         varchar(50),
    lang           varchar(50),
    lit            varchar(50),
    image_media_id bigint unsigned,
    audio_media_id bigint unsigned,
    index word_char_ind (`char`),
    index word_pinyin_ind (pinyin),
    index word_lang_ind (lang),
    index word_lit_ind (lit),
    constraint word_topic_id foreign key (topic_id) references topic (id),
    constraint word_image_media_id foreign key (image_media_id) references media (id),
    constraint word_audio_media_id foreign key (audio_media_id) references media (id)
);

drop table if exists grammar;
create table grammar
(
    id          serial primary key,
    topic_id    bigint unsigned,
    name        varchar(512) not null,
    explanation text(1000),
    `char`      varchar(512) not null,
    pinyin      varchar(512) not null,
    lang        varchar(512) not null,
    lit         varchar(512) not null,
    structure   varchar(512) not null,
    index grammar_name_ind (name),
    fulltext expl_ind (explanation),
    constraint grammar_topic_id foreign key (topic_id) references topic (id)
);


drop table if exists `character`;
create table `character`
(
    id             serial primary key,
    topic_id       bigint unsigned,
    `char`         varchar(50) not null,
    pinyin         varchar(50) not null,
    lang           varchar(50) not null,
    image_media_id bigint unsigned default null,
    audio_media_id bigint unsigned default null,
    char_anim      json        not null,
    index character_pinyin_ind (pinyin),
    index character_char_ind (`char`),
    index character_lang_ind (lang),
    constraint character_topic_id foreign key (topic_id) references topic (id),
    constraint character_image_media_id foreign key (image_media_id) references media (id),
    constraint character_audio_media_id foreign key (audio_media_id) references media (id)
);

drop table if exists user;
create table user
(
    id            serial primary key,
    name          varchar(50)  not null,
    email         varchar(50)  not null unique,
    password_hash varchar(255) not null,
    phone         bigint unsigned unique default null,
    age           bigint unsigned        default null,
    registered_at datetime               default now(),
    updated_at    datetime on update now(),
    status        enum (
        'trial',
        'premium_1',
        'premium_6',
        'premium_12')          not null  default 'trial' comment 'по умолчанию у пользователя статус подписки trial, если по подписке - то может быть на месяц, пол года или на год',
    purchased_at  datetime,
    index user_name (name),
    index user_email (email),
    index user_status (status)
) comment 'пользователь (ученик) - использует web/mobile app';


drop table if exists user_progress_tasks;
create table user_progress_tasks
(
    user_id    bigint unsigned not null,
    task_id    bigint unsigned not null,
    is_checked bit      default 0,
    checked_at datetime default null on update now(),
    primary key (user_id, task_id),
    constraint user_progress_task_user_id_fk foreign key (user_id) references user (id) on delete cascade on update cascade,
    constraint user_progress_task_task_id_fk foreign key (task_id) references task (id) on delete no action on update cascade
);


drop table if exists mnemonic_stage;
create table mnemonic_stage
(
    id                  serial primary key,
    hours_before_repeat INT unsigned not null
);

drop table if exists user_progress_words;
create table user_progress_words
(
    user_id           bigint unsigned not null,
    word_id           bigint unsigned not null,
    checked_at        datetime                 default null on update now(),
    mnemonic_stage_id bigint unsigned not null default 1,
    expire_at         datetime                 default null,
    count_right       INT unsigned             default 0 comment 'счетчик правльных ответов',
    count_wrong       INT unsigned             default 0 comment 'счетчик неправильных ответов',
    primary key (user_id, word_id),
    constraint upw_mnemonic_stage_fk foreign key (mnemonic_stage_id) references mnemonic_stage (id) on delete no action on update cascade,
    constraint upw_user_id foreign key (user_id) references user (id) on delete cascade on update cascade,
    constraint upw_word_id foreign key (word_id) references word (id) on delete cascade on update cascade

) comment 'сначала у всех элементов счетчик правильных ответов (count_right=0) и все элементы находятся на первой
ступени "мнемонической лесенки", после того как элемент проходится впервые в задании - count_right = 1,
и expire_at = now() + mnemonic_stages.hourse_before_repeat первой ступени, после того как настает expire_at -
элемент попадает в "пул повторения". после прохождениея упражнения "на повторение" элемента из пула повторения - у
элемента увеличивается count_right + 1 и checked_times + 1, а expire_at становится равным
now() + mnemonic_stages.hourse_before_repeat второй ступени ';



drop table if exists user_progress_grammars;
create table user_progress_grammars
(
    user_id           bigint unsigned not null,
    grammar_id        bigint unsigned not null,
    checked_at        datetime                 default null on update now(),
    mnemonic_stage_id bigint unsigned not null default 1,
    expire_at         datetime                 default null,
    count_right       INT unsigned             default 0,
    count_wrong       INT unsigned             default 0,
    primary key (user_id, grammar_id),
    constraint upg_mnemonic_stage_id foreign key (mnemonic_stage_id) references mnemonic_stage (id) on delete no action on update cascade,
    constraint upg_user_id foreign key (user_id) references user (id) on delete cascade on update cascade,
    constraint upg_grammar_id foreign key (grammar_id) references grammar (id) on delete cascade on update cascade
);

drop table if exists user_progress_characters;
create table user_progress_characters
(
    user_id           bigint unsigned,
    character_id      bigint unsigned,
    checked_at        datetime        default null on update now(),
    mnemonic_stage_id bigint unsigned default 1,
    expire_at         datetime        default null,
    count_right       INT unsigned    default 0,
    count_wrong       INT unsigned    default 0,
    primary key (user_id, character_id),
    constraint upc_mnemonic_stage_id foreign key (mnemonic_stage_id) references mnemonic_stage (id) on delete no action on update cascade,
    constraint upc_user_id foreign key (user_id) references user (id) on delete cascade on update cascade,
    constraint upc_character_id foreign key (character_id) references `character` (id) on delete cascade on update cascade
);

drop table if exists messages;
create table messages
(
    id         serial primary key,
    type       enum ('user_admin', 'admin_user') comment 'направление а)пользователь-админ, б) админ-пользователь.',
    from_id    bigint unsigned,
    to_id      bigint unsigned,
    theme      varchar(512) not null,
    body       text,
    file       MEDIUMBLOB,
    is_checked bit      default 0,
    created_at datetime default now(),
    constraint messages_from_admins foreign key (from_id) references admin (id) on delete set null on update cascade,
    constraint messages_to_admins foreign key (to_id) references admin (id) on delete set null on update cascade,
    constraint messages_from_user foreign key (from_id) references user (id) on delete set null on update cascade,
    constraint messages_to_user foreign key (to_id) references user (id) on delete set null on update cascade

) comment 'обратная связь с пользователями или тех поддержка, отправитель и получатель могут быть как user_id, так и admin_id, в зависимости от типа. пользователи друг другу не отправляют, ';

drop table if exists users_settings;
create table users_settings
(
    id                        serial primary key,
    user_id                   bigint unsigned not null,
    current_language_id       bigint unsigned                                                  default 1,
    text_size                 enum ('15','18','22')                                            default '18',
    chinese_display_type      enum ('only_characters', 'only_pinyin', 'characters_and_pinyin') default 'characters_and_pinyin',
    audio_speed               enum ('0.6', '1.0', '1.5')                                       default '1.0',
    audio_effects_are_on      bit                                                              default 1,
    audition_lessons_are_on   bit                                                              default 1,
    characters_lessons_are_on bit                                                              default 1,
    speaking_lessons_are_on   bit                                                              default 1,
    reminders_are_on          bit                                                              default 1,
    constraint user_settings_user_id foreign key (user_id) references user (id) on delete no action on update cascade
);

drop table if exists users_daily_goals;
create table users_daily_goals
(
    id              serial primary key,
    user_id         bigint unsigned  not null,
    daily_goal      tinyint unsigned not null default 50,
    goal_is_reached bit                       default 0,
    goal_date       datetime                  default now(),
    strike_qty      bigint unsigned  not null comment 'страйк - количетсво достигший цель дней подряд - 1. например, если пользователь 2 дня подряд достигает свою ежедневную цель по баллам - у него 1 страйк, если 3 дня подряд - 2 страйка',
    constraint users_daily_goals_user_id foreign key (user_id) references user (id)

) comment 'пользователь выставляет ежедневную цель по баллам, набирает их в зависимости от количества срабатываний счетчика count_right в элементах';
