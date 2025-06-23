Scott Schmidt and Quin Soipas
IT378 Advanced Database, Illinois State University
Part 3 Querying the Data (10 Points)
-----------------------------------------------------------
13.Query the proper systems/dictionary table to show all constraints on each table youcreated. And only the tables you created for this assignment.

SET ECHO ON;
SELECT table_name, constraint_name, constraint_type
FROM user_constraints
WHERE table_name IN (
    'INVENTORY',
    'INVENTORY_PARTS',
    'PARTS',
    'SETS',
    'COLORS',
    'PART_CATEGORIES',
    'THEMES'
)
ORDER BY table_name, constraint_type;

SQL> SET ECHO ON;
SQL> SELECT table_name, constraint_name, constraint_type
  2  FROM user_constraints
  3  WHERE table_name IN (
  4      'INVENTORY',
  5      'INVENTORY_PARTS',
  6      'PARTS',
  7      'SETS',
  8      'COLORS',
  9      'PART_CATEGORIES',
 10      'THEMES'
 11  )
 12  ORDER BY table_name, constraint_type;

TABLE_NAME                                                                                                                       CONSTRAINT_NAME                                                                                                                  C
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -
COLORS                                                                                                                           SYS_C00454169                                                                                                                    C
COLORS                                                                                                                           SYS_C00454168                                                                                                                    C
COLORS                                                                                                                           SYS_C00454166                                                                                                                    C
COLORS                                                                                                                           SYS_C00454167                                                                                                                    C
COLORS                                                                                                                           SYS_C00454170                                                                                                                    P
INVENTORY                                                                                                                        SYS_C00454147                                                                                                                    C
INVENTORY                                                                                                                        SYS_C00454146                                                                                                                    C
INVENTORY                                                                                                                        SYS_C00454148                                                                                                                    P
INVENTORY_PARTS                                                                                                                  SYS_C00454156                                                                                                                    C
INVENTORY_PARTS                                                                                                                  SYS_C00454155                                                                                                                    C
INVENTORY_PARTS                                                                                                                  SYS_C00454153                                                                                                                    C
INVENTORY_PARTS                                                                                                                  SYS_C00454152                                                                                                                    C
INVENTORY_PARTS                                                                                                                  SYS_C00454154                                                                                                                    C
INVENTORY_PARTS                                                                                                                  FK_INVENTORY                                                                                                                     R
PARTS                                                                                                                            SYS_C00454159                                                                                                                    C
PARTS                                                                                                                            SYS_C00454158                                                                                                                    C
PARTS                                                                                                                            SYS_C00454160                                                                                                                    P
PART_CATEGORIES                                                                                                                  SYS_C00454173                                                                                                                    C
PART_CATEGORIES                                                                                                                  SYS_C00454174                                                                                                                    P
SETS                                                                                                                             SYS_C00454164                                                                                                                    C
SETS                                                                                                                             SYS_C00454163                                                                                                                    C
SETS                                                                                                                             SYS_C00454161                                                                                                                    C
SETS                                                                                                                             SYS_C00454162                                                                                                                    C
SETS                                                                                                                             SYS_C00454165                                                                                                                    P
THEMES                                                                                                                           SYS_C00454175                                                                                                                    C
THEMES                                                                                                                           SYS_C00454176                                                                                                                    P
THEMES                                                                                                                           FK_PARENT_THEME                                                                                                                  R

27 rows selected. 


    
14.Create the query needed to answer: How many red parts are there in the Legodata?

SET ECHO ON;
SELECT COUNT(*)
FROM inventory_parts
WHERE color_id IN (
  SELECT id FROM colors 
  WHERE LOWER(name) LIKE '%red%'
);

SQL> SET ECHO ON;
SQL> SELECT COUNT(*)
  2  FROM inventory_parts
  3  WHERE color_id IN (
  4    SELECT id FROM colors 
  5    WHERE LOWER(name) LIKE '%red%'
  6  );

  COUNT(*)
----------
     74553


    
15.Create the query needed to answer: What are the oldest sets in the Lego data?

