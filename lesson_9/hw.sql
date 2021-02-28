/* ****************************************************************************************** */
/* TASK 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах    */
/*         users, catalogs и products в таблицу logs помещается время и дата создания записи, */
/*         название таблицы, идентификатор первичного ключа и содержимое поля name.           */
/* ****************************************************************************************** */

USE shop;
DROP TABLE IF EXISTS logs;
CREATE TABLE logs
(
    id         SERIAL PRIMARY KEY,
    row_id     BIGINT      NOT NULL COMMENT 'Идентификатор записи',
    table_name VARCHAR(64) NOT NULL COMMENT 'Имя таблицы',
    created_at DATETIME DEFAULT NOW() COMMENT 'Дата создания',
    name       VARCHAR(255) COMMENT 'Содержимое поля'
) COMMENT 'Таблица логов' ENGINE = 'Archive';

