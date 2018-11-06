PRAGMA foreign_keys = ON;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE questions_likes;
DROP TABLE questions;
DROP TABLE users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY
  title VARCHAR(255) NOT NULL
  body TEXT NOT NULL
  author_id INTEGER NOT NULL

  FOREIGN KEY (author_id
    REFERENCES users(id)
  );
);

CREATE TABLE question_follows (
  user_id INTEGER PRIMARY KEY
  question_id INTEGER

  FOREIGN KEY (question_id
    REFERENCES questions(id)
  );

);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY
  subject_question_id INTEGER NOT NULL
  subject_question_title VARCHAR(255) NOT NULL
  question TEXT
  parent_reply INTEGER
  reply_author_id INTEGER NOT NULL

  FOREIGN KEY (parent_reply
    REFERENCES replies(id)
  );
);

CREATE TABLE questions_likes (
  user_id INTEGER PRIMARY KEY
  question_id INTEGER

  FOREIGN KEY (question_id
    REFERENCES questions(id))
);
