DROP DATABASE IF EXISTS augmented;
CREATE DATABASE augmented;
GRANT ALL ON augmented.* TO augmented@'%' IDENTIFIED BY 'augmented';
USE augmented;
CREATE TABLE posts (
  post_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	title TEXT,
  content TEXT,
	author TEXT NOT NULL,
  is_op BOOLEAN NOT NULL,
  parent INTEGER,
  ip TEXT NOT NULL,
  tag TEXT NOT NULL,
  date_posted DATETIME NOT NULL
);
