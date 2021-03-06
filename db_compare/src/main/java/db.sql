CREATE TABLE DB(
	ID INT PRIMARY KEY AUTO_INCREMENT,
	CODE varchar(100), 
	NAME VARCHAR(200),
	DRIVER VARCHAR(100),
	URL VARCHAR(1000),
	USERNAME VARCHAR(100),
	PASSWORD VARCHAR(100),
	TYPE VARCHAR(100)
);
CREATE TABLE DB_DETAIL(
	ID BIGINT PRIMARY KEY AUTO_INCREMENT,
	VERSION_ID INT, 
	TABLE_NAME VARCHAR(255),
	COLUMN_NAME VARCHAR(255),
	COLUMN_TYPE VARCHAR(100),
	COLUMN_SIZE int
);
CREATE TABLE VERSION(
	ID BIGINT PRIMARY KEY AUTO_INCREMENT,
	DB_ID INT,
	DESCR VARCHAR(500),
	CREATE_DATE VARCHAR(20)
);
CREATE TABLE APP(
	ID INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(100),
	TITLE VARCHAR(500),
	PX INT,
	DEPENDS VARCHAR(200)
);
CREATE TABLE APP_TABLE(
	ID BIGINT PRIMARY KEY AUTO_INCREMENT,
	APP_NAME VARCHAR(100),
	TABLE_NAME VARCHAR(255),
	DATA VARCHAR(10)
);
CREATE TABLE APP_TABLE_DATA(
	ID BIGINT PRIMARY KEY AUTO_INCREMENT,
	TABLE_NAME VARCHAR(255),
	TYPE VARCHAR(20),
	SQL VARCHAR(4000)
);