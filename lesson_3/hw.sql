USE vk;

-- Таблица, в которой будут храниться посты пользователей
-- Я думаю стоило бы сделать базовую таблицу для пользователей и групп потому,
-- что в вк группы сами похожи по поведению на пользователей (от них можно писать
-- сообщения, отправлять подарки, писать посты и тп) и для того, чтобы привязать пост к пользователю
-- или группе можно было бы обращаться через id базовой сущности. В обратном случае нужно добавлять
-- дополнительное поле author_community_id и для каждого случая заполнять или author_community_id,
-- или author_user_id, что не очень красиво
DROP TABLE IF EXISTS posts;
CREATE TABLE posts
(
    id             SERIAL PRIMARY KEY,
    author_user_id BIGINT UNSIGNED NOT NULL,
    body           TEXT,
    created_at     DATETIME DEFAULT NOW(),
    updated_at     DATETIME ON UPDATE NOW(),
    FOREIGN KEY (author_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Таблица, которая связывает посты с медийными сущностями
-- если я правильно понял суть таблицы media :)
DROP TABLE IF EXISTS posts_media;
CREATE TABLE posts_media
(
    post_id  BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, media_id),
    FOREIGN KEY (post_id) REFERENCES posts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Таблица, которая связывает посты с пользователями
-- По факту таблица содержит записи о репостах
DROP TABLE IF EXISTS posts_users;
CREATE TABLE posts_users
(
    post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES posts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

