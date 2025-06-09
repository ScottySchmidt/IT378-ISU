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
SQL> SELECT DISTINCT COMMANDER
  2  FROM UBOATS;

COMMANDER                               
----------------------------------------
ALBERT LAUZEMIS
HANNS-FERDINAND MASSMANN
HANS-BERNHARD MICHALOWSKI
HANS-JOACHIM FORSTER
HEINRICH BLEICHRODT
HEINZ BLISCHKE
HORST DEGEN
KLAUS HORNBOSTEL
OTTO SCHUHART
PAUL HARTWIG
RUDOLF HINZ

COMMANDER                               
----------------------------------------
WOLFGANG KAUFMANN
ADOLF CORNELIUS PIENING
ALFRED EICK
BURCKHARD HACKLANDER
FRIEDRICH ALTMEIER
HANS HEIDTMANN
HANS-ERWIN REITH
HANS-GANTHER LANGE
HANS-WERNER KRAUS
HARTMUT GRAF VON MATUSCHKA
HEINZ BIELFELD

COMMANDER                               
----------------------------------------
HERBERT ZOLLER
JOHANNES HABEKOST
JURGEN KoenenkampKptlt
KLAUS POPP
RICHARD BECKER
SIEGFRIED STRELOW
WERNER HENKE
WILHELM FRANKEN
ALBERT KNEIP
ALBRECHT ACHILLES
ALBRECHT BRANDI

COMMANDER                               
----------------------------------------
GERHARD BIGALK
GUNTHER KUHNKE
HANSKURT VON BREMEN
HEINRICH NIEMEYER
HEINZ-JOACHIM NEUMANN
HERBERT OPITZ
HERBERT UHLIG
JOACHIM PREUSS
KARL-HEINZ WENDT
KONSTANTIN VON PUTTKAMER
OTTO KRETSCHMER

COMMANDER                               
----------------------------------------
REINHARD SUHREN
EITEL-FRIEDRICH KENTRAT
ERICH DOBBERSTEIN
ERNST BAUER
FRIEDRICH-WILHELM MARIENFELD
GERHARD MEYER
GUNTHER  HESSLER
GUNTHER REEDER
GUSTAV POEL
HANS JENISCH
HANS-JURGEN STHAMER

COMMANDER                               
----------------------------------------
HARALD JÃƒÆ’Ã…â€œRST
HEINRICH ZIMMERMANN
HERBERT WOHLFARTH
KARL-HEINZ LANGE
KURT NEIDE
OTTO HARMS
OTTO VON BULOW
SIEGFRIED ROLLMANN
ULRICH GRAF VON SODEN-FRAUNHOFEN
ULRICH PIETSCH
WILHELM BRAUEL

COMMANDER                               
----------------------------------------
WILLI DIETRICH
ADALBERT SCHNEE
DIETRICH GENGELBACH
DIETRICH KNORR
EGON REINER FREIHERR VON SCHLIPPENBACH
FRITZ-JULIUS LEMP
GERD KELBLING
GUNTHER  WIEBOLDT
GUNTHER PRIEN
HANS-JOACHIM SCHWARZ
HEINZ SIEDER

COMMANDER                               
----------------------------------------
HELMUT ROSENBAUM
KLAUS HEINRICH BARGSTEN
PHILIPP SCHULER
ROLF MANKE
SIEGFRIED KOITSCHKA
SIEGFRIED LUDDEN
WILHELM ROLLMANN
ERICH TASCHENMACHER
ERNST-ULRICH BRALLER
FRITZ FRAUENHEIM
GUNTHER JAHN

COMMANDER                               
----------------------------------------
GUNTHER KRECH
HANS-HARTWIG TROJER
HANS-JOACHIM ERNST
HANS-JOACHIM VON MORSTEIN
HANS-PETER HINSCH
HEINRICH SCHUCH
HEINZ GEISSLER
HELMUTH RINGELMANN
KARL HAUSE
KLAUS SCHOLTZ
KLAUS-HELMUTH BECKER

COMMANDER                               
----------------------------------------
PETER-ERICH CREMER
ROLF-HEINRICH HOPMAN
UDO HEILMANN
ULRICH BORCHERDT
WALDEMAR MEHL
WERNER SCHULTE
EDUARD TURRE
FRANZ-GEORG RESCHKE
FRIEDRICH DEETZ
GUNTHER SEIBICKE
HEINRICH SCHONDER

