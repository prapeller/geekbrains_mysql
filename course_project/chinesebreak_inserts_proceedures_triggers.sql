use chinesebreak;

# заведем 3 админа, один супер и два менеджера
insert into admin (first_name, last_name, email, password_hash, phone, status)
values ('admin1', 'adminov1', 'ololo@gmail.com', 'alaululuakakasdfsdfsdfkaukauka123', 89230030303, 'super')
     , ('admin2', 'adminov2', 'pishpish@gmail.com', 'uuuuuuuuuuksdfsdulele323jbk2jb', 89250255353, 'manager')
     , ('admin3', 'adminov3', 'realne@gmail.com', 'rambaharamambarusdfsdfm1231231', 89330330303, 'manager')
;

# изначально приложение только для русскоговорящих
insert into language (name, creator_admin_id, is_published)
values ('russian', 1, 0)
;

# если публикуем язык, то фиксируем дату публикации
drop trigger if exists publish_language;
create trigger publish_language
    before update
    on language
    for each row
begin
    if old.is_published = 0 and new.is_published = 1 then
        set new.published_at = now();
    end if;
end;

update language
set updator_admin_id = 1,
    is_published     = 1
where name = 'russian';

# заливаем тестовые файлы, которые будут использоваться для первых трех топиков.

# триггер для проверки типа файла по имени
drop trigger if exists determine_type;
create trigger determine_type
    before insert
    on media
    for each row
begin
    if new.name like '%.png' or new.name like '%.jpg' then
        set new.type = 'picture';
    elseif new.name like '%.mp3' or new.name like '%.wav' then
        set new.type = 'audio';
    elseif new.name like '%.mp4' or new.name like '%.m4v' then
        set new.type = 'video';
    elseif new.name like '%.svg' then
        set new.type = 'vector';
    elseif new.name like '%.gif' then
        set new.type = 'gif';
    end if;
end;

