--Total number of bookings per payment method.
SELECT payMethod, COUNT(bookCode) AS total 
FROM payment p 
	INNER JOIN book b ON p.payCode = b.payCode 
GROUP BY payMethod
GO

--The name of the employee who processed the most reservations.
SELECT TOP 1 staffName, staffSurname, COUNT(bd.bookCode) AS total 
FROM staff s 
	INNER JOIN book b		ON s.staffNo	= b.staffNo
	INNER JOIN bookDetails bd	ON bd.bookCode	= b.bookCode
GROUP BY staffName, staffSurname
ORDER BY total DESC 
GO

--Total number of bookings that contain only seats category "A" of one or more camps.
SELECT COUNT(bookCode) AS total
FROM seat s 
	INNER JOIN  bookDetails bd	ON bd.empNo	= s.empNo
	INNER JOIN  camp c		ON c.campCode	= bd.campCode
WHERE s.catCode = 'A'
GO

--The name of each customer and the total number of bookings made in the year 2000.
SELECT custSurname, custName, COUNT(bookCode) AS total
FROM customer c 
	INNER JOIN book b		ON c.custCode	=   b.custCode
WHERE bookDt >= '2000-1-1'		AND bookDt	<= '2000-12-31'
GROUP BY custSurname, custName
ORDER BY custSurname
GO

--The total value of bookings (total revenue) per camp.
SELECT DISTINCT campCode, campName,
SUM(costPerRental) OVER(PARTITION BY campCode) AS totalCost
FROM (
		SELECT  c.campCode, c.campName, bd.startDt, bd.endDt, bd.noPers, cat.unitCost,
				cat.unitCost * bd.noPers * (DATEDIFF(day, bd.startDt, bd.endDt) + 1) AS costPerRental
		FROM bookDetails bd
			INNER JOIN camp c		ON bd.campCode	= c.campCode
			INNER JOIN seat s		ON bd.empNo	= s.empNo
			INNER JOIN seatCategory cat 	ON s.catCode	= cat.catCode
) cost_per_rental
GO


------------------------------------------------------------------------------------------
-- INDEXES
------------------------------------------------------------------------------------------

--An index for the query to find the name of each customer and the total number of bookings made in the year 2000.
DROP INDEX IF EXISTS idx_custSurname_bookDt ON book
GO

CREATE INDEX idx_custSurname_bookDt	ON book (bookDt) 
GO

SELECT custSurname, custName, COUNT(bookCode) AS total
FROM customer c 
	INNER JOIN book b		ON c.custCode = b.custCode
WHERE bookDt >= '2000-1-1' 		and bookDt    <='2000-12-31'
GROUP BY custSurname, custName
ORDER BY custSurname
GO

--An index for the query to find the total value of bookings (total revenue) per camp.
DROP INDEX IF EXISTS idx_bookDetailsCode ON bookDetails
GO

CREATE INDEX idx_bookDetailsCode ON bookDetails (bookCode, campCode, empNo)
GO

SELECT DISTINCT campCode, campName,
SUM(costPerRental) OVER(PARTITION BY campCode) AS totalCost
FROM 
	(
		SELECT  c.campCode, c.campName, bd.startDt, bd.endDt, bd.noPers, cat.unitCost,
				cat.unitCost * bd.noPers * (DATEDIFF(day, bd.startDt, bd.endDt) + 1) AS costPerRental
		FROM bookDetails bd
			INNER JOIN camp c			ON bd.campCode	= c.campCode
			INNER JOIN seat s			ON bd.empNo	= s.empNo
			INNER JOIN seatCategory cat 		ON s.catCode	= cat.catCode
) cost_per_rental
GO





