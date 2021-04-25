use chinesebreak;

# сколько слов в каждом топике
select topic_id, count(id) as 'words per topic'
from word
group by topic_id;

# сколько грамматик в каждом топике
select topic_id, count(id) as 'grammars per topic'
from grammar
group by topic_id;

# в каком топике больше всего грамматик
select topic_id, count(*) grammars
from grammar
group by topic_id
order by grammars desc
limit 1;

# сколько в среднем иероглифов на каждый топик
select round(avg(cnt))
from (select count(id) cnt
      from `character`
      group by topic_id) tbl;

# сколько слов состоит более чем из одного иероглифа в первых двух топиках
select count(`char`) compound_words_qty
from word
where length(`char`) > 3
  and topic_id <= 2;

# слова с pinyin содержащие i
select count(id) words_with_i_qty, group_concat(' ', pinyin) pinyin_with_i
from `word`
where pinyin like '%i%';

# слова с pinyin содержащие a
select count(id) words_with_a_qty, group_concat(' ', pinyin) pinyin_with_a
from `word`
where pinyin like '%a%';


# сколько слов прошел каждый пользователь

select *
from user_progress_words;

select *
from task;

# посмотрим какие слова, грамматику и иероглифы пройдут пользователи в каком топике\ уроке\ задании
drop function if exists active_elements;
create function active_elements(task_id bigint)
    returns json deterministic
begin
    return json_object(
            'active_words', (select elements -> "$.words_id_active_or_to_del" from task where id = task_id),
            'active_grammar', (select elements -> "$.grammar_id_active" from task where id = task_id),
            'active_character', (select elements -> "$.character_id_active" from task where id = task_id)
        );
end;

select topic.id, topic.name, lesson.id, task.id, active_elements(task.id)
from task
         join lesson on task.lesson_id = lesson.id
         join topic on lesson.topic_id = topic.id
order by lesson_id
;

# # запрос при повторе пользователем грамматики
# update user_progress_grammars upg
# set upg.mnemonic_stage_id = case
#                                 when upg.mnemonic_stage_id < 8 then mnemonic_stage_id + 1
#                                 when upg.mnemonic_stage_id >= 8 then 8
#     end,
#     count_right           = count_right + 1,
#     expire_at             = adddate(now(), interval (select hours_before_repeat
#                                                      from mnemonic_stage
#                                                      where mnemonic_stage.id = upg.mnemonic_stage_id) hour)
#
# where user_id = 1
#   and grammar_id = 1;
#
# # запрос при повторе пользователем иероглифа
# update user_progress_characters upc
# set upc.mnemonic_stage_id = case
#                                 when upc.mnemonic_stage_id < 8 then mnemonic_stage_id + 1
#                                 when upc.mnemonic_stage_id >= 8 then 8
#     end,
#     count_right           = count_right + 1,
#     expire_at             = adddate(now(), interval (select hours_before_repeat
#                                                      from mnemonic_stage
#                                                      where mnemonic_stage.id = upc.mnemonic_stage_id) hour)
#
# where user_id = 1
#   and character_id = 1;
#
# # добавить транзакцию с возможностью менять уроки местами