insert into media (id, name, file_path)
values (1, 'nǐhǎo.png', 'https://...')
     , (2, 'nǐhǎo.mp3', 'https://...')
     , (3, 'zàijiàn.png', 'https://...')
     , (4, 'zàijiàn.mp3', 'https://...')
     , (5, 'nǐ.png', 'https://...')
     , (6, 'nǐ.mp3', 'https://...')
     , (7, 'wǒ.png', 'https://...')
     , (8, 'wǒ.mp3', 'https://...')
     , (9, 'shì.png', 'https://...')
     , (10, 'shì.mp3', 'https://...')
     , (11, 'zhōngguó.png', 'https://...')
     , (12, 'zhōngguó.mp3', 'https://...')
     , (13, 'éguó.png', 'https://...')
     , (14, 'éguó.mp3', 'https://...')
     , (15, 'tā.png', 'https://...')
     , (16, 'tā.mp3', 'https://...')
     , (17, 'rén.png', 'https://...')
     , (18, 'rén.mp3', 'https://...')
     , (19, 'bù.png', 'https://...')
     , (20, 'bù.mp3', 'https://...')
     , (21, 'ma.png', 'https://...')
     , (22, 'ma.mp3', 'https://...')
     , (23, 'tā2.png', 'https://...')
     , (24, 'tā2.mp3', 'https://...')
     , (25, 'éyǔ.png', 'https://...')
     , (26, 'éyǔ.mp3', 'https://...')
     , (27, 'hànyǔ.png', 'https://...')
     , (28, 'hànyǔ.mp3', 'https://...')
     , (29, 'yīngyǔ.png', 'https://...')
     , (30, 'yīngyǔ.mp3', 'https://...')
     , (31, 'men.png', 'https://...')
     , (32, 'men.mp3', 'https://...')
     , (33, 'shuō.png', 'https://...')
     , (34, 'shuō.mp3', 'https://...')
     , (35, 'dōu.png', 'https://...')
     , (36, 'dōu.mp3', 'https://...')
     , (37, 'xué.png', 'https://...')
     , (38, 'xué.mp3', 'https://...')
     , (39, 'xiě.png', 'https://...')
     , (40, 'xiě.mp3', 'https://...')
     , (41, 'yě.png', 'https://...')
     , (42, 'yě.mp3', 'https://...')
     , (43, 'hànzi.png', 'https://...')
     , (44, 'hànzi.mp3', 'https://...')
     , (45, 'píngguǒ.png', 'https://...')
     , (46, 'píngguǒ.mp3', 'https://...')
     , (47, 'xīguā.png', 'https://...')
     , (48, 'xīguā.mp3', 'https://...')
     , (49, 'mángguǒ.png', 'https://...')
     , (50, 'mángguǒ.mp3', 'https://...')
     , (51, 'bōluó.png', 'https://...')
     , (52, 'bōluó.mp3', 'https://...')
     , (53, 'chī.png', 'https://...')
     , (54, 'chī.mp3', 'https://...')
     , (55, 'hé.png', 'https://...')
     , (56, 'hé.mp3', 'https://...')
     , (57, 'miànbāo.png', 'https://...')
     , (58, 'miànbāo.mp3', 'https://...')
     , (59, 'jīdàn.png', 'https://...')
     , (60, 'jīdàn.mp3', 'https://...')
     , (61, 'bǐnggān.png', 'https://...')
     , (62, 'bǐnggān.mp3', 'https://...')
     , (63, 'shuǐguǒ.png', 'https://...')
     , (64, 'shuǐguǒ.mp3', 'https://...')
     , (65, 'xǐhuān.png', 'https://...')
     , (66, 'xǐhuān.mp3', 'https://...')
     , (67, 'kāfēi.png', 'https://...')
     , (68, 'kāfēi.mp3', 'https://...')
     , (69, 'chá.png', 'https://...')
     , (70, 'chá.mp3', 'https://...')
     , (71, 'hē.png', 'https://...')
     , (72, 'hē.mp3', 'https://...')
     , (73, 'guǒzhī.png', 'https://...')
     , (74, 'guǒzhī.mp3', 'https://...')
     , (75, 'shuǐ.png', 'https://...')
     , (76, 'shuǐ.mp3', 'https://...')
     , (77, 'niúnǎi.png', 'https://...')
     , (78, 'niúnǎi.mp3', 'https://...')
     , (79, 'píjiǔ.png', 'https://...')
     , (80, 'píjiǔ.mp3', 'https://...')
     , (81, 'kělè.png', 'https://...')
     , (82, 'kělè.mp3', 'https://...')
     , (83, 'xiǎng.png', 'https://...')
     , (84, 'xiǎng.mp3', 'https://...')
     , (85, 'mǎi.png', 'https://...')
     , (86, 'mǎi.mp3', 'https://...')
     , (87, 'hǎo.png', 'https://...')
     , (88, 'hǎo.mp3', 'https://...')
     , (89, 'rén.png', 'https://...')
     , (90, 'rén.mp3', 'https://...')
     , (91, 'zhōng.png', 'https://...')
     , (92, 'zhōng.mp3', 'https://...')
     , (93, 'yǔ.png', 'https://...')
     , (94, 'yǔ.mp3', 'https://...')
     , (95, 'xué.png', 'https://...')
     , (96, 'xué.mp3', 'https://...')
     , (97, 'hàn.png', 'https://...')
     , (98, 'hàn.mp3', 'https://...')
     , (99, 'zì.png', 'https://...')
     , (100, 'zì.mp3', 'https://...')
     , (101, 'guā.png', 'https://...')
     , (102, 'guā.mp3', 'https://...')
     , (103, 'chī.png', 'https://...')
     , (104, 'chī.mp3', 'https://...')
     , (105, 'xǐ.png', 'https://...')
     , (106, 'xǐ.mp3', 'https://...')
     , (107, 'guǒ.png', 'https://...')
     , (108, 'guǒ.mp3', 'https://...')
     , (109, 'shuǐ.png', 'https://...')
     , (110, 'shuǐ.mp3', 'https://...')
     , (111, 'niú.png', 'https://...')
     , (112, 'niú.mp3', 'https://...')
     , (113, 'jiǔ.png', 'https://...')
     , (114, 'jiǔ.mp3', 'https://...')
     , (115, 'topicture_hello.svg', 'https://...')
     , (116, 'topicture_study_chinese.svg', 'https://...')
     , (117, 'topicture_food.svg', 'https://...')
     , (118, 'word_char_from_video_preview.mp4', 'https://...')
     , (119, 'you-are-not-russian.png', 'https://...')
     , (120, 'you-are-not-chinese.png', 'https://...')
     , (121, 'you-are-russian.png', 'https://...')
     , (122, 'you-are-chinese.png', 'https://...')
     , (123, 'zhāng wěi.mp3', 'https://...')
     , (124, 'nǐ bù shì éguó rén.mp3', 'https://...')
     , (125, 'nǐ shì zhāng wěi.mp3', 'https://...')
     , (126, 'yī.png', 'https://...')
     , (127, 'yī.mp3', 'https://...')
     , (128, 'kuài.png', 'https://...')
     , (129, 'kuài.mp3', 'https://...')
     , (130, 'píngguǒ yī kuài.mp3', 'https://...')
     , (131, 'nǐ shì zhāng wěi.mp4', 'https://...')
     , (132, 'tā men shuō hànyǔ.mp3', 'https://...')
     , (133, 'duōshǎo.png', 'https://...')
     , (134, 'duōshǎo.mp3', 'https://...')
     , (135, 'qián.png', 'https://...')
     , (136, 'qián.mp3', 'https://...')
     , (137, 'mángguǒ duōshǎo qián.mp3', 'https://...')
     , (138, 'tā shì zhōngguó rén ma.mp3', 'https://...')
     , (139, 'tā bù shì zhōngguó rén.mp3', 'https://...')
     , (140, 'tā shì éguó rén ma.mp4', 'https://...')
     , (141, 'tā shì éguó rén ma.mp3', 'https://...')
     , (142, 'tā shì éguó rén.mp3', 'https://...')
     , (143, 'nǐ hǎo wǒ shì zhāng wēi.mp3', 'https://...')
     , (144, 'wǒ shì zhāng wēi.mp3', 'https://...')
;


insert into course (language_id, name, creator_admin_id, is_published)
values (1, 'HSK-1', 1, 0);


# сделаем невозможность привязать к топику файл отличный от векторного.
drop trigger if exists check_topic_media_type;
create trigger check_topic_media_type
    before update
    on topic
    for each row
begin
    declare msg varchar(128);
    if (select m.type from media m where m.id = new.media_id) != 'vector' then
        set msg = concat('check_topic_media_type trigger error: trying to attach not a vector file to topic - ',
                         (select name from media where id = new.media_id));
        signal sqlstate '45000' set message_text = msg;
    end if;
end;

# админы создают топики
insert into topic (course_id, name, creator_admin_id)
values (1, 'Привет', 1)          -- должна быть media_id с векторной картинкой media.id = 115
     , (1, 'Учить китайский', 2) -- должна быть media_id с векторной картинкой media.id =  116)
     , (1, 'Еда', 3) -- должна быть media_id с векторной картинкой media.id =  117
;

# пробуют привязать невекторную картику к топику (выдаст ошибку)
# update topic
# set media_id = 1
# where name = 'Привет';

