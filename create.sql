DROP DATABASE IF EXISTS augmented;
CREATE DATABASE augmented;
GRANT ALL ON augmented.* TO augmented@'%' IDENTIFIED BY 'augmented';
USE augmented;
CREATE TABLE posts (
	title TEXT,
	author TEXT NOT NULL,
  is_op BOOLEAN NOT NULL,
  parent INTEGER,
  ip TEXT NOT NULL,
  date_posted DATETIME NOT NULL
);