--- Gets the oldest set only:
SET ECHO ON;
SELECT set_num, name, year
FROM sets
WHERE year = (
  SELECT MIN(year) FROM sets
);

---Will sort by oldest sets:
SELECT set_num, name, year
FROM sets
ORDER BY year ASC;


SQL> --- Gets the oldest set only:
SQL> SET ECHO ON;
SQL> SELECT set_num, name, year
  2  FROM sets
  3  WHERE year = (
  4    SELECT MIN(year) FROM sets
  5  );

SET_NUM              NAME                                                                                                                                                                                                                                                                  YEAR
-------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------
700.1.1-1            Individual 2 x 4 Bricks                                                                                                                                                                                                                                               1950
700.1.2-1            Individual 2 x 2 Bricks                                                                                                                                                                                                                                               1950
700.A-1              Automatic Binding Bricks Small Brick Set (Lego Mursten)                                                                                                                                                                                                               1950
700.B.1-1            Individual 1 x 4 x 2 Window (without glass)                                                                                                                                                                                                                           1950
700.B.2-1            Individual 1 x 2 x 3 Window (without glass)                                                                                                                                                                                                                           1950
700.B.3-1            Individual 1 x 2 x 2 Window (without glass)                                                                                                                                                                                                                           1950
700.B.4-1            Individual 1 x 2 x 4 Door (without glass)                                                                                                                                                                                                                             1950

7 rows selected. 





16.Create the query needed to answer: What is the parent theme with the mostchildren themes?

SET ECHO ON;
SELECT t.parent_id, p.name,
       COUNT(*) AS children_count
FROM themes t
JOIN themes p ON t.parent_id = p.id
WHERE t.parent_id IS NOT NULL
GROUP BY t.parent_id, p.name
ORDER BY children_count DESC
FETCH FIRST 1 ROW ONLY;

    
SQL> SET ECHO ON;
SQL> SELECT t.parent_id, p.name,
  2         COUNT(*) AS children_count
  3  FROM themes t
  4  JOIN themes p ON t.parent_id = p.id
  5  WHERE t.parent_id IS NOT NULL
  6  GROUP BY t.parent_id, p.name
  7  ORDER BY children_count DESC
  8  FETCH FIRST 1 ROW ONLY;

 PARENT_ID NAME                                                                                                 CHILDREN_COUNT
---------- ---------------------------------------------------------------------------------------------------- --------------
       324 Bionicle                                                                                                         38




17.Find the average number of pieces in each Lego set (by year).
Order the results from highest to lowest. Show only the 5 highest years.

SQL> SET ECHO ON;
SQL> SELECT year, avg(num_parts) as avg_pieces
  2  FROM SETS
  3  GROUP BY year
  4  ORDER BY avg_pieces DESC
  5  FETCH FIRST 5 ROWS ONLY;

      YEAR AVG_PIECES
---------- ----------
      2017 260.820946
      2016 253.077181
      2006 246.833922
      2008 231.598854
      2007 227.595016



18.Create the query needed to answer: Which year in the 1980s had the most sets?

SET ECHO ON;
SELECT year, COUNT(*) AS num_sets
FROM SETS
WHERE year BETWEEN 1980 AND 1989
GROUP BY year
ORDER BY num_sets DESC
FETCH FIRST 1 ROW ONLY;


19.Create the query needed to answer: Which theme was the most popular in the 1980s?

SQL> SET ECHO ON;
SQL> SELECT t.name AS theme_name, COUNT(*) AS set_count
  2  FROM SETS s
  3  JOIN THEMES t ON s.theme_id = t.id
  4  WHERE s.year BETWEEN 1980 AND 1989
  5  GROUP BY t.name
  6  ORDER BY set_count DESC
  7  FETCH FIRST 1 ROW ONLY;

THEME_NAME                                                                                            SET_COUNT
---------------------------------------------------------------------------------------------------- ----------
Technic                                                                                                     124


 
Submit a single file (plain text) showing the SQL and results for questions 14-19.
