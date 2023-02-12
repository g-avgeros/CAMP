---CREATE TABLE payment---
DROP TABLE IF EXISTS payment
GO
CREATE TABLE payment (
	payCode		INTEGER		PRIMARY KEY,
	payMethod	CHAR(2)
)
GO


---CREATE TABLE customer---
DROP TABLE IF EXISTS customer
GO
CREATE TABLE customer (
	custCode	INTEGER		PRIMARY KEY,
	custName	VARCHAR(30),
	custSurname VARCHAR(30),
	custPhone	VARCHAR(20)
)
GO



---CREATE TABLE staff---
DROP TABLE IF EXISTS staff
GO
CREATE TABLE staff (
	staffNo		INTEGER		PRIMARY KEY,
	staffName	VARCHAR(30),
	staffSurname VARCHAR(30),
)
GO



---CREATE TABLE camp---
DROP TABLE IF EXISTS camp
GO
CREATE TABLE camp (
	campCode	CHAR(3)		PRIMARY KEY,
	campName	VARCHAR(50),
	numOfEmp	INTEGER,
)
GO



---CREATE TABLE seatCategory---
DROP TABLE IF EXISTS seatCategory
GO
CREATE TABLE seatCategory (
	catCode		CHAR(1)		PRIMARY KEY,
	areaM2		INTEGER,
	unitCost	NUMERIC(4,2),
)
GO



---CREATE TABLE seat---
DROP TABLE IF EXISTS seat
GO
CREATE TABLE seat (
	empNo		INTEGER		PRIMARY KEY,
	catCode		CHAR(1)		REFERENCES seatCategory (catCode),
)
GO



---CREATE TABLE book---
DROP TABLE IF EXISTS book
GO
CREATE TABLE book (
	bookCode	INTEGER		PRIMARY KEY,
	bookDt		DATE,	
	payCode		INTEGER		REFERENCES payment (payCode),
	custCode	INTEGER		REFERENCES customer (custCode),
    staffNo		INTEGER		REFERENCES staff (staffNo),
)
GO



---CREATE TABLE bookDetails---
DROP TABLE IF EXISTS bookDetails
GO
CREATE TABLE bookDetails (
	bookDetailsCode		INTEGER IDENTITY(1,1)	PRIMARY KEY,
	startDt				DATE,
	endDt				DATE,
	noPers				INTEGER,
	bookCode			INTEGER					REFERENCES book (bookCode),
    campCode			CHAR(3)					REFERENCES camp (campCode),
    empNo				INTEGER					REFERENCES seat (empNo),
)
GO




---INSERT DATA INTO TABLES-----
INSERT INTO payment
SELECT DISTINCT payCode, payMethod FROM campData
GO


INSERT INTO customer
SELECT DISTINCT custCode, custName, custSurname, custPhone FROM campData
GO


INSERT INTO staff
SELECT DISTINCT staffNo, staffName, staffSurname FROM campData
GO


INSERT INTO camp
SELECT DISTINCT campCode, campName, numOfEmp FROM campData
GO


INSERT INTO seatCategory
SELECT DISTINCT catCode, areaM2, unitCost  FROM campData
GO


INSERT INTO seat
SELECT DISTINCT empNo, catCode FROM campData
GO


INSERT INTO book
SELECT DISTINCT bookCode, bookDt, payCode, custCode, staffNo FROM campData
GO


INSERT INTO bookDetails 
SELECT startDt, endDt, noPers, bookCode, campCode, empNo FROM campData;
GO
