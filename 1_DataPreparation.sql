/**************** DATA PREPARATION ****************/

/* Create Database */ 
DROP DATABASE IF EXISTS Proj_SalesAnalysis;
CREATE DATABASE Proj_SalesAnalysis;
USE Proj_SalesAnalysis;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 'ON';
SHOW GLOBAL VARIABLES LIKE 'local_infile';


/*STEP 1: create table where to load the data from the csv*/
DROP TABLE IF EXISTS SalesTab;

CREATE TABLE SalesTab
(
id  INT NOT NULL AUTO_INCREMENT,
OrderID INT NOT NULL ,
Product VARCHAR (50) NULL,
QuantityOrdered INT NULL,
UnitPrice INT  NULL,
OrderDate DATETIME NULL,
PurchaseAddress VARCHAR (100) NULL,

PRIMARY KEY (id)
);


/*STEP 2: load data from the csv. */
LOAD DATA LOCAL INFILE '/Users/emiliano/Documents/Data_Analysis/PROJECTS/SalesAnalysis_SQL/SalesData.csv'
INTO TABLE SalesTab
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID,	Product,	QuantityOrdered,	UnitPrice,	OrderDate,	PurchaseAddress);


/* STEP 3: add total sales in a new column */ 
ALTER TABLE SalesTab 
ADD TotSales FLOAT NULL;

UPDATE salestab 
SET 
    TotSales = quantityordered * unitprice; 
    
/* Browse data */ 
SELECT 
    *
FROM
    SalesTab
LIMIT 50;


/* STEP 4: extract State, City and Zipcode from Purchase Address */ 
DROP TABLE IF EXISTS SalesTab_v2;
CREATE TEMPORARY TABLE SalesTab_v2 AS 
SELECT 
    *, 
    LEFT(TRIM(SUBSTRING_INDEX(purchaseAddress, ',', - 1)),2) as State,		/* NOTE: there is a blank space left of the state name ' NY' */ 
    SUBSTR(SUBSTRING_INDEX(purchaseaddress, ',',2), INSTR(SUBSTRING_INDEX(purchaseaddress, ',',2), ',')+2) as City, 	/* NOTE: +2 because there is a blank space after the comma */ 
    RIGHT(purchaseAddress, 5) as zipcode
FROM
    SalesTab; 

SELECT 
    *
FROM
    SalesTab_v2; 

/* STEP 5: extract Month and Hour of purchase */ 
DROP TABLE IF EXISTS SalesTab_final; 
CREATE TABLE SalesTab_final AS 
SELECT 
    *,
    EXTRACT(MONTH FROM OrderDate) AS MonthofPurch,
    EXTRACT(HOUR FROM OrderDate) AS HourofPurch
FROM
    SalesTab_v2; 
    
SELECT 
    *
FROM
    SalesTab_final; 

  