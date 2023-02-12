--A list of the company's first hundred best customers.

SELECT custCode, custName, custSurname, total, rankedByTotal
FROM 
(
	SELECT custCode, custName, custSurname, total,
	DENSE_RANK() OVER(ORDER BY total DESC) AS rankedByTotal
	FROM 
	(
		SELECT custCode, custName, custSurname, COUNT(bookCode) AS numOfbooks, SUM(totalCost) AS total
		FROM 
		(
			SELECT DISTINCT bookCode, c.custCode, c.custName, c.custSurname, totalCost
			FROM bookingFact b
			INNER JOIN customerDim c	ON c.custCode = b.custCode
		) cust_list
		GROUP BY custCode, custName, custSurname
	) total_books_per_cust
) ranked_by_total
WHERE rankedByTotal <= 100


--The total value of each campsite's bookings per position category for the year 2000.

SELECT c.campName, s.catCode, SUM(b.totalCost) AS totalCost
FROM bookingFact b
	INNER JOIN campDim c	ON c.campCode	= b.campCode
	INNER JOIN seatDim s	ON s.empNo		= b.empNo
	INNER JOIN dateDim d	ON d.dateKey	= b.bookDt
WHERE d.d_year=2000
GROUP BY s.catCode, c.campName


--The total value of bookings per campsite in monthly basis for the year 2018.

SELECT c.campName, d.d_month, SUM(b.totalCost) AS totalCost
FROM bookingFact b
	INNER JOIN campDim c	ON c.campCode	= b.campCode
	INNER JOIN seatDim s	ON s.empNo		= b.empNo
	INNER JOIN dateDim d	ON d.dateKey	= b.bookDt
WHERE d.d_year=2018
GROUP BY c.campName, d.d_month
ORDER BY c.campName, d.d_month


--The total number of tenants per year, camp and position category.

SELECT d.d_year, ca.campName, s.catCode, COUNT(c.custCode) AS totalRenters
FROM bookingFact b
	INNER JOIN customerDim c	ON c.custCode	= b.custCode
	INNER JOIN campDim ca		ON ca.campCode	= b.campCode
	INNER JOIN seatDim s		ON s.empNo		= b.empNo
	INNER JOIN dateDim d		ON d.dateKey	= b.bookDt
GROUP BY 
	GROUPING SETS (
		(),
		(d.d_year),
		(d.d_year, ca.campName),
		(d.d_year, ca.campName, s.catCode)
	)
ORDER BY d.d_year, ca.campName, s.catCode


--A cube which breaks down the value of bookings by year, camp and seat category.

SELECT d.d_year, ca.campName, s.catCode, SUM(costPerRental) AS totalCost
FROM bookingFact b
	INNER JOIN customerDim c	ON c.custCode	= b.custCode
	INNER JOIN campDim ca		ON ca.campCode	= b.campCode
	INNER JOIN seatDim s		ON s.empNo		= b.empNo
	INNER JOIN dateDim d		ON d.dateKey	= b.bookDt
GROUP BY CUBE (
		(d.d_year),
		(d.d_year, ca.campName),
		(d.d_year, ca.campName, s.catCode)
)
GO