# пробуют привязать векторные картики к топикам (все ок)
update topic
set media_id = 115
where name = 'Привет';
update topic
set media_id = 116
where name = 'Учить китайский';
update topic
set media_id = 117
where name = 'Еда';

# создают 9 уроков, по 3 к каждому топику
insert into lesson (topic_id, creator_admin_id)
values (1, 2)
     , (1, 1)
     , (1, 3)
     , (2, 1)
     , (2, 1)
     , (2, 1)
     , (3, 2)
     , (3, 3)
     , (3, 1)
;

# задаем возможность админам наполнять строить программу из 22х типов заданий
insert into task_type
values (1, 'word_image'),
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


# перед тем как составлять задания для топиков (например, для первых 3 топиков) - админы вводят необходимые для первых 3х топиков слова
# но перед этим сделаем невозможность на этапе вставки нового слова привязать к слову:
# image_media_id файл отличный от типа picture,
# audio_media_id файл отличный от типа audio
drop trigger if exists check_word_media_type;
create trigger check_word_media_type
    before insert
    on word
    for each row
begin
    declare msg varchar(128);
    if (select type from media where id = new.image_media_id) != 'picture' then
        set msg = concat('check_word_media_type trigger error: trying to attach not a picture file to word - ',
                         (select name from media where id = new.image_media_id));
        signal sqlstate '45000' set message_text = msg;
    end if;
    if (select type from media where id = new.audio_media_id) != 'audio' then
        set msg = concat('check_word_media_type trigger error: trying to attach not an audio file to word - ',
                         (select name from media where id = new.audio_media_id));
        signal sqlstate '45000' set message_text = msg;
    end if;
end;

insert into word (topic_id, `char`, pinyin, lang, lit, image_media_id, audio_media_id)
values (1, '你好', 'nǐhǎo', 'привет', 'тебе добро', 1, 2)
     , (1, '再见', 'zàijiàn', 'пока; увидимся', 'снова увидеться', 3, 4)
     , (1, '你', 'nǐ', 'ты', null, 5, 6)
     , (1, '我', 'wǒ', 'я', null, 7, 8)
     , (1, '是', 'shì', 'быть; являться', null, 9, 10)
     , (1, '中国', 'zhōngguó', 'Китай', 'срединная страна', 11, 12)
     , (1, '俄国', 'éguó', 'Россия', 'русская страна', 13, 14)
     , (1, '他', 'tā', 'он', 'русская страна', 15, 16)
     , (1, '人', 'rén', 'человек', null, 17, 18)
     , (1, '不', 'bù', 'не', null, 19, 20)
     , (1, '吗', 'ma', 'вопросительная частица для вопросов "да/нет"', null, 21, 22)
     , (1, '她', 'tā', 'она', null, 23, 24)
     , (2, '俄语', 'éyǔ', 'русский язык', null, 25, 26)
     , (2, '汉语', 'hànyǔ', 'китайский язык', null, 27, 28)
     , (2, '英语', 'yīngyǔ', 'английский язык', null, 29, 30)
     , (2, '们', 'men', 'маркер множественного числа (людей)', null, 31, 32)
     , (2, '说', 'shuō', 'говорить', null, 33, 34)
     , (2, '都', 'dōu', 'все; всё; оба', null, 35, 36)
     , (2, '学', 'xué', 'учить(-ся)', null, 37, 38)
     , (2, '写', 'xiě', 'писать', null, 39, 40)
     , (2, '也', 'yě', 'также; тоже', null, 41, 42)
     , (2, '汉字', 'hànzi', 'китайский иероглиф', null, 43, 44)
     , (3, '苹果', 'píngguǒ', 'яблоко', 'яблоко фрукт', 45, 46)
     , (3, '西瓜', 'xīguā', 'арбуз', 'запад(ная) дыня', 47, 48)
     , (3, '芒果', 'mángguǒ', 'манго', null, 49, 50)
     , (3, '菠萝', 'bōluó', 'ананас', 'шпинат редька', 51, 52)
     , (3, '吃', 'chī', 'кушать', null, 53, 54)
     , (3, '和', 'hé', 'и; с', null, 55, 56)
     , (3, '面包', 'miànbāo', 'хлеб', 'мучная упаковочка', 57, 58)
     , (3, '鸡蛋', 'jīdàn', 'яйцо', 'куриное яйцо', 59, 60)
     , (3, '饼干', 'bǐnggān', 'печенье', 'пирог сухой', 61, 62)
     , (3, '水果', 'shuǐguǒ', 'фрукт', 'водный фрукт', 63, 64)
     , (3, '喜欢', 'xǐhuān', 'нравиться', 'любить нравиться', 65, 66)
     , (3, '咖啡', 'kāfēi', 'кофе', null, 67, 68)
     , (3, '茶', 'chá', 'чай', null, 69, 70)
     , (3, '喝', 'hē', 'пить', null, 71, 72)
     , (3, '果汁', 'guǒzhī', 'сок', 'фруктовый сок', 73, 74)
     , (3, '水', 'shuǐ', 'вода', null, 75, 76)
     , (3, '牛奶', 'niúnǎi', 'молоко', 'коровье молоко', 77, 78)
     , (3, '啤酒', 'píjiǔ', 'пиво', 'пивной алкоголь', 79, 80)
     , (3, '可乐', 'kělè', 'кола', null, 81, 82)
     , (3, '想', 'xiǎng', 'хотеть, скучать', null, 83, 84)
     , (3, '买', 'mǎi', 'покупать', null, 85, 86)
     , (1, '。', ' ', ' ', null, null, null)
     , (1, '？', ' ', ' ', null, null, null)
     , (1, '张伟', 'zhāng wěi', 'Чжан Вэй', null, null, 123)
     , (1, '，', ' ', ' ', null, null, null)
     , (3, '一', 'yī', 'один', null, 126, 127)
     , (3, '块', 'kuài', 'блок, кусок', null, 128, 129)
     , (3, '多少', 'duōshǎo', 'сколько', 'много мало', 133, 134)
     , (3, '钱', 'qián', 'деньги', null, 135, 136)
