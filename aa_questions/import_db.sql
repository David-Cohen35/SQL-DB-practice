PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR NOT NULL,
    lname VARCHAR NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
 
INSERT INTO 
    users (fname, lname)
VALUES
    ('Arthur', 'Miller'),
    ('Eugene', 'O''Neill');

INSERT INTO
    questions(title, body, user_id)
VALUES
    ('How do you make a table?', 'Lorem ipsem dolor sit amet', ( SELECT id FROM users WHERE lname = 'Miller') );

INSERT INTO
    question_follows(question_id, user_id)
VALUES
    ( (SELECT id FROM questions WHERE title = 'How do you make a table?'), ( SELECT id FROM users WHERE fname = 'Eugene') );

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ( (SELECT id FROM questions WHERE title = 'How do you make a table?'), ( SELECT id FROM users WHERE fname = 'Eugene') );

INSERT INTO
    replies (question_id, user_id, body)
VALUES
    ( (SELECT id FROM questions WHERE title = 'How do you make a table?'), ( SELECT id FROM users WHERE fname = 'Eugene'), 'That''s a good question!' );
