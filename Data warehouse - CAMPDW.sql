--Create the tables of the data warehouse(Star Schema)

USE CAMPDW
GO

DROP TABLE IF EXISTS bookingFact
DROP TABLE IF EXISTS customerDim
DROP TABLE IF EXISTS campDim
DROP TABLE IF EXISTS seatDim
DROP TABLE IF EXISTS dateDim
GO

CREATE TABLE customerDim (
	custCode    INTEGER     PRIMARY KEY,
	custName    VARCHAR(30),
	custSurname VARCHAR(30),
	custPhone   VARCHAR(20)
)

CREATE TABLE campDim (
	campCode    CHAR(3)     PRIMARY KEY,
	campName    VARCHAR(50),
	numOfEmp    INTEGER,
)

CREATE TABLE seatDim (
	empNo       INTEGER     PRIMARY KEY,
	catCode     CHAR(1),
	areaM2      INTEGER,
	unitCost    NUMERIC(4,2),
)

CREATE TABLE dateDim (
	dateKey     DATE          PRIMARY KEY,
	d_year      INTEGER,
	d_month     INTEGER,
	d_day       INTEGER,
)

CREATE TABLE bookingFact (
	bookCode	INTEGER,
	bookDt		DATE		REFERENCES	dateDim(dateKey),
	empNo		INTEGER		REFERENCES	seatDim(empNo),
	campCode	CHAR(3)		REFERENCES	campDim(campCode),
	custCode	INTEGER		REFERENCES	customerDim(custCode),
	startDt		DATE,
	endDt		DATE,
	noPers		INTEGER,
	costPerRental	NUMERIC(19,2),
	totalCost	NUMERIC(19,2),
	PRIMARY KEY(bookCode, bookDt, empNo, campCode, custCode, startDt, endDt, noPers)
)
GO

INSERT INTO customerDim 
SELECT * FROM CAMPDB.dbo.customer
GO

INSERT INTO campDim 
SELECT * FROM CAMPDB.dbo.camp
GO

INSERT INTO seatDim 
SELECT empNo, s.catCode, areaM2, unitCost FROM CAMPDB.dbo.seat s INNER JOIN CAMPDB.dbo.seatCategory sc ON s.catCode = sc.catCode 
GO

INSERT INTO dateDim 
SELECT DISTINCT bookDt, YEAR(bookDt), MONTH(bookDt), DAY(bookDt) FROM  CAMPDB.dbo.book
GO


INSERT INTO bookingFact
SELECT *,
SUM(costPerRental) OVER(PARTITION BY bookCode) AS totalCost
FROM (
	SELECT b.bookCode, b.bookDt, s.empNo, bd.campCode, b.custCode,  startDt, endDt, noPers,
	cat.unitCost * bd.noPers * (DATEDIFF(day, bd.startDt, bd.endDt) + 1 ) AS costPerRental
	FROM CAMPDB.dbo.bookDetails bd 
	INNER JOIN CAMPDB.dbo.book b			ON b.bookCode	= bd.bookCode
	INNER JOIN CAMPDB.dbo.seat s			ON s.empNo		= bd.empNo
	INNER JOIN CAMPDB.dbo.seatCategory cat	ON cat.catCode	= s.catCode
) cost_per_rental
GO