;

# также вводят необходимые для первых 3х топиков иероглифы
# но перед этим сделаем невозможность на этапе вставки нового иероглифа привязать к нему:
# image_media_id файл отличный от типа picture,
# audio_media_id файл отличный от типа audio
drop trigger if exists check_character_media_type;
create trigger check_character_media_type
    before insert
    on `character`
    for each row
begin
    declare msg varchar(128);

    if (select type from media where id = new.image_media_id) != 'picture' then
        set msg = concat('check_word_media_type trigger error: trying to attach not a picture file to word - ',
                         (select name from media where id = new.image_media_id));
        signal sqlstate '45000' set message_text = msg;
    end if;


    if (select type from media where id = new.audio_media_id) != 'audio' then
        set msg = concat('check_word_media_type trigger error: trying to attach not an audio file to word - ',
                         (select name from media where id = new.audio_media_id));
        signal sqlstate '45000' set message_text = msg;
    end if;

    # также хотел сделать, чтоб в char_anim состоял только из файлов с типом vector или gif
# но эту часть тригера пришлось закоментить, так как он начал потом "то работать\то не работать".
# я так понимаю в mysql работа с json еще какаято сырая чтоли, хз... причину написал ниже

#     set @new_anim_set = (select new.char_anim -> "$.char_anim_set" from `character`);

#     if exists(select type
#               from (select *
#                     from json_table(
#                                  @new_anim_set,
#                                  '$[*]'
#                                  columns (
#                                      id for ordinality,
#                                      `anim_set` INT path "$")
#                              ) as jt) jst
#                        join media on jst.anim_set = media.id
#               where type != 'vector'
#                 and type != 'gif')
#     then
#         set msg = 'check_character_media_type trigger error: trying to attach not an vector or gif file to `char_anim`';
#         signal sqlstate '45000' set message_text = msg;
#     end if;
end;


# если вставить в char_anim_set например один невекторный файл c media_id (118), то выдаст заданную в тригере ошибку..
# но если сделать так еще раз, то ошибка почему то становится "[21000][1242] subquery returns more than 1 row"
# после этого валится mysql server, и приходится после этого его перезапускать... так что все это закоментил,
# и поэтому и часть тригера с этой проверкой тож закоментил...

# insert into `character` (topic_id, `char`, pinyin, lang, image_media_id, audio_media_id, char_anim)
# values (1, '好', 'hǎo', 'хорошо; добро; отлично', 87, 88, '{
#   "char_anim_set": [
#     115,
#     116,
#     118
#   ]
# }');