COMMANDER                               
----------------------------------------
HEINRICH VON HOLLEBEN
HERBERT ENGEL
HERMANN HESSE
JURGEN KUHLMANN
KARL THURMANN
OSKAR CURIO
OTTO WESTPHALEN
OTTOKAR ARNOLD PAULSSEN
REINHARD HARDEGEN
ROBERT GYSAE
ROLF STRUCKMEIER

COMMANDER                               
----------------------------------------
SIGURD SEEGER
VICTOR OEHRN
WALTER DANKLEFF
WERNER CZYGAN
WOLFGANG BOEHMER
DIETHER TODENHAGEN
EBERHARD ZIMMERMANN
ERNST HEYDEMANN
ERNST MENGERSEN
FRIEDRICH GUGGENBERGER
FRIEDRICH MARKWORTH

COMMANDER                               
----------------------------------------
GEORG-WERNER FRAATZ
GERHARD PALMGREN
HANS FALKE
HANS-DIEDRICH FREIHERR VON TIESENHAUSEN
HEINZ WALKERLING
HERMANN ECKHARDT
HORST-ARNO FENSKI
HUBERT NORDHEIMER
JOACHIM FRANZE
JOHANN MOHR
JOHANNES MEERMEIER

COMMANDER                               
----------------------------------------
JURGEN OESTEN
KARL-HEINRICH JENISCH
MAX-MARTIN TEICHERT
PAUL SIEGMANN
PAUL-FRIEDRICH OTTO
PETER GERLACH
RUDOLF BAHR
WILHELM DOMMES

151 rows selected. 

SQL> 
SQL> --- Distinct will entire no duplicates
SQL> SET ECHO ON;
SQL> SELECT DISTINCT COMMANDER
  2  FROM UBOATS;

COMMANDER                               
----------------------------------------
ALBERT LAUZEMIS
HANNS-FERDINAND MASSMANN
HANS-BERNHARD MICHALOWSKI
HANS-JOACHIM FORSTER
HEINRICH BLEICHRODT
HEINZ BLISCHKE
HORST DEGEN
KLAUS HORNBOSTEL
OTTO SCHUHART
PAUL HARTWIG
RUDOLF HINZ

COMMANDER                               
----------------------------------------
WOLFGANG KAUFMANN
ADOLF CORNELIUS PIENING
ALFRED EICK
BURCKHARD HACKLANDER
FRIEDRICH ALTMEIER
HANS HEIDTMANN
HANS-ERWIN REITH
HANS-GANTHER LANGE
HANS-WERNER KRAUS
HARTMUT GRAF VON MATUSCHKA
HEINZ BIELFELD

COMMANDER                               
----------------------------------------
HERBERT ZOLLER
JOHANNES HABEKOST
JURGEN KoenenkampKptlt
KLAUS POPP
RICHARD BECKER
SIEGFRIED STRELOW
WERNER HENKE
WILHELM FRANKEN
ALBERT KNEIP
ALBRECHT ACHILLES
ALBRECHT BRANDI

COMMANDER                               
----------------------------------------
GERHARD BIGALK
GUNTHER KUHNKE
HANSKURT VON BREMEN
HEINRICH NIEMEYER
HEINZ-JOACHIM NEUMANN
HERBERT OPITZ
HERBERT UHLIG
JOACHIM PREUSS
KARL-HEINZ WENDT
KONSTANTIN VON PUTTKAMER
OTTO KRETSCHMER

COMMANDER                               
----------------------------------------
REINHARD SUHREN
EITEL-FRIEDRICH KENTRAT
ERICH DOBBERSTEIN
ERNST BAUER
FRIEDRICH-WILHELM MARIENFELD
GERHARD MEYER
GUNTHER  HESSLER
GUNTHER REEDER
GUSTAV POEL
HANS JENISCH
HANS-JURGEN STHAMER

COMMANDER                               
----------------------------------------
HARALD JÃƒÆ’Ã…â€œRST
HEINRICH ZIMMERMANN
HERBERT WOHLFARTH
KARL-HEINZ LANGE
KURT NEIDE
OTTO HARMS
OTTO VON BULOW
SIEGFRIED ROLLMANN
ULRICH GRAF VON SODEN-FRAUNHOFEN
ULRICH PIETSCH
WILHELM BRAUEL

COMMANDER                               
----------------------------------------
WILLI DIETRICH
ADALBERT SCHNEE
DIETRICH GENGELBACH
DIETRICH KNORR
EGON REINER FREIHERR VON SCHLIPPENBACH
FRITZ-JULIUS LEMP
GERD KELBLING
GUNTHER  WIEBOLDT
GUNTHER PRIEN
HANS-JOACHIM SCHWARZ
HEINZ SIEDER

