Scott Schmidt
IT378 Illinois State University
SQL Exam1 Part4
--For questions 11-20, submit SQL and results in a single plain text file
--------------------------------------------------------------------------------
create table Sailors(
       sid       int not null constraint sailors_pk primary key,
       sname     varchar2(20),
       rating    int,
       age       decimal(4,1)
);
create table Boats(
       bid       int not null constraint boat_pk primary key,
       bname     varchar2(20),
       color     varchar2(20)
);
create table Reserves(
       sid       int,
       bid       int,
       day       date,
       primary key (sid,bid,day),
       foreign key (sid) references Sailors(sid)
               ON DELETE CASCADE,
       foreign key (bid) references Boats(bid)
               ON DELETE CASCADE 
);
-------------------------------------------------------------------------------------------------
11. Find the ages of sailors whose name begins with B, ends with b, and has at least three characters
--- Rename columns to match critera for easier read later:
WITH cte AS (
    SELECT 
        sname, age,
        SUBSTR(sname, 1, 1) AS first_char,
        SUBSTR(sname, -1, 1) AS last_char,
        LENGTH(sname) AS name_length
    FROM 
        Sailors
) 
--- Easier to read and change later (i.e change first_char)
SELECT sname, age
FROM cte
WHERE first_char = 'B' 
    AND last_char = 'b' 
    AND name_length > 2;

SNAME                       AGE
-------------------- ----------
Bob                        63.5
       

-------------------------------------------------------------------------------------------------
12. Find the average age of all sailors

SELECT ROUND(AVG(age), 2) AS average_age
FROM sailors;

AVERAGE_AGE
-----------
      36.45

       
------------------------------------------------------------------------------------------------
13. Find the name and age of the oldest sailor

SELECT sname, age
FROM sailors
WHERE age = ( SELECT MAX(age) FROM sailors);

SNAME                       AGE
-------------------- ----------
Bob                        63.5

       
-------------------------------------------------------------------------------------------------
14. Find the age of the youngest sailor who is eligible to vote (i.e., is at least 18 years old)
for each rating level with at least two such sailors

with eligible_sailors as (
SELECT rating
FROM sailors
WHERE age >= 18
GROUP BY rating
HAVING count(*) >= 2
),

ranked_sailors as(
SELECT sname, age, rating,
RANK () OVER(PARTITION BY rating ORDER BY age ASC) as rnk 
FROM sailors
WHERE rating in (SELECT rating FROM eligible_sailors)
AND age >= 18
)
SELECT sname, age, rating
FROM ranked_sailors
WHERE rnk = 1;

SNAME                       AGE     RATING
-------------------- ---------- ----------
Mary                         23          1
Caleb                      25.5          3
Kenya                        35          7
Ren                        25.5          8


-------------------------------------------------------------------------------------------------       
15. For each red boat, find the number of reservations for the boat

with red_boats as (
SELECT bid
FROM boats
WHERE color = 'red'
)

SELECT r.bid, count(r.bid) as num_reserves
FROM reserves r 
INNER JOIN red_boats rb
ON r.bid = rb.bid
GROUP BY r.bid;

       BID NUM_RESERVES
---------- ------------
       102            3
       104            2
              
-------------------------------------------------------------------------------------------------
16. Find the top 5 sailors by rating. 
Order by Ranking—from highest to lowest—use column number in the ORDER BY clause.

--ORDER BY METHOD:
SELECT sname, rating
FROM sailors
ORDER BY rating DESC
FETCH FIRST 5 ROWS ONLY;

-- Window Function Method: 
with cte as( 
SELECT sname, rating, 
rank()OVER(ORDER BY rating DESC) as rnk
FROM sailors
)
SELECT sname, rating
FROM cte
WHERE rnk <= 5
ORDER BY rating DESC;

-- Use RANK() to include ties in the top 5.
-- If PARTITION BY was needed (e.g., rank within a group), window functions are more readable and flexible.
-- ORDER BY 2 DESC: Meets the requirement but less readable; column positions can change.

SNAME                    RATING
-------------------- ----------
Anne                         10
Zorba                        10
Jin                           9
Lubber                        8
Ren                           8


-------------------------------------------------------------------------------------------------
17a. Advanced: Find the names of sailors who have reserved both a red AND a blue boat.
       
--- Using two CTE by color (red and blue) would be more readable.
--- This becomes challenging if you had to update new colors later (i.e add another CTE per color).
with bid_red_blue as (
SELECT b.bid, r.sid, b.color
FROM boats b
INNER JOIN reserves r 
ON b.bid = r.bid
 WHERE b.color IN ('red', 'blue')
)
SELECT s.sid, s.sname
FROM bid_red_blue b
JOIN sailors s ON s.sid = b.sid
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT b.color) = 2;

       SID SNAME               
---------- --------------------
        22 Dustin              
        64 Kenya           

-------------------------------------------------------------------------------------------------
17b. If you can answer the STANDARD version as written, I will give you 3 bonus points.
Standard: Find the names of sailors who have reserved both a red OR a blue boat. 

--- Filter red and blue boards only first
with bid_red_blue as (
SELECT b.bid, r.sid, b.color
FROM boats b
INNER JOIN reserves r 
ON b.bid = r.bid
WHERE b.color IN ('red', 'blue')
)
SELECT DISTINCT b.sid, s.sname
FROM bid_red_blue b
LEFT JOIN sailors s
ON s.sid = b.sid;

       SID SNAME               
---------- --------------------
        22 Dustin              
        64 Kenya               
        31 Lubber            


-------------------------------------------------------------------------------------------------
18. Find the names of all sailors who have reserved ANY boat named Interlake.

SELECT DISTINCT s.sid, s.sname
FROM reserves r 
INNER JOIN SAILORS s ON s.sid = r.sid 
INNER JOIN boats b ON b.bid = r.bid
WHERE b.bname = 'Interlake';

       SID SNAME               
---------- --------------------
        22 Dustin              
        64 Kenya               
        31 Lubber              


--- SELECT s.sid, s.sname, b.bname shows this output.
--- This shows the quuery is correct. 

    SID SNAME                BNAME               
---------- -------------------- --------------------
        22 Dustin               Interlake           
        22 Dustin               Interlake           
        31 Lubber               Interlake           
        64 Kenya                Interlake           
        64 Kenya                Interlake      

--- INNER JOIN and LEFT JOIN get same results for this problem.
--- INNER JOIN will exclude sailors with no reservation.               
--- LEFT JOIN would include sailors with no reservation. 

-------------------------------------------------------------------------------------------------
19. Find the names of ALL sailors who have NOT reserved the boat named Clipper. 
--Hint: Most sailors in the sailor table have not reserved a boat named Clipper. 

-- Gather the data through joins:              
with cte as (SELECT s.sid, s.sname, b.bname
FROM reserves r 
INNER JOIN SAILORS s ON s.sid = r.sid 
INNER JOIN boats b ON b.bid = r.bid
)
-- SELECT the sid NOT IN clipper:
SELECT DISTINCT sid, sname
FROM cte
WHERE sid NOT IN (
SELECT sid FROM cte
WHERE bname = 'Clipper');


       SID SNAME               
---------- --------------------
        64 Kenya               

-------------------------------------------------------------------------------------------------
20. Run a query that will show all data in the Sailors, Reserves, and Boats table

--Since FULL OUTER JOINS can create NULL values, it is best to join tables one at a time:
--This would not apply for INNER JOINS since null values would not be created. 
WITH sailor_reserve AS (
  SELECT *
  FROM sailors s
  FULL OUTER JOIN reserves r ON s.sid = r.sid
)
SELECT *
FROM sailor_reserve sr
FULL OUTER JOIN boats b ON sr.bid = b.bid;


QCSJ_C000000000300000 SNAME                    RATING        AGE QCSJ_C000000000300001        BID DAY              BID BNAME                COLOR               
--------------------- -------------------- ---------- ---------- --------------------- ---------- --------- ---------- -------------------- --------------------
                   22 Dustin                        7         45                    22        101 10-OCT-23        101 Interlake            blue                
                   22 Dustin                        7         45                    22        102 10-OCT-23        102 Interlake            red                 
                   22 Dustin                        7         45                    22        103 08-OCT-23        103 Clipper              green               
                   22 Dustin                        7         45                    22        104 07-OCT-23        104 Marine               red                 
                   29 Mary                          1         23                                                                                                
                   31 Lubber                        8       55.5                    31        102 10-NOV-23        102 Interlake            red                 
                   31 Lubber                        8       55.5                    31        103 06-NOV-23        103 Clipper              green               
                   31 Lubber                        8       55.5                    31        104 12-NOV-23        104 Marine               red                 
                   32 Ren                           8       25.5                                                                                                
                   58 Anne                         10         35                                                                                                
                   64 Kenya                         7         35                    64        101 05-SEP-23        101 Interlake            blue                

QCSJ_C000000000300000 SNAME                    RATING        AGE QCSJ_C000000000300001        BID DAY              BID BNAME                COLOR               
--------------------- -------------------- ---------- ---------- --------------------- ---------- --------- ---------- -------------------- --------------------
                   64 Kenya                         7         35                    64        102 08-SEP-23        102 Interlake            red                 
                   71 Zorba                        10         16                                                                                                
                   74 Jin                           9         35                    74        103 08-SEP-23        103 Clipper              green               
                   85 Caleb                         3       25.5                                                                                                
                   95 Bob                           3       63.5                                                                                                
                   96 Jack                          1         42                                                                                                

17 rows selected.
