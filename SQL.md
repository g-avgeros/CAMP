<strong>Normalization and Creating a Logical Schema</strong>

A initial table campData to load the campData file data.

CREATE TABLE campData
( bookCode        INTEGER,
  bookDt          DATE,
  payCode         INTEGER,
  payMethod       CHAR(2),
  custCod         INTEGER,
  custName        VARCHAR(30),
  custSurname     VARCHAR(30),
  custPhone       VARCHAR(20),
  staffNo         INTEGER,
  staffName       VARCHAR(30),
  staffSurname    VARCHAR(30),
  totalCost       NUMERIC (19,2),
  campCode        CHAR(3),
  campName        VARCHAR(50),
  numOfEmp        INTEGER,
  empNo           INTEGER,
  catCode         CHAR(1),
  areaM2          INTEGER,
  unitCost        NUMERIC(4,2),
  startDt         DATE,
  endDt           DATE,
  noPers          INTEGER,
  costPerRental   NUMERIC (19,2)
);
  
  
  
#Load Data to the table campData
SET DATEFORMAT dmy;
BULK INSERT campData
FROM 'C:\Users\iMasteRepair\Desktop\My project github\SQL\Project\campData.txt'
WITH (FIRSTROW = 2,FIELDTERMINATOR= ',', ROWTERMINATOR = '\n');






