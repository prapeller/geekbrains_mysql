# USE gb;
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
	name CHAR(10) DEFAULT 'anonymous',
	description VARCHAR(255)
);
INSERT INTO tbl VALUES (DEFAULT, 'новый пользователь');
INSERT INTO tbl VALUES ('Макс', 'новый пользователь');
# INSERT INTO tbl VALUES ('Очень длинное имя пользователя', 'новый пользователь');
SELECT * FROM tbl;