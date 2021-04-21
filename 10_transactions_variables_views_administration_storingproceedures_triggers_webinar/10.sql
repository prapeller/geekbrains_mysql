use vk;

drop procedure if exists friendship_offers;
create procedure friendship_offers(to_user_id bigint)
begin
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#     common home town
    select p2.user_id
    from profiles p1
             join profiles p2 on p1.hometown = p2.hometown
    where p1.user_id = to_user_id
      and p2.user_id != to_user_id

    union

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#     common group
    select uc2.user_id
    from users_communities uc1
             join users_communities uc2 on uc1.community_id = uc2.community_id
    where uc1.user_id = to_user_id
      and uc2.user_id != to_user_id

    union

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#     friends of friends
# друзья друзей инициаторы
    select initiator_user_id
    from friend_requests
    where status = 'approved'
      and target_user_id in
#          друзья
          (select initiator_user_id
           from friend_requests
           where status = 'approved'
             and target_user_id = to_user_id
           union
           select target_user_id
           from friend_requests
           where status = 'approved'
             and initiator_user_id = to_user_id)
      and friend_requests.initiator_user_id != to_user_id

    union

# друзья друзей получатели
    select target_user_id
    from friend_requests
    where status = 'approved'
      and initiator_user_id in
          (select initiator_user_id
           from friend_requests
           where status = 'approved'
             and target_user_id = to_user_id
           union
           select target_user_id
           from friend_requests
           where status = 'approved'
             and initiator_user_id = to_user_id)
      and friend_requests.target_user_id != to_user_id

    union

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# friends of friends (using join)

    select fr2.initiator_user_id
    from (select initiator_user_id
          from friend_requests
          where status = 'approved'
            and target_user_id = to_user_id
          union
          select target_user_id
          from friend_requests
          where status = 'approved'
            and initiator_user_id = to_user_id) friends
             join friend_requests fr2
                  on fr2.target_user_id = friends.initiator_user_id and fr2.initiator_user_id != to_user_id and
                     status = 'approved'

    union

    select fr2.target_user_id
    from (select initiator_user_id
          from friend_requests
          where status = 'approved'
            and target_user_id = to_user_id
          union
          select target_user_id
          from friend_requests
          where status = 'approved'
            and initiator_user_id = to_user_id) friends
             join friend_requests fr2
                  on fr2.initiator_user_id = friends.initiator_user_id and fr2.target_user_id != to_user_id and
                     status = 'approved'
    order by rand()
    limit 5;

end;

call friendship_offers(1);

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

drop function if exists friendship_direction;
create function friendship_direction(check_user_id bigint) returns float
    reads sql data
begin
    declare requests_to_user int;
    declare requests_from_user int;

    set requests_to_user = (select count(*) from friend_requests where target_user_id = check_user_id);
#   select count(*) into requests_from_user from fiend_requests where target_user_id = check_user_id;

    set requests_from_user = (select count(*) from friend_requests where initiator_user_id = check_user_id);
#   select count(*) into requests_from_user from fiend_requests where initiator_user_id = check_user_id;

    return requests_to_user / requests_from_user;


end;

select round(friendship_direction(1), 2) as user_popularity;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# procedure for adding user

drop procedure if exists insert_user;
create procedure vk.insert_user(
    in firstname varchar(100), lastname varchar(100), email varchar(100), phone varchar(100), hometown varchar(100),
    photo_id int,
    out tran_result varchar(100))
begin
    declare `_rollback` bit default 0;
    declare code varchar(100);
    declare error_string varchar(100);
    declare continue handler for sqlexception
        begin
            set _rollback = 1;
            get stacked diagnostics condition 1
                code = returned_sqlstate, error_string = message_text;
        end;
    start transaction;

    insert into users (firstname, lastname, email, phone)
    values (firstname, lastname, email, phone);

    insert into profiles (user_id, birthday, photo_id, hometown)
    values (last_insert_id(), birthday, photo_id, hometown);
    if _rollback then
        set tran_result = concat('error code: ', code, 'error text: ', error_string);
        rollback;
    else
        set tran_result = 'user added';
        commit;
    end if;
end;

call insert_user('new', 'user', 'new_user@mail.ru', 9110000000, 'moscow', 1, @transaction_result);
select @transaction_result;

select *
from users u
         left join profiles p on u.id = p.user_id
order by u.id desc;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# transaction for user deleting

select @@global.foreign_key_checks, @@session.foreign_key_checks; -- for checking fk checkings

start transaction;
select @last_user_id := 110;

set foreign_key_checks = 0;

delete
from users
where id = @last_user_id;

delete
from profiles
where user_id = @last_user_id;

set foreign_key_checks = 1;

commit;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# views

create or replace view v_friends as
select *
from users u
         join friend_requests fr on u.id = fr.target_user_id
where status = 'approved'
union
select *
from users u
         join friend_requests fr on u.id = fr.initiator_user_id
where status = 'approved';

select distinct initiator_user_id, target_user_id
from v_friends
where initiator_user_id = 1
   or target_user_id = 1;
drop view v_friends;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# triggers

create trigger check_user_age_before_insert
    before insert
    on profiles
    for each row
begin
    if new.birthday >= current_date() then
        set new.birthday = current_date();
    end if;
end;

# # # # # # # # # # # # # #
create trigger check_user_age_before_update
    before update
    on profiles
    for each row
begin
    if new.birthday >= current_date() then
        signal sqlstate '45000' set message_text = 'check_user_age_before_update trigger: wrong birthday date';
    end if;
end;

# # # # # # # # # # # # # #
select *
from users u
         join profiles p on u.id = p.user_id
order by id desc;

# # # # # # # # # # # # # #
insert into users (firstname, lastname, email, phone)
values ('', '', '', 0);

insert into profiles (user_id, gender, birthday, photo_id, hometown)
values (last_insert_id(), 'm', '2022-01-15', 3, 'Moscow');

update profiles set birthday = '2023-01-01' where user_id = 111; -- error