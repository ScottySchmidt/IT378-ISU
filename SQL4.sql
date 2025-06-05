/*
Illinois State University IT_378
Scott Schmidt and Quinton Soipan 
SQL #4

0. SET ECHO On;
1. List all the U-boat captains (i.e., COMMANDER). Do not show any duplicates.
2. List the last ship (by date) attacked.
3. How many U-boats are in our data?
4. What is the average weight of ships in our data?
5. What is the name of the lightest ship in our data?
6. How many ships were attacked between 09-MAR-1942 and 13-FEB-1945? Use COUNT (*)
7. List the heaviest ship (by tons) from each country. See Chapter 11 slides
8. List the total tons of ships for each of the 4 countries. See Chapter 11 slides
9. List the total number of ships for each of the 4 countries, order from least to greatest number of ships. See Chapter 11 slides
10. Make up your own query -- answer an interesting question using our data -- without using joins or subqueries (we'll get to those later). 
*/
---------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE UBOATS;
DROP TABLE SHIPS;
DROP TABLE ATTACKS;

CREATE TABLE UBOATS
   (	UBOAT VARCHAR2(10) PRIMARY KEY,
  	COMMANDER VARCHAR2(40)
   );
   
   CREATE TABLE SHIPS
   (	SID  VARCHAR2(10) PRIMARY KEY, 
	SHIP VARCHAR2(40) NOT NULL, 
	TONS NUMBER, 
  	NAT VARCHAR2(2)
   );
   
 CREATE TABLE ATTACKS
   ( DAY DATE,
     UBOAT VARCHAR2(10) ,	
     SID  VARCHAR2(10) 
   );
   ------------------------------------------------------------------------------------------------------------------------------
1. List all the U-boat captains (i.e., COMMANDER). Do not show any duplicates.
SET ECHO ON;
SELECT DISTINCT COMMANDER
FROM UBOATS;

--- Distinct will entire no duplicates
------------------------------------------------------------------------------------------------------------------------------
2. List the last ship (by date) attacked

SET ECHO ON;
SELECT S.SHIP, A.DAY
FROM ATTACKS A
JOIN SHIPS S ON A.SID = S.SID
WHERE A.DAY = (SELECT MAX(DAY) FROM ATTACKS);
----Subquery that will selecct the last day boat only

------------------------------------------------------------------------------------------------------------------------------
3. How many U-boats are in our data?

SET ECHO ON;
SELECT COUNT(*) AS total_uboats 
FROM UBOATS;
--- Since Uboats is a primary key the amount of rows will be amount of uboats. 

------------------------------------------------------------------------------------------------------------------------------
4. What is the average weight of ships in our data?

SET ECHO ON;
SELECT AVG(tons) AS average_weight
FROM (
  SELECT DISTINCT SHIP, TONS
  FROM SHIPS
);

---This ensures that each ship is only counted once. 
------------------------------------------------------------------------------------------------------------------------------
5. What is the name of the lightest ship in our data?

SET ECHO ON;

SELECT ship, tons
FROM SHIPS
WHERE tons = (
  SELECT MIN(tons)
  FROM SHIPS
);

-- This method is generally faster than ORDER BY because sorting would require sorting the table (doing extra work). 

------------------------------------------------------------------------------------------------------------------------------
6. How many ships were attacked between 09-MAR-1942 and 13-FEB-1945? Use COUNT (*)

SET ECHO ON;

SELECT COUNT(*)
FROM ATTACKS A
JOIN SHIPS S ON A.SID = S.SID
WHERE A.DAY BETWEEN TO_DATE('09-MAR-1942', 'DD-MON-YYYY') 
AND TO_DATE('13-FEB-1945', 'DD-MON-YYYY');

---Below is format how dates were inserted:
---INSERT INTO ATTACKS (DAY, UBOAT, SID) 
VALUES (TO_DATE('28-DEC-1939'), 'U-30', '4');

------------------------------------------------------------------------------------------------------------------------------
7. List the heaviest ship (by tons) from each country. See Chapter 11 slides

SET ECHO ON;
SELECT SHIP, TONS, NAT
FROM (
  SELECT
    SHIP, TONS, NAT,
    DENSE_RANK() OVER (PARTITION BY NAT ORDER BY TONS DESC) AS rnk
  FROM SHIPS
)
WHERE rnk = 1;

-- Window functions often more readable with better performance. 

------------------------------------------------------------------------------------------------------------------------------
8. List the total tons of ships for each of the 4 countries. See Chapter 11 slides

SET ECHO ON;

SELECT nat, SUM(tons) AS total_tons
FROM ships
GROUP BY nat;

------------------------------------------------------------------------------------------------------------------------------
9. List the total number of ships for each of the 4 countries, order from least to greatest number of ships. See Chapter 11 slides

SET ECHO ON;

SELECT nat, COUNT(DISTINCT ship) AS total_ships
FROM ships
GROUP BY nat
ORDER BY total_ships ASC;


------------------------------------------------------------------------------------------------------------------------------
10. Make up your own query -- answer an interesting question using our data -- without using joins or subqueries (we'll get to those later). 
How many attacks happened on each day?

SET ECHO ON;

SELECT DAY, COUNT(*) AS attacks_count
FROM ATTACKS
GROUP BY DAY
ORDER BY attacks_count DESC;
