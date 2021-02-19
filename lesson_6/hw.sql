/* ************************************************************************************** */
/* TASK 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите  */
/*         человека, который больше всех общался с нашим пользователем.                   */
/* ************************************************************************************** */

-- arlo50@example.org заданный пользователь
SELECT t.user_id
FROM (
         SELECT COUNT(m.id) as count_messages,
                CASE
                    WHEN fu.email = 'arlo50@example.org' THEN tu.id
                    WHEN tu.email = 'arlo50@example.org' THEN fu.id
                    END     AS user_id
         FROM messages m
                  JOIN users fu ON m.from_user_id = fu.id
                  JOIN users tu ON m.to_user_id = tu.id
         WHERE EXISTS(
                       SELECT *
                       FROM friend_requests fr
                       WHERE fr.target_user_id = fu.id AND fr.initiator_user_id = tu.id
                          OR fr.target_user_id = tu.id AND fr.initiator_user_id = fu.id
                   )
         GROUP BY user_id
     ) t
WHERE t.user_id IS NOT NULL
ORDER BY t.count_messages DESC
LIMIT 1;

/* **************************************************************************************** */
/* TASK 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет. */
/* **************************************************************************************** */

SELECT t.user_id, t.count_likes
FROM (
         SELECT u.id as user_id, COUNT(l.id) as count_likes
         FROM users u
                  JOIN media m ON u.id = m.user_id
                  JOIN likes l ON m.id = l.media_id
         GROUP BY u.id
     ) t
         JOIN profiles p ON t.user_id = p.user_id
WHERE (TO_DAYS(NOW()) - TO_DAYS(p.birthday)) / 365.25 < 10;

/* ************************************************************************************** */
/* TASK 3. Определить кто больше поставил лайков (всего): мужчины или женщины.            */
/* ************************************************************************************** */

SELECT COUNT(l.id), p.gender
FROM likes l
         JOIN users u ON l.user_id = u.id
         JOIN profiles p ON u.id = p.user_id
GROUP BY p.gender