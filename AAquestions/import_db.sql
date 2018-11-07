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
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id)
    REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (question_id)
    REFERENCES questions(id)
  FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  subject_question_title VARCHAR(255) NOT NULL,
  question TEXT,
  parent_reply INTEGER,
  reply_author_id INTEGER NOT NULL,

  FOREIGN KEY (parent_reply)
    REFERENCES replies(id)
);

CREATE TABLE questions_likes (
  user_id INTEGER PRIMARY KEY,
  question_id INTEGER,

  FOREIGN KEY (question_id)
    REFERENCES questions(id)
);



INSERT INTO
  users (fname, lname)
VALUES
  ('Armando', 'C'),
  ('Theo', 'Obbard'),
  ('Ryan', 'Mapa'),
  ('Gal', 'Gadot'),
  ('Bruce', 'Willis'),
  ('Audrey', 'Plaza');

  INSERT INTO
    questions (title, body, author_id)
  VALUES
    ('HELP W JOINS', 'I need help with joins', 1),
    ('Help w life', 'eeeerg help meh', 2),
    ('Am I cool?', 'need an answer asap', 3),
    ('Am I Wonder Woman?', 'I have multiple personality disorder', 4),
    ('How do I make lasagne?', 'Need an answer asap', 5),
    ('Are you my uber driver?', 'I thought I ordered a Lyft, or something', 6),
    ('Where''s Chase?', 'Why is he not at circle time?', 3),
    ('Where is Chris Pine?', 'He''s my co-pilot', 4);


  INSERT INTO
    replies(subject_question_id, subject_question_title, question, parent_reply, reply_author_id)
  VALUES
    (1, 'HELP W JOINS', 'I can help you with JOINS!', NULL, 4);
    -- ('', '', '', '', ''),
    -- ('', '', '', '', ''),
    -- ('', '', '', '', ''),

    INSERT INTO
      question_follows (user_id, question_id)
    VALUES
      (1,6),
      (1,4),
      (2,5),
      (3,7);
