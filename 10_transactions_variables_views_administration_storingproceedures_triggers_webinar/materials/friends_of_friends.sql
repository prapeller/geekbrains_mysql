use vk;
# friends (nested)

select initiator_user_id
from friend_requests
where status = 'approved'
  and target_user_id = 1
union
select target_user_id
from friend_requests
where status = 'approved'
  and initiator_user_id = 1;

# friends of friends (nested + join)

select fr2.initiator_user_id
from (select initiator_user_id
      from friend_requests
      where status = 'approved'
        and target_user_id = 1
      union
      select target_user_id
      from friend_requests
      where status = 'approved'
        and initiator_user_id = 1) friends
         join friend_requests fr2
              on fr2.target_user_id = friends.initiator_user_id and fr2.initiator_user_id != 1 and
                 status = 'approved'

union

select fr2.target_user_id
from (select initiator_user_id
      from friend_requests
      where status = 'approved'
        and target_user_id = 1
      union
      select target_user_id
      from friend_requests
      where status = 'approved'
        and initiator_user_id = 1) friends
         join friend_requests fr2
              on fr2.initiator_user_id = friends.initiator_user_id and fr2.target_user_id != 1 and
                 status = 'approved';

# friends of friends (with ... + join)

WITH friends AS (
  select initiator_user_id as id
          from friend_requests
          where status = 'approved'
            and target_user_id = 1
          union
          select target_user_id as id
          from friend_requests
          where status = 'approved'
            and initiator_user_id = 1
)
select fr2.initiator_user_id
    from  friends
             join friend_requests fr2
                  on fr2.target_user_id = friends.id and fr2.initiator_user_id != 1 and
                     status = 'approved'
    union
    select fr2.target_user_id
    from  friends
             join friend_requests fr2
                  on fr2.initiator_user_id = friends.id and fr2.target_user_id != 1 and
                     status = 'approved';

# friends of friends (only joins)

select fr3.initiator_user_id
from friend_requests fr1
         join friend_requests fr2 on (fr1.initiator_user_id = fr2.target_user_id)
         join friend_requests fr3 on (fr3.target_user_id = fr2.initiator_user_id)
    where fr1.initiator_user_id = 1
    AND fr2.status = 'approved'
    AND fr3.status = 'approved'
    AND fr3.initiator_user_id != 1
UNION
select fr3.target_user_id
from friend_requests fr1
         join friend_requests fr2 on (fr1.initiator_user_id = fr2.target_user_id)
         join friend_requests fr3 on (fr3.initiator_user_id = fr2.initiator_user_id)

WHERE fr1.initiator_user_id = 1
  AND fr2.status = 'approved'
  AND fr3.status = 'approved'
  AND fr3.target_user_id != 1

UNION
select fr3.initiator_user_id
from friend_requests fr1
         join friend_requests fr2 on (fr1.target_user_id = fr2.initiator_user_id)
         join friend_requests fr3 on (fr3.target_user_id = fr2.target_user_id)

WHERE fr1.target_user_id = 1
  AND fr2.status = 'approved'
  AND fr3.status = 'approved'
  AND fr3.initiator_user_id != 1
UNION
select fr3.target_user_id
from friend_requests fr1
         join friend_requests fr2 on (fr1.target_user_id = fr2.initiator_user_id)
         join friend_requests fr3 on (fr3.initiator_user_id = fr2.target_user_id)

WHERE fr1.target_user_id = 1
  AND fr2.status = 'approved'
  AND fr3.status = 'approved'
  AND fr3.target_user_id != 1