COMMANDER                               
----------------------------------------
HELMUT ROSENBAUM
KLAUS HEINRICH BARGSTEN
PHILIPP SCHULER
ROLF MANKE
SIEGFRIED KOITSCHKA
SIEGFRIED LUDDEN
WILHELM ROLLMANN
ERICH TASCHENMACHER
ERNST-ULRICH BRALLER
FRITZ FRAUENHEIM
GUNTHER JAHN

COMMANDER                               
----------------------------------------
GUNTHER KRECH
HANS-HARTWIG TROJER
HANS-JOACHIM ERNST
HANS-JOACHIM VON MORSTEIN
HANS-PETER HINSCH
HEINRICH SCHUCH
HEINZ GEISSLER
HELMUTH RINGELMANN
KARL HAUSE
KLAUS SCHOLTZ
KLAUS-HELMUTH BECKER

COMMANDER                               
----------------------------------------
PETER-ERICH CREMER
ROLF-HEINRICH HOPMAN
UDO HEILMANN
ULRICH BORCHERDT
WALDEMAR MEHL
WERNER SCHULTE
EDUARD TURRE
FRANZ-GEORG RESCHKE
FRIEDRICH DEETZ
GUNTHER SEIBICKE
HEINRICH SCHONDER

COMMANDER                               
----------------------------------------
HEINRICH VON HOLLEBEN
HERBERT ENGEL
HERMANN HESSE
JURGEN KUHLMANN
KARL THURMANN
OSKAR CURIO
OTTO WESTPHALEN
OTTOKAR ARNOLD PAULSSEN
REINHARD HARDEGEN
ROBERT GYSAE
ROLF STRUCKMEIER

COMMANDER                               
----------------------------------------
SIGURD SEEGER
VICTOR OEHRN
WALTER DANKLEFF
WERNER CZYGAN
WOLFGANG BOEHMER
DIETHER TODENHAGEN
EBERHARD ZIMMERMANN
ERNST HEYDEMANN
ERNST MENGERSEN
FRIEDRICH GUGGENBERGER
FRIEDRICH MARKWORTH

COMMANDER                               
----------------------------------------
GEORG-WERNER FRAATZ
GERHARD PALMGREN
HANS FALKE
HANS-DIEDRICH FREIHERR VON TIESENHAUSEN
HEINZ WALKERLING
HERMANN ECKHARDT
HORST-ARNO FENSKI
HUBERT NORDHEIMER
JOACHIM FRANZE
JOHANN MOHR
JOHANNES MEERMEIER

COMMANDER                               
----------------------------------------
JURGEN OESTEN
KARL-HEINRICH JENISCH
MAX-MARTIN TEICHERT
PAUL SIEGMANN
PAUL-FRIEDRICH OTTO
PETER GERLACH
RUDOLF BAHR
WILHELM DOMMES

151 rows selected. 

------------------------------------------------------------------------------------------------------------------------------
2. List the last ship (by date) attacked

SET ECHO ON;
SELECT S.SHIP, A.DAY
FROM ATTACKS A
JOIN SHIPS S ON A.SID = S.SID
WHERE A.DAY = (SELECT MAX(DAY) FROM ATTACKS);
----Subquery that will selecct the last day boat only

SQL> SET ECHO ON;
SQL> SELECT S.SHIP, A.DAY
  2  FROM ATTACKS A
  3  JOIN SHIPS S ON A.SID = S.SID
  4  WHERE A.DAY = (SELECT MAX(DAY) FROM ATTACKS);

SHIP                                     DAY      
---------------------------------------- ---------
HMS EBOR  WYKE                           02-MAY-45

------------------------------------------------------------------------------------------------------------------------------
3. How many U-boats are in our data?

SET ECHO ON;
SELECT COUNT(*) AS total_uboats 
FROM UBOATS;
--- Since Uboats is a primary key the amount of rows will be amount of uboats. 

SQL> SET ECHO ON;
SQL> SELECT COUNT(*) AS total_uboats 
  2  FROM UBOATS;

TOTAL_UBOATS
------------
         153

------------------------------------------------------------------------------------------------------------------------------
4. What is the average weight of ships in our data?

SET ECHO ON;
SELECT AVG(tons) AS average_weight
FROM (
  SELECT DISTINCT SHIP, TONS
  FROM SHIPS
);
---DISTINCT ensures that each ship is only counted once. 

SQL> SET ECHO ON;
SQL> SELECT AVG(tons) AS average_weight
  2  FROM (
  3    SELECT DISTINCT SHIP, TONS
  4    FROM SHIPS
  5  );

AVERAGE_WEIGHT
--------------
    3198.48558


------------------------------------------------------------------------------------------------------------------------------
5. What is the name of the lightest ship in our data?

SET ECHO ON;
SELECT ship, tons
FROM SHIPS
WHERE tons = (
  SELECT MIN(tons)
  FROM SHIPS
);
-- Generally faster than ORDER BY because sorting would require sorting the table (doing extra work). 

SQL> SET ECHO ON;
SQL> SELECT ship, tons
  2  FROM SHIPS
  3  WHERE tons = (
  4    SELECT MIN(tons)
  5    FROM SHIPS
  6  );

SHIP                                           TONS
---------------------------------------- ----------
HMS LCE-14                                       10
HMS LCV-752                                      10
HMS LCV-754                                      10

------------------------------------------------------------------------------------------------------------------------------
6. How many ships were attacked between 09-MAR-1942 and 13-FEB-1945? Use COUNT (*)
--DATE FORMAT WAS: INSERT INTO ATTACKS (DAY, UBOAT, SID) VALUES (TO_DATE('28-DEC-1939'), 'U-30', '4');
SET ECHO ON;
SELECT COUNT(*)
FROM ATTACKS A
JOIN SHIPS S ON A.SID = S.SID
WHERE A.DAY BETWEEN TO_DATE('09-MAR-1942', 'DD-MON-YYYY') 
AND TO_DATE('13-FEB-1945', 'DD-MON-YYYY');


SQL> SET ECHO ON;
SQL> SELECT COUNT(*)
  2  FROM ATTACKS A
  3  JOIN SHIPS S ON A.SID = S.SID
  4  WHERE A.DAY BETWEEN TO_DATE('09-MAR-1942', 'DD-MON-YYYY') 
  5  AND TO_DATE('13-FEB-1945', 'DD-MON-YYYY');

  COUNT(*)
----------
       135
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

SQL> SET ECHO ON;
SQL> SELECT SHIP, TONS, NAT
  2  FROM (
  3    SELECT
  4      SHIP, TONS, NAT,
  5      DENSE_RANK() OVER (PARTITION BY NAT ORDER BY TONS DESC) AS rnk
  6    FROM SHIPS
  7  )
  8  WHERE rnk = 1;

SHIP                                           TONS NA
---------------------------------------- ---------- --
HMAS PARRAMATTA                                1060 AU
HMS NELSON                                    33950 BR
HMCS VALLEYFIELD                               1445 CA
HMNZS ML-1090                                    46 NZ


------------------------------------------------------------------------------------------------------------------------------
8. List the total tons of ships for each of the 4 countries. See Chapter 11 slides

SET ECHO ON;
SELECT nat, SUM(tons) AS total_tons
FROM ships
GROUP BY nat;

SQL> SET ECHO ON;
SQL> SELECT nat, SUM(tons) AS total_tons
  2  FROM ships
  3  GROUP BY nat;

NA TOTAL_TONS
-- ----------
BR     646720
NZ         46
AU       1060
CA      17459

------------------------------------------------------------------------------------------------------------------------------
9. List the total number of ships for each of the 4 countries, order from least to greatest number of ships. See Chapter 11 slides

SET ECHO ON;
SELECT nat, COUNT(DISTINCT ship) AS total_ships
FROM ships
GROUP BY nat
ORDER BY total_ships ASC;

SQL> SET ECHO ON;
SQL> SELECT nat, COUNT(DISTINCT ship) AS total_ships
  2  FROM ships
  3  GROUP BY nat
  4  ORDER BY total_ships ASC;

NA TOTAL_SHIPS
-- -----------
NZ           1
AU           1
CA          17
BR         189


------------------------------------------------------------------------------------------------------------------------------
10. Make up your own query -- answer an interesting question using our data -- without using joins or subqueries (we'll get to those later). 
How many attacks happened on each day? Show top 10 days only.

SQL> SET ECHO ON;
SQL> SELECT DAY, COUNT(*) AS attacks_count
  2  FROM ATTACKS
  3  GROUP BY DAY
  4  ORDER BY attacks_count DESC
  5  FETCH FIRST 10 ROWS ONLY;

DAY       ATTACKS_COUNT
--------- -------------
14-OCT-42            10
22-AUG-44             3
30-DEC-42             3
17-JAN-43             3
29-OCT-42             3
12-NOV-42             3
20-FEB-44             3
05-JUL-43             2
15-JUN-42             2
20-APR-41             2

10 rows selected. 
