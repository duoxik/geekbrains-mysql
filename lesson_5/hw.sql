/* Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение» */

/* ************************************************************************************** */
/* TASK 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.   */
/*         Заполните их текущими датой и временем.                                        */
/* ************************************************************************************** */

UPDATE users
SET created_at = NOW(),
    updated_at = NOW()
WHERE created_at IS NULL
   OR updated_at IS NULL;

/* ************************************************************************************** */
/* TASK 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at     */
/*         были заданы типом VARCHAR и в них долгое время помещались значения в формате   */
/*         20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив       */
/*         введённые ранее значения.                                                      */
/* ************************************************************************************** */

ALTER TABLE users ADD COLUMN temp_column DATETIME DEFAULT NOW();
UPDATE users SET temp_column = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users RENAME COLUMN temp_column TO created_at;

ALTER TABLE users ADD COLUMN temp_column DATETIME;
UPDATE users SET temp_column = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users DROP COLUMN updated_at;
ALTER TABLE users RENAME COLUMN temp_column TO updated_at;
ALTER TABLE users MODIFY updated_at DATETIME ON UPDATE NOW();

/* ************************************************************************************** */
/* TASK 3. В таблице складских запасов storehouses_products в поле value могут            */
/*         встречаться самые разные цифры: 0, если товар закончился и выше нуля, если     */
/*         на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы */
/*         они выводились в порядке увеличения значения value. Однако нулевые запасы      */
/*         должны выводиться в конце, после всех                                          */
/* ************************************************************************************** */

SELECT p.name AS product_name,
       sh.name AS storehouse_name,
       shp.value AS product_value,
       IF(value > 0, TRUE, FALSE) AS product_available
FROM storehouses_products shp
JOIN products p ON shp.product_id = p.id
JOIN storehouses sh ON shp.storehouse_id = sh.id
ORDER BY product_available DESC,
         product_value;

/* ************************************************************************************** */
/* TASK 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся     */
/*         в августе и мае. Месяцы заданы в виде списка английских названий (may, august) */
/* ************************************************************************************** */

SELECT name,
       MONTHNAME(birthday_at)
FROM users
WHERE MONTHNAME(birthday_at) IN ('May', 'August');

/* ************************************************************************************** */
/* TASK 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.        */
/*         SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке,   */
/*         заданном в списке IN.                                                          */
/* ************************************************************************************** */

SELECT cat.id,
       cat.name,
       CASE
           WHEN id = 5 THEN 3
           WHEN id = 1 THEN 2
           WHEN id = 2 THEN 1
           ELSE 0
       END AS order_priority
FROM
     (
         SELECT id,
                name
         FROM catalogs
         WHERE id IN (5, 1, 2)
     ) cat
ORDER BY order_priority DESC;

/* Практическое задание теме «Агрегация данных» */

/* ************************************************************************************** */
/* TASK 1. Подсчитайте средний возраст пользователей в таблице users.                     */
/* ************************************************************************************** */

SELECT AVG((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) FROM users;

/* ************************************************************************************** */
/* TASK 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней     */
/*         недели. Следует учесть, что необходимы дни недели текущего года, а не года     */
/*         рождения.                                                                      */
/* ************************************************************************************** */

(SELECT 'Monday' AS DAY,
        COUNT(*) AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Monday')
UNION ALL
(SELECT 'Tuesday' AS DAY,
        COUNT(*)  AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Tuesday')
UNION ALL
(SELECT 'Wednesday' AS DAY,
        COUNT(*)    AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Wednesday')
UNION ALL
(SELECT 'Thursday' AS DAY,
        COUNT(*)   AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Thursday')
UNION ALL
(SELECT 'Friday' AS DAY,
        COUNT(*) AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Friday')
UNION ALL
(SELECT 'Saturday' AS DAY,
        COUNT(*)   AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Saturday')
UNION ALL
(SELECT 'Sunday' AS DAY,
        COUNT(*) AS COUNT
 FROM USERS
 WHERE DAYNAME(birthday_at) = 'Sunday');

/* ************************************************************************************** */
/* TASK 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.                 */
/* ************************************************************************************** */

SELECT EXP(SUM(LOG(value)))
FROM (
             (SELECT 1 AS value)
             union
             (SELECT 2 AS value)
             union
             (SELECT 3 AS value)
             union
             (SELECT 4 AS value)
             union
             (SELECT 5 AS value)
     ) T;
