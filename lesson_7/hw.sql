/* ************************************************************************************** */
/* TASK 1. Составьте список пользователей users, которые осуществили хотя бы один заказ   */
/*         orders в интернет магазине.                                                    */
/* ************************************************************************************** */

SELECT u.id, u.name
FROM users u
WHERE u.id in (
    SELECT DISTINCT(user_id)
    FROM orders
);

/* ******************************************************************************************* */
/* TASK 2. Выведите список товаров products и разделов catalogs, который соответствует товару. */
/* ******************************************************************************************* */

SELECT p.name, c.name
FROM products p
         JOIN catalogs c ON c.id = p.catalog_id;

/* ******************************************************************************************* */
/* TASK 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов  */
/*         cities (label, name). Поля from, to и label содержат английские названия городов,   */
/*         поле name — русское. Выведите список рейсов flights с русскими названиями городов.  */
/* ******************************************************************************************* */

SELECT f.id, cf.name as `from`, ct.name as `to`
FROM flights f
         JOIN cities cf ON f.`from` = cf.label
         JOIN cities ct ON f.`to` = ct.label
ORDER BY f.id;