insert into `character` (topic_id, `char`, pinyin, lang, image_media_id, audio_media_id, char_anim)
values (1, '好', 'hǎo', 'хорошо; добро; отлично', 87, 88, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (1, '人', 'rén', 'человек', 89, 90, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (1, '中', 'zhōng', 'центр; середина; Китай', 91, 92, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (2, '语', 'yǔ', 'язык', 93, 94, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (2, '学', 'xué', 'учиться', 95, 96, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (2, '汉', 'hàn', 'китайский (язык); этническая группа Хань', 97, 98, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (2, '字', 'zì', 'слово', 99, 100, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '瓜', 'guā', 'дыня', 101, 102, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '吃', 'chī', 'кушать', 103, 104, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '喜', 'xǐ', 'нравиться', 105, 106, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '果', 'guǒ', 'фрукт; результат', 107, 108, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '水', 'shuǐ', 'вода', 109, 110, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '牛', 'niú', 'корова, крупный рогатый скот', 111, 112, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
     , (3, '酒', 'jiǔ', 'алкоголь', 113, 114, '{
  "char_anim_set": [
    115,
    116,
    117
  ]
}')
;

# также админы например вводят необходимые для первых трех топиков грамматики
insert into grammar (topic_id, name, explanation, `char`, pinyin, lang, lit, structure)
values (1, 'Личные местоимения',
        'Личные местоимения не склоняются:
        我 (wǒ) я = мне\n你 (nǐ) ты = тебе\n他 (tā) он = ему\n她 (tā) она = ей',
        '我是张伟。',
        'wǒ shì zhāng wēi',
        'Я - Чжан Вэй.',
        'я есть Чжан Вэй',
        'Я = мне / ты = тебе / он = ему / она = ей')

     , (1, '"Быть, являться" с помощью 是 (shì)',
        '是 (shì) - аналог "быть, являться" в английском языке.',
        '你是张伟。',
        'nǐ shì zhāng wěi',
        'Ты - Чжан Вэй.',
        'ты есть Чжан Вэй',
        'Кто/что + 是 + Кто/что2')

     , (1, 'Отрицание с помощью 不 (bù)',
        '不 (bù) - отрицательная частица. Ставится перед отрицаемым.',
        '他不是中国人。',
        'tā bù shì zhōngguó rén',
        'Он не китаец.',
        'он не есть срединная страна человек',
        'Кто/что + 不 + Что делать + Кого/чего')

     , (1, 'Простой вопрос "да/нет?" с помощью вопросительной частицы 吗 (ma)',
        '吗 (ma) - вопросительная частица, которая ставится в конце простого вопроса "да/нет?".',
        '你是俄国人吗？',
        'nǐ shì éguó rén ma',
        'Ты русский?',
        'ты есть русская страна человек MA?',
        'Кто/что + Что делать + Кого/чего + 吗?')

     , (2, 'Множественное число с помощью 们 (men)',
        '们 (men) - маркер множественного числа (людей).',
        '我们说俄语。',
        'wǒ men shuō éyǔ',
        'Мы говорим по-русски.',
        'мы говорим русский язык',
        '"我 (wǒ) - я, 我们 (wǒmen) - мы. 你 (nǐ) - ты, 你们 (nǐmen) - вы."')

     , (2, 'Обобщение с 都 (dōu)',
        '都 (dōu) - все; всё; оба.',
        '我们都说俄语。',
        'wǒ men dōu shuō éyǔ',
        'Мы все говорим по-русски.',
        'мы все говорим русский язык',
        'Кто/что + 都 + Что делать + Кого/чего.')

     , (2, 'Тоже (также) с помощью 也 (yě)',
        '也 (yě) - тоже, также.',
        '她也写汉字。',
        'tā yě xiě hànzì',
        'Она тоже пишет китайские иероглифы.',
        'она тоже пишет китайский иероглиф',
        'Кто/что + 也 + Что делать + Кого/чего.')

     , (3, 'Перечисление с помощью 和 (hé)',
        '和 (hé) - и; а также; с.',
        '她吃苹果和西瓜。',
        'tā chī píngguǒ hé xīguā',
        'Она ест яблоки и арбузы.',
        'она ест яблоки с арбузом',
        'Кого/чего1 + 和 + Кого/чего2.')

     , (3, '"Нравиться" с помощью 喜欢 (xǐhuān)',
        '喜欢 (xǐhuān) - любить, нравиться.',
        '我喜欢饼干。',
        'wǒ xǐhuān bǐnggān',
        'Я люблю печенье.',
        'мне нравится печенье',
        'Кто/что + 喜欢 + Что делать + Кого/чего.')

     , (3, '"Хотеть" с помощью 想 (xiǎng)',
        '想 (xiǎng) - хотеть сделать что-то.',
        '我想买可乐。',
        'wǒ xiǎng mǎi kělè',
        'Я хочу купить колу.',
        'я хочу колу',
        'Кто/что + 想 + Что делать + Кого/чего.')

     , (3, 'Выражение цены с помощью 块 (kuài)',
        'При обозначении цены не нужны дополнительные глаголы. 块 (kuài) - обычное обозначение Юаня в китайской устной речи.',
        '苹果一块。',
        'píngguǒ yī kuài',
        'Яблоко стоит 1 юань.',
        'яблоко 1 юань',
        'Кто/что + Сколько + 块')

     , (3, '"Сколько стоит?" с помощью 多少钱 (duōshǎo qián)',
        '多少 (duōshǎo) - сколько? 钱 (qián) - деньги.',
        '可乐多少钱？',
        'kělè duōshǎo qián',
        'Сколько стоит кола?',
        'кола сколько денег?',
        'Кто/что + 多少钱？')
;


# пусть админы для примера заполнили уроки в первых трех топиках по одному на каждый вид задания

# (то есть по сути пройдя их все, пользователь пройдет не все существующие элементы (ну все таки это просто для демонстрации вручную написанная база)
insert into task (lesson_id, task_type_id, creator_admin_id, created_at, updator_admin_id, updated_at,
                  elements,
                  right_sentences,
                  wrong_sentences,
                  media)
values

# formatter:off
#     (1, 'word_image')
    (1, 1, 1, default, 1, default
    ,'{"words_id": [1, 2, 3, 4], "words_id_active_or_to_del": [1]}'
    , null
    , null
    , null)
    ,

#     (2, 'word_char_from_lang')
    (1, 2, 1, default, 1, default
    ,'{"words_id": [6, 7, 8, 9], "words_id_active_or_to_del": [7]}'
    , null
    , null
    , null)
    ,

#     (3, 'word_lang_from_char')
    (2, 3, 1, default, 1, default
    ,'{"words_id": [7, 8, 9, 10], "words_id_active_or_to_del": [10]}'
    , null
    , null
    , null)
    ,

#     (4, 'word_char_from_video')
    (2, 4, 1, default, 1, default
    ,'{"words_id": [1, 2, 3, 4], "words_id_active_or_to_del": [4]}'
    , null
    , null
    ,'{"video_id": [118]}')
    ,

#     (5, 'word_match')
    (3, 5, 1, default, 1, default
    ,'{"words_id": [13, 14, 15, 16, 17], "words_id_active_or_to_del": [13, 14, 15, 16, 17], "words_id_to_display": []}'
    , null
    , null
    , null)
    ,
#     (6, 'sent_image')
#        你不是俄国人。 nǐ bù shì éguó rén
    (3, 6, 1, default, 1, default
    ,'{"words_id": [3, 10, 5, 7, 9, 45], "grammar_id_active": [3], "words_id_active_or_to_del": [10, 5]}'
    ,'{"sent_lang_A": ["Ты не русский."], "sent_lit_A": ["ты не есть русская страна человек"]}'
    , null
    ,'{"sent_images_id": [119, 120, 121, 122], "sent_images_id_right": [119], "sent_audio_A_id": [124]}')
    ,

#     (7, 'sent_char_from_lang')
#        你是张伟。 nǐ shì zhāng wěi
    (4, 7, 1, default, 1, default
    ,'{"words_id": [1, 5, 47, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [1, 5]}'
    ,'{"sent_lang_A": ["Ты - Чжан Вэй."], "sent_lit_A": ["ты есть Чжан Вэй"]}'
    ,'{"sent_char": ["我是张伟。", "你好，张伟。", "再见，张伟。"], "sent_pinyin": ["wǒ shì zhāng wēi", "nǐ hǎo zhāng wěi", "zàijiàn zhāng wěi"]}'
    ,'{"sent_audio_A_id": [125]}')
    ,

    #     (8, 'sent_lang_from_char')
#        苹果一块。 píngguǒ yī kuài
    (4, 8, 1, default, 1, default
    ,'{"words_id": [23, 48, 49, 44], "grammar_id_active": [11], "words_id_active_or_to_del": [23, 44]}'
    ,'{"sent_lang_A": ["Яблоко стоит 1 юань."], "sent_lit_A": ["яблоко 1 юань"]}'
    ,'{"sent_lang": ["1 яблоко.", "2 яблока.", "Яблоко стоит 2 юаня."]}'
    ,'{"sent_audio_A_id": [130]}')
    ,

    #     (9, 'sent_lang_from_video')
#        你是张伟。 nǐ shì zhāng wěi
    (5, 9, 1, default, 1, default
    ,'{"words_id": [1, 5, 47, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [1, 5]}'
    ,'{"sent_lang_A": ["Ты - Чжан Вэй."], "sent_lit_A": ["ты есть Чжан Вэй"]}'
    ,'{"sent_lang": ["Я - Чжан Вэй.", "Привет, Чжан Вэй!"]}'
    ,'{"sent_video_id": [131]}')
    ,

    #     (10, 'sent_say_from_char')
#        苹果一块。 píngguǒ yī kuài
    (5, 10, 1, default, 1, default
    ,'{"words_id": [23, 48, 49, 44], "grammar_id_active": [11], "words_id_active_or_to_del": [23], "words_id_to_display": [23, 48, 49]}'
    ,'{"sent_lang_A": ["Яблоко стоит 1 юань."], "sent_lit_A": ["яблоко 1 юань"]}'
    , null
    ,'{"sent_audio_A_id": [130]}')
    ,

    #     (11, 'sent_say_from_video')
#        你是张伟。 nǐ shì zhāng wěi
    (6, 11, 1, default, 1, default
    ,'{"words_id": [1, 5, 47, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [1, 5], "words_id_to_display": [1, 5, 47]}'
    ,'{"sent_lang_A": ["Ты - Чжан Вэй."], "sent_lit_A": ["ты есть Чжан Вэй"]}'
    , null
    ,'{"sent_video_id": [131], "sent_audio_A_id": [125]}')
    ,

    #     (12, 'sent_paste_from_char')
#        他们说汉语。 tā men shuō hànyǔ
    (6, 12, 1, default, 1, default
    ,'{"words_id": [8, 16, 17, 14, 44], "grammar_id_active": [5], "words_id_active_or_to_del": [16], "words_id_to_display": [8, 16, 17, 14]}'
    ,'{"sent_lang_A": ["Они говорят по китайски."], "sent_lit_A": ["они говорят китайский язык"]}'
    , null
    ,'{"sent_audio_A_id": [132]}')
    ,

    #     (13, 'sent_choose_from_char')
#       他们说汉语。 tā men shuō hànyǔ
    (7, 13, 1, default, 1, default
    ,'{"words_id": [8, 16, 17, 14, 44], "grammar_id_active": [5], "words_id_active_or_to_del": [2], "words_id_to_display": [8, 16, 17, 14, 44], "words_id_wrong": [1, 2, 3]}'
    ,'{"sent_lang_A": ["Они говорят по китайски."], "sent_lit_A": ["они говорят китайский язык"]}'
    , null
    ,'{"sent_audio_A_id": [132]}')
    ,

    #     (14, 'sent_delete_from_char')
#        芒果多少钱？ mángguǒ duōshǎo qián
    (7, 14, 1, default, 1, default
    ,'{"words_id": [25, 50, 51, 11, 45], "grammar_id_active": [12], "words_id_active_or_to_del": [25, 50, 51, 11], "words_id_to_display": [25, 50, 51, 11], "words_id_wrong": [11]}'
    ,'{"sent_lang_A": ["Сколько стоит манго?"], "sent_lit_A": ["манго сколько денег?"]}'
    , null
    ,'{"sent_audio_A_id": [137]}')
    ,

    #     (15, 'dialog_A_char_from_char')
#        她是中国人吗？ tā shì zhōngguó rén ma <---
#        她不是中国人。 tā bù shì zhōngguó rén
    (8, 15, 1, default, 1, default
    ,'{"words_id": [12, 5, 6, 9, 11, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [12, 5]}'
    ,'{"sent_lang_A": ["Она китаянка?"], "sent_lit_A": ["она есть срединная страна человек MA?"], "sent_char_B": ["她不是中国人。"], "sent_pinyin_B": ["tā bù shì zhōngguó rén"], "sent_lang_B": ["Она не китаянка."], "sent_lit_B": ["она не есть срединная страна человек"]}'
    ,'{"sent_char": ["她是俄国人吗？", "你是中国人吗？", "你是俄国人吗？"], "sent_pinyin": ["tā shì éguó rén ma", "nǐ shì zhōngguó rén ma", "nǐ shì éguó rén ma"]}'
    ,'{"sent_audio_A_id": [138], "sent_audio_B_id": [139]}')
    ,

#     (16, 'dialog_B_char_from_video')
#       她是俄国人吗？ tā shì éguó rén ma
#       她是俄国人。  tā shì éguó rén     <---
    (8, 16, 1, default, 1, default
    ,'{"words_id": [12, 5, 7, 9, 44], "grammar_id_active": [2], "words_id_active_or_to_del": [12, 5]}'
    ,'{"sent_char_A": ["她是俄国人吗？"], "sent_pinyin_A": ["tā shì éguó rén ma"], "sent_lang_A": ["Она русская?"], "sent_lit_A": ["она есть русская страна человек MA?"], "sent_lang_B": ["Она русская."], "sent_lit_B": ["она есть русская страна человек"]}'
    ,'{"sent_char": ["我是俄国人。", "你是俄国人。"], "sent_pinyin": ["wǒ shì éguó rén", "nǐ shì éguó rén"]}'
    ,'{"sent_video_id": [140], "sent_audio_A_id": [141], "sent_audio_B_id": [142]}')
    ,

#     (17, 'dialog_A_puzzle_char_from_char')
#        她是中国人吗？ tā shì zhōngguó rén ma <---
#        她不是中国人。 tā bù shì zhōngguó rén
    (9, 17, 1, default, 1, default
    ,'{"words_id": [12, 5, 6, 9, 11, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [12, 5], "words_id_to_display": [12, 5, 6, 9, 11]}'
    ,'{"sent_lang_A": ["Она китаянка?"], "sent_lit_A": ["она есть срединная страна человек MA?"], "sent_char_B": ["她不是中国人。"], "sent_pinyin_B": ["tā bù shì zhōngguó rén"], "sent_lang_B": ["Она не китаянка."], "sent_lit_B": ["она не есть срединная страна человек"]}'
    , null
    ,'{"sent_audio_A_id": [138], "sent_audio_B_id": [139]}')
    ,

#     (18, 'dialog_B_puzzle_char_from_char')
#       她是俄国人吗？ tā shì éguó rén ma
#       她是俄国人。  tā shì éguó rén     <---
    (9, 18, 1, default, 1, default
    ,'{"words_id": [12, 5, 7, 9, 44], "grammar_id_active": [2], "words_id_active_or_to_del": [12, 5], "words_id_to_display": [12, 5, 7, 9]}'
    ,'{"sent_char_A": ["她是俄国人吗？"], "sent_pinyin_A": ["tā shì éguó rén ma"], "sent_lang_A": ["Она русская?"], "sent_lit_A": ["она есть русская страна человек MA?"], "sent_lang_B": ["Она русская."], "sent_lit_B": ["она есть русская страна человек"]}'
    , null
    ,'{"sent_audio_A_id": [141], "sent_audio_B_id": [142]}')
    ,

#     (19, 'puzzle_char_from_lang')
#      你好，我是张伟。 nǐ hǎo wǒ shì zhāng wēi
    (9, 19, 1, default, 1, default
    ,'{"words_id": [1, 47, 4, 5, 46, 44], "grammar_id_active": [2], "words_id_active_or_to_del": [1, 5], "words_id_to_display": [1, 4, 5, 46], "words_id_wrong": [10, 2, 3]}'
    ,'{"sent_lang_A": ["Привет, я - Чжан Вэй."], "sent_lit_A": ["тебе добро я есть Чжан Вэй"]}'
    , null
    ,'{"sent_audio_A_id": [143]}')
    ,

#     (20, 'puzzle_lang_from_char')
#       我是张伟。 wǒ shì zhāng wēi \ я - Чжан Вэй.
    (9, 20, 1, default, 1, default
    ,'{"words_id": [4, 5, 46, 44], "grammar_id_active": [1, 2], "words_id_active_or_to_del": [4, 5]}'
    ,'{"sent_lang_A": [{"я": 1}, {"-": 0}, {"Чжан Вэй": 1}, {".": 0}], "sent_lit_A": ["я есть Чжан Вэй"]}'
    ,'{"sent_lang": ["не", "ты", "привет"]}'
    ,'{"sent_audio_A_id": [144]}')
    ,

#     (21, 'puzzle_char_from_video')
#        她是中国人吗？ tā shì zhōngguó rén ma
    (9, 21, 1, default, 1, default
    ,'{"words_id": [12, 5, 6, 9, 11, 45], "grammar_id_active": [2], "words_id_active_or_to_del": [12, 5], "words_id_to_display": [12, 5, 6, 9, 11], "words_id_wrong": [7, 8, 14]}'
    ,'{"sent_lang_A": ["Она китаянка?"], "sent_lit_A": ["она есть срединная страна человек MA?"]}'
    ,'{"sent_char": [], "sent_lang": [], "sent_pinyin": []}'
    ,'{"sent_video_id": [140], "sent_audio_A_id": [141]}')
    ,

#     (22, 'draw_character')
    (9, 22, 1, default, 1, default
    ,'{"character_id_active": [1]}'
    , null
    , null
    , null)
;
# formatter:on


# задаем что у пользователя при начале обучения все слова/грамматика/иероглифы встают на первую ступень и нет времени до попадания их в пул повторения
# а после первого прохождения элементы встают на вторую ступень, и попадут в пул повторения через 12 часов, после повторения - на третуую ступень и попадут в пул через 24 часа и т.д.
insert into mnemonic_stage (id, hours_before_repeat)
values (1, 0),
       (2, 12),
       (3, 24),
       (4, 96),
       (5, 336),
       (6, 720),
       (7, 1440),
       (8, 2880);


# далее идут -данные касаемые учебного прогресса пользователя

# когда регистрируется новый пользователь, user_progress_tasks заполняется нулевыми данными для каждого задания (о том что он не прошел ни одно задание)
drop trigger if exists insert_into_upt_on_new_user;
create trigger insert_into_upt_on_new_user
    after insert
    on user
    for each row

begin
    declare i bigint default 1;

    while i <= (select count(*) from task)
        do
            insert into user_progress_tasks(user_id, task_id) values (new.id, i);
            set i = i + 1;
        end while;

end;

# также когда регистрируется новый пользователь, таблицы user_progress_words, user_progress_character, user_progress_grammar заполняются нулевыми данными для каждого элемента (о том что он не прошел ни одного элемента)
drop trigger if exists insert_into_upelements_on_new_user;
create trigger insert_into_upelements_on_new_user
    after insert
    on user
    for each row

begin
    declare word_i bigint default 1;
    declare gram_i bigint default 1;
    declare char_i bigint default 1;

    while word_i <= (select count(*) from word)
        do
            insert into user_progress_words(user_id, word_id) values (new.id, word_i);
            set word_i = word_i + 1;
        end while;

    while gram_i <= (select count(*) from grammar)
        do
            insert into user_progress_grammars(user_id, grammar_id) values (new.id, gram_i);
            set gram_i = gram_i + 1;
        end while;

    while char_i <= (select count(*) from `character`)
        do
            insert into user_progress_characters(user_id, character_id) values (new.id, char_i);
            set char_i = char_i + 1;
        end while;

end;

# предположим регистрируются 3 пользователя
insert into user (name, email, password_hash, phone, age, registered_at, status, purchased_at)
values ('user1', 'ololo@gmail.com', 'olololololopishpishrealne123', 89235230612, 16, now(), default, default)
     , ('user2', 'pish-pish@gmail.com', 'ololololoopishpishrealne124', 89235230614, 16, now(), default, default)
     , ('user3', 'realne@gmail.com', 'oloollololopishpishrealne124', 89235230613, 80, now(), 'premium_6', now())
;

# -- можно проверить как каскадно изменяются значения user_id в таблицах user_progress... из-за удаления пользователей или обновления их user.id
# update user
# set id = 4
# where id = 2;
# delete
# from user
# where name = 'user1';
#
# insert into user (name, email, password_hash, phone, age, registered_at, status, purchased_at)
# values ('user1', 'ololo@gmail.com', 'olololololopishpishrealne123', 89235230612, 16, now(), default, default);


# сэмитируем прохождения заданий:
# выставление флага is_checked в user_progress_tasks
# преход на очередную mnemonic_stage_id и увеличение счетчика count_right для активных слов в user_progress_words
drop procedure if exists insert_into_user_progress_words;
create procedure insert_into_user_progress_words(in this_user_id bigint, this_task_id bigint)
begin

    declare act_words json default ((select elements -> "$.words_id_active_or_to_del"
                                     from task
                                     where id = this_task_id));
    declare i int default json_length(act_words);
    declare continue handler for sqlstate '23000' set @duplicate_entry_error = 'repeat word element';


    update user_progress_tasks upt
    set is_checked = 1
    where upt.user_id = this_user_id
      and upt.task_id = this_task_id;


    while i > 0
        do
            set @current_word_id = json_extract(act_words, concat('$[', i - 1, ']'));
            insert into user_progress_words(user_id, word_id, count_right) values (user_id, @current_word_id, 1);

            set i = i - 1;

            if @duplicate_entry_error is not null then

                update user_progress_words upw
                set upw.mnemonic_stage_id = case
                                                when upw.mnemonic_stage_id < 8 then mnemonic_stage_id + 1
                                                when upw.mnemonic_stage_id >= 8 then 8
                    end,
                    count_right           = count_right + 1,
                    expire_at             = adddate(now(), interval (select hours_before_repeat
                                                                     from mnemonic_stage
                                                                     where mnemonic_stage.id = upw.mnemonic_stage_id) hour)

                where user_id = this_user_id
                  and word_id = @current_word_id;

            end if;

        end while;

end;


# пусть пользователь 1 пройдет все 22 созданных задания
call insert_into_user_progress_words(1, 1);
call insert_into_user_progress_words(1, 2);
call insert_into_user_progress_words(1, 3);
call insert_into_user_progress_words(1, 4);
call insert_into_user_progress_words(1, 5);
call insert_into_user_progress_words(1, 6);
call insert_into_user_progress_words(1, 7);
call insert_into_user_progress_words(1, 8);
call insert_into_user_progress_words(1, 9);
call insert_into_user_progress_words(1, 10);
call insert_into_user_progress_words(1, 11);
call insert_into_user_progress_words(1, 12);
call insert_into_user_progress_words(1, 13);
call insert_into_user_progress_words(1, 14);
call insert_into_user_progress_words(1, 15);
call insert_into_user_progress_words(1, 16);
call insert_into_user_progress_words(1, 17);
call insert_into_user_progress_words(1, 18);
call insert_into_user_progress_words(1, 19);
call insert_into_user_progress_words(1, 20);
call insert_into_user_progress_words(1, 21);
call insert_into_user_progress_words(1, 22);

# пусть пользователь 2 пройдет 5 созданных заданий
call insert_into_user_progress_words(2, 1);
call insert_into_user_progress_words(2, 2);
call insert_into_user_progress_words(2, 3);
call insert_into_user_progress_words(2, 4);
call insert_into_user_progress_words(2, 5);

# пусть пользователь 3 пройдет 12 созданных заданий
call insert_into_user_progress_words(3, 1);
call insert_into_user_progress_words(3, 2);
call insert_into_user_progress_words(3, 3);
call insert_into_user_progress_words(3, 4);
call insert_into_user_progress_words(3, 5);
call insert_into_user_progress_words(3, 6);
call insert_into_user_progress_words(3, 7);
call insert_into_user_progress_words(3, 8);
call insert_into_user_progress_words(3, 9);
call insert_into_user_progress_words(3, 10);
call insert_into_user_progress_words(3, 11);
call insert_into_user_progress_words(3, 12);
