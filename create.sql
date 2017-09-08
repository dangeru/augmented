DROP DATABASE IF EXISTS augmented;
CREATE DATABASE augmented;
GRANT ALL ON augmented.* TO augmented@'%' IDENTIFIED BY 'augmented';
USE augmented;
CREATE TABLE posts (
  post_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	title TEXT,
  content TEXT NOT NULL,
  description TEXT,
  attach TEXT,
	author TEXT NOT NULL,
  is_op BOOLEAN NOT NULL,
  is_signed_author BOOLEAN,
  parent INTEGER,
  ip TEXT NOT NULL,
  tag TEXT,
  date_posted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
