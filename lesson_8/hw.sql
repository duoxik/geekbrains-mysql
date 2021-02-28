/* *************************************************************************************** */
/* TASK 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы     */
/*         данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. */
/*         Используйте транзакции.                                                         */
/* *************************************************************************************** */

USE shop;
DROP PROCEDURE IF EXISTS tran_example;
CREATE PROCEDURE tran_example()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        INSERT INTO sample.users (name, birthday_at, created_at, updated_at)
        SELECT name, birthday_at, created_at, updated_at FROM users WHERE id = 1;
    COMMIT;
END;

CALL tran_example();

/* *************************************************************************************** */
/* TASK 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие,        */
/*         в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна         */
/*         возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать      */
/*         фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 —       */
/*         "Доброй ночи".                                                                  */
/* *************************************************************************************** */

USE shop;
DROP PROCEDURE IF EXISTS hello;

CREATE PROCEDURE hello()
BEGIN
    DECLARE hour INT;
    SET hour = HOUR(NOW());
    SELECT CASE
               WHEN hour < 6 THEN 'Доброй ночи'
               WHEN hour >= 6 AND hour < 12 THEN 'Доброе утро'
               WHEN hour >= 12 AND hour < 18 THEN 'Добрый день'
               WHEN hour >= 18 THEN 'Добрый вечер'
               END;
END;

CALL hello();
