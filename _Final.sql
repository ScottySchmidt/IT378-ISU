Scott Schmidt & Quin Soipan
Illinois State University 
IT 378 Advanced Database
Final Project
------------------------------------------------------------------------------------------------------
1.    Show all SETS with 200 or more green pieces. 

  SET ECHO ON;
  -- Calculate total count of green-colored parts per set
  SELECT s.set_num, s.name,
  SUM(ip.quantity) as green_count
  FROM sets s
  INNER JOIN inventory i ON s.set_num = i.set_num
  INNER JOIN inventory_parts ip ON i.id = ip.inventory_id
  INNER JOIN colors c ON c.id = ip.color_id
  WHERE lower(c.name) LIKE '%green%'  -- filter for green parts only
  GROUP BY s.set_num, s.name
  HAVING  SUM(ip.quantity) >= 200;   -- only sets with 200 or more green parts


  SQL> 
  SQL> SET ECHO ON;
  SQL>   SELECT s.set_num, s.name,
    2    SUM(ip.quantity) as green_count
    3    FROM sets s
    4    INNER JOIN inventory i ON s.set_num = i.set_num
    5    INNER JOIN inventory_parts ip ON i.id = ip.inventory_id
    6    INNER JOIN colors c ON c.id = ip.color_id
    7    WHERE lower(c.name) LIKE '%green%'
    8    GROUP BY s.set_num, s.name
    9    HAVING  SUM(ip.quantity) >= 200;
  
  SET_NUM              NAME                                                                                                                                                                                                                                                            GREEN_COUNT
  -------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------
  3920-1               The Hobbit                                                                                                                                                                                                                                                              209
  3724-1               Lego Dragon                                                                                                                                                                                                                                                            1386
  4000001-1            Moulding Machines                                                                                                                                                                                                                                                       200
  10242-2              Mini Cooper                                                                                                                                                                                                                                                             294
  45120-1              LearnToLearn Core set                                                                                                                                                                                                                                                   308
  5526-1               Skyline                                                                                                                                                                                                                                                                 420
  3723-1               Lego Minifigure                                                                                                                                                                                                                                                         335
  3450-1               Statue of Liberty                                                                                                                                                                                                                                                      2867
  10242-1              Mini Cooper                                                                                                                                                                                                                                                             294
  10184-1              Town Plan                                                                                                                                                                                                                                                               209
  4894-1               Mythical Creatures                                                                                                                                                                                                                                                      278
  
  SET_NUM              NAME                                                                                                                                                                                                                                                            GREEN_COUNT
  -------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------
  5868-1               Ferocious Creatures                                                                                                                                                                                                                                                     205
  2000409-1            Window Exploration Bag                                                                                                                                                                                                                                                  900
  21132-1              The Jungle Temple                                                                                                                                                                                                                                                       220
  4998-1               Stegosaurus                                                                                                                                                                                                                                                             243
  10243-1              Parisian Restaurant                                                                                                                                                                                                                                                     366
  2000430-1            Identity and Landscape Kit                                                                                                                                                                                                                                              212
  10185-1              Green Grocer                                                                                                                                                                                                                                                            320
  7194-1               Yoda                                                                                                                                                                                                                                                                    407
  10228-1              Haunted House                                                                                                                                                                                                                                                           319
  
  20 rows selected. 



------------------------------------------------------------------------------------------------------
2.    What are the oldest Scooby-Doo sets in the Lego data? 
 
-- Use DENSE_RANK() to get all oldest Scooby-Doo sets in case of ties
SET ECHO ON;
WITH ranked_sets AS (
  SELECT
    s.year,
    s.name,
    -- Rank sets by ascending year; ties get the same rank
    DENSE_RANK() OVER (ORDER BY s.year ASC) AS rank
  FROM sets s
  WHERE LOWER(s.name) LIKE '%scooby-doo%'
)

-- Select all sets with the oldest year (rank = 1)
SELECT year, name
FROM ranked_sets
WHERE rank = 1;


SQL> -- Use DENSE_RANK() to get all oldest Scooby-Doo sets in case of ties
SQL> SET ECHO ON;
SQL> 
SQL> WITH ranked_sets AS (
  2    SELECT
  3      s.year,
  4      s.name,
  5      -- Rank sets by ascending year; ties get the same rank
  6      DENSE_RANK() OVER (ORDER BY s.year ASC) AS rank
  7    FROM sets s
  8    WHERE LOWER(s.name) LIKE '%scooby-doo%'
  9  )
 10  
 11  -- Select all sets with the oldest year (rank = 1)
 12  SELECT year, name
 13  FROM ranked_sets
 14  WHERE rank = 1;

      YEAR NAME                                                                                                                                                                                                                                                           
---------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      2015 LEGOÂ® DIMENSIONSâ„¢ Scooby-Dooâ„¢ Team Pack                                                                                                                                                                                                                   




------------------------------------------------------------------------------------------------------
3. Find the average number of pieces in each Lego set (by year).
   Order the results from highest to lowest. Show only the 5 highest years.

    SET ECHO on;
    SELECT s.year, 
    round(AVG(s.num_parts),2) AS avg_num_parts
    FROM sets s
    GROUP BY s.year
    ORDER BY avg_num_parts DESC
    FETCH FIRST 5 ROWS ONLY;

   SQL> SET ECHO on;
  SQL>     SELECT s.year, 
    2      round(AVG(s.num_parts),2) AS avg_num_parts
    3      FROM sets s
    4      GROUP BY s.year
    5      ORDER BY avg_num_parts DESC
    6      FETCH FIRST 5 ROWS ONLY;

      YEAR AVG_NUM_PARTS
---------- -------------
      2017        260.82
      2016        253.08
      2006        246.83
      2008         231.6
      2007         227.6



  ------------------------------------------------------------------------------------------------------
4.  What are the Parts Categories with the highest percentage of spare parts compared to non-spare parts?
    Show the top 5 in descending order. Order by column number. Do not order by column name or alias. 

SET ECHO ON;
-- Calculate count of spare and non-spare parts per category
WITH parts_count AS (
    SELECT 
        pc.id, 
        pc.name,
        SUM(CASE WHEN ip.is_spare = 't' THEN 1 ELSE 0 END) AS spare_parts, 
        NULLIF(SUM(CASE WHEN ip.is_spare = 'f' THEN 1 ELSE 0 END), 0) AS non_spare_parts -- avoid divide-by-zero
    FROM inventory_parts ip
    LEFT JOIN parts p ON p.part_num = ip.part_num
    LEFT JOIN part_categories pc ON pc.id = p.part_cat_id  
    GROUP BY pc.id, pc.name
)
  
-- Calculate and show top 5 categories by spare-to-non-spare parts percentage
SELECT 
    id, 
    name, 
    100.00 * (spare_parts / non_spare_parts) AS spare_to_notspare_percent
FROM parts_count
ORDER BY 3 DESC -- order by percentage (column index)
FETCH FIRST 5 ROWS ONLY;



SQL> -- Calculate count of spare and non-spare parts per category
SQL> WITH parts_count AS (
  2      SELECT 
  3          pc.id, 
  4          pc.name,
  5          SUM(CASE WHEN ip.is_spare = 't' THEN 1 ELSE 0 END) AS spare_parts, 
  6          NULLIF(SUM(CASE WHEN ip.is_spare = 'f' THEN 1 ELSE 0 END), 0) AS non_spare_parts -- avoid divide-by-zero
  7      FROM inventory_parts ip
  8      LEFT JOIN parts p ON p.part_num = ip.part_num
  9      LEFT JOIN part_categories pc ON pc.id = p.part_cat_id  
 10      GROUP BY pc.id, pc.name
 11  )
 12    
 13  -- Calculate and show top 5 categories by spare-to-non-spare parts percentage
 14  SELECT 
 15      id, 
 16      name, 
 17      100.00 * (spare_parts / non_spare_parts) AS spare_to_notspare_percent
 18  FROM parts_count
 19  ORDER BY 3 DESC -- order by percentage (column index)
 20  FETCH FIRST 5 ROWS ONLY;

        ID NAME                                                                                                 SPARE_TO_NOTSPARE_PERCENT
---------- ---------------------------------------------------------------------------------------------------- -------------------------
        56 Tools                                                                                                                      195
        17 Non-LEGO                                                                                                            83.6162988
        54 Technic Bushes                                                                                                      62.7413858
        21 Plates Round and Dishes                                                                                             37.9233464
        22 Pneumatics                                                                                                          35.8606557




------------------------------------------------------------------------------------------------------
5.  Find the average number of pieces in each Lego set (by year). 
    Give the average number of pieces a meaningful alias. 
    Order the results from highest to lowest using the alias for the average number of pieces. 
    Show only the top 8 years. 

  SET ECHO ON;

-- Calculate average number of pieces per set by year
SET ECHO ON;
SELECT s.year, 
round(avg(num_parts),2) as avg_pieces
FROM sets s
INNER JOIN inventory i ON s.set_num = i.set_num
INNER JOIN inventory_parts ip ON i.id = ip.inventory_id
INNER JOIN colors c ON c.id = ip.color_id
GROUP BY s.year
ORDER BY avg_pieces DESC 
FETCH FIRST 8 ROWS ONLY;


  SQL> SET ECHO ON;
SQL> 
SQL> -- Calculate average number of pieces per set by year
SQL> SET ECHO ON;
SQL> SELECT s.year, 
  2  round(avg(num_parts),2) as avg_pieces
  3  FROM sets s
  4  INNER JOIN inventory i ON s.set_num = i.set_num
  5  INNER JOIN inventory_parts ip ON i.id = ip.inventory_id
  6  INNER JOIN colors c ON c.id = ip.color_id
  7  GROUP BY s.year
  8  ORDER BY avg_pieces DESC 
  9  FETCH FIRST 8 ROWS ONLY;

      YEAR AVG_PIECES
---------- ----------
      2016     721.29
      2008      695.6
      2007     669.38
      2017     621.58
      2015     606.02
      2010     591.57
      2014     589.52
      2006     558.14

8 rows selected. 


------------------------------------------------------------------------------------------------------            
 6. Create the query needed to answer: Which set has the most unique spare parts? 
    
    SET ECHO ON;
    SELECT s.set_num, s.name,
    COUNT(DISTINCT CASE WHEN ip.is_spare = 't' THEN ip.part_num END) AS unique_parts
    FROM inventory_parts ip
    LEFT JOIN inventory i ON ip.inventory_id = i.id
    LEFT JOIN sets s on s.set_num = i.set_num
    GROUP BY s.set_num, s.name
    ORDER BY unique_parts DESC
    FETCH FIRST 1 ROWS ONLY;


  SQL> SET ECHO ON;
  SQL>     SELECT s.set_num, s.name,
    2      COUNT(DISTINCT CASE WHEN ip.is_spare = 't' THEN ip.part_num END) AS unique_parts
    3      FROM inventory_parts ip
    4      LEFT JOIN inventory i ON ip.inventory_id = i.id
    5      LEFT JOIN sets s on s.set_num = i.set_num
    6      GROUP BY s.set_num, s.name
    7      ORDER BY unique_parts DESC
    8      FETCH FIRST 1 ROWS ONLY;
  
  SET_NUM              NAME                                                                                                                                                                                                                                                            UNIQUE_PARTS
  -------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------
  4696-1               Blue Bucket                                                                                                                                                                                                                                                              115



    
------------------------------------------------------------------------------------------------------
7.  Create the query to answer: Which theme has the most total parts across all sets?
    Show the name and the number of pieces. Show only the top theme (or themes if there is a tie) – not all. 
     
  -- since tie must use dense_rank() window function:
    SET ECHO ON;
    with set_parts as(
    SELECT t.id, t.name, sum(ip.quantity) as num_pieces 
    FROM inventory_parts ip 
    INNER JOIN inventory i ON i.id = ip.inventory_id
    INNER JOIN sets s ON i.set_num = s.set_num
    INNER JOIN themes t ON s.theme_id = t.id
    GROUP BY t.id, t.name
    ),
    rank_cte as(
    SELECT id, name, num_pieces,
    DENSE_RANK() OVER(ORDER BY num_pieces DESC) as ranked
    FROM set_parts
    )
    SELECT id, name, num_pieces, ranked
    FROM rank_cte
    WHERE ranked = 1;

SQL>   -- since tie must use dense_rank() window function:
SQL> SET ECHO ON;
SQL>     with set_parts as(
  2      SELECT t.id, t.name, sum(ip.quantity) as num_pieces 
  3      FROM inventory_parts ip 
  4      INNER JOIN inventory i ON i.id = ip.inventory_id
  5      INNER JOIN sets s ON i.set_num = s.set_num
  6      INNER JOIN themes t ON s.theme_id = t.id
  7      GROUP BY t.id, t.name
  8      ),
  9      
 10      rank_cte as(
 11      SELECT id, name, num_pieces,
 12      DENSE_RANK() OVER(ORDER BY num_pieces DESC) as ranked
 13      FROM set_parts
 14      )
 15      SELECT id, name, num_pieces, ranked
 16      FROM rank_cte
 17      WHERE ranked = 1;

        ID NAME                                                                                                 NUM_PIECES     RANKED
---------- ---------------------------------------------------------------------------------------------------- ---------- ----------
        37 Basic Set                                                                                                 69085          1


------------------------------------------------------------------------------------------------------
8.   What is/are the oldest sets in the Lego data WITH a Guardians of the Galaxy theme? 
     Show only the oldest set (or sets if there is a tie) – not all. 

    SET ECHO ON;
    WITH galaxy_cte AS (
        SELECT s.year, s.set_num, s.name,
        -- Assign a rank to each set based on year (oldest = rank 1)
        DENSE_RANK() OVER (ORDER BY year ASC) AS year_rank
        FROM sets s
        LEFT JOIN themes t ON s.theme_id = t.id
        WHERE t.name = 'Guardians of the Galaxy'
    )

    SELECT year, set_num, name, year_rank
    FROM galaxy_cte 
    WHERE year_rank = 1;


SQL> SET ECHO ON;
SQL>     WITH galaxy_cte AS (
  2          SELECT s.year, s.set_num, s.name,
  3          DENSE_RANK() OVER (ORDER BY year ASC) AS year_rank
  4          FROM sets s
  5          LEFT JOIN themes t ON s.theme_id = t.id
  6          WHERE t.name = 'Guardians of the Galaxy'
  7      )
  8      
  9      SELECT year, set_num, name, year_rank
 10      FROM galaxy_cte 
 11      WHERE year_rank = 1;

      YEAR SET_NUM              NAME                                                                                                                                                                                                                                                             YEAR_RANK
---------- -------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------
      2014 5002145-1            Rocket Raccoon                                                                                                                                                                                                                                                           1
      2014 76019-1              Starblaster Showdown                                                                                                                                                                                                                                                     1
      2014 76020-1              Knowhere Escape Mission                                                                                                                                                                                                                                                  1
      2014 76021-1              The Milano Spaceship Rescue                                                                                                                                                                                                                                              1
      2014 comcon034-1          Rocket Raccoonâ€™s Warbird                                                                                                                                                                                                                                              1
      2014 comcon035-1          The Collector - San Diego Comic-Con 2014 Exclusive                                                                                                                                                                                                                       1

6 rows selected. 



  ------------------------------------------------------------------------------------------------------
9.  For each THEME show the set with the most spare pieces. 
    Show the THEME, the SET NAME and the number of spare pieces in the set. 
    Sort in descending order, only show the top 6 THEMEs. 

     SET ECHO ON; 
     with spare_pieces as(
      --- Show the THEME, the SET NAME and the number of spare pieces in the set. 
     SELECT 
      t.name as theme_name, 
      s.name as set_name, 
     SUM(CASE WHEN ip.is_spare = 't' THEN 1 ELSE 0 END) as spare_parts
     FROM sets s
     LEFT JOIN themes t ON s.theme_id = t.id
     LEFT JOIN inventory i ON s.set_num = i.set_num
     LEFT JOIN inventory_parts ip ON i.id = ip.inventory_id
     GROUP BY  t.name, s.name
       ),

     -- For each THEME show the set with the most spare pieces.
      top_theme_names as (
       SELECT theme_name, set_name, spare_parts,
       row_number() OVER(PARTITION BY theme_name ORDER BY spare_parts DESC) as rn
       FROM spare_pieces
       )

      -- Sort in descending order, only show the top 6 THEMEs.
       SELECT theme_name, set_name, spare_parts, rn 
       FROM top_theme_names
       WHERE rn = 1
       ORDER BY spare_parts DESC
       FETCH FIRST 6 ROWS ONLY;


SQL> SET ECHO ON;
SQL>      with spare_pieces as(
  2        --- Show the THEME, the SET NAME and the number of spare pieces in the set. 
  3       SELECT 
  4        t.name as theme_name, 
  5        s.name as set_name, 
  6       SUM(CASE WHEN ip.is_spare = 't' THEN 1 ELSE 0 END) as spare_parts
  7       FROM sets s
  8       LEFT JOIN themes t ON s.theme_id = t.id
  9       LEFT JOIN inventory i ON s.set_num = i.set_num
 10       LEFT JOIN inventory_parts ip ON i.id = ip.inventory_id
 11       GROUP BY  t.name, s.name
 12         ),
 13  
 14       -- For each THEME show the set with the most spare pieces.
 15        top_theme_names as (
 16         SELECT theme_name, set_name, spare_parts,
 17         row_number() OVER(PARTITION BY theme_name ORDER BY spare_parts DESC) as rn
 18         FROM spare_pieces
 19         )
 20  
 21        -- Sort in descending order, only show the top 6 THEMEs.
 22         SELECT theme_name, set_name, spare_parts, rn 
 23         FROM top_theme_names
 24         WHERE rn = 1
 25         ORDER BY spare_parts DESC
 26         FETCH FIRST 6 ROWS ONLY;

THEME_NAME                                                                                           SET_NAME                                                                                                                                                                                                                                                        SPARE_PARTS         RN
---------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- ----------
Basic Set                                                                                            Creator Box                                                                                                                                                                                                                                                             167          1
Fire                                                                                                 Fire Station                                                                                                                                                                                                                                                             94          1
Modular Buildings                                                                                    Assembly Square                                                                                                                                                                                                                                                          94          1
Creator                                                                                              Mini Cooper                                                                                                                                                                                                                                                              86          1
Other                                                                                                Firehouse Headquarters                                                                                                                                                                                                                                                   70          1
Town                                                                                                 The Kwik-E-Mart                                                                                                                                                                                                                                                          66          1

6 rows selected. 


------------------------------------------------------------------------------------------------------
10. For each THEME show average number of pieces in each set. 
Show the THEME, the average number of pieces. Sort in descending order, only show the top 5 THEMEs.

SET ECHO ON;

-- Step 1: Calculate total pieces per individual set
WITH set_totals AS (
    SELECT 
        s.set_num,
        t.name AS theme_name,
        SUM(ip.quantity) AS total_pieces
    FROM sets s
    JOIN themes t ON s.theme_id = t.id
    JOIN inventory i ON s.set_num = i.set_num
    JOIN inventory_parts ip ON i.id = ip.inventory_id
    GROUP BY s.set_num, t.name
)

-- Step 2: For each theme, calculate the average pieces per set
SELECT 
    theme_name,
    ROUND(AVG(total_pieces), 2) AS avg_pieces
FROM set_totals
GROUP BY theme_name
ORDER BY avg_pieces DESC
FETCH FIRST 5 ROWS ONLY;  -- Show top 5 themes with highest average pieces per set


SQL> SET ECHO ON;
SQL> 
SQL> -- Step 1: Calculate total pieces per individual set
SQL> WITH set_totals AS (
  2      SELECT 
  3          s.set_num,
  4          t.name AS theme_name,
  5          SUM(ip.quantity) AS total_pieces
  6      FROM sets s
  7      JOIN themes t ON s.theme_id = t.id
  8      JOIN inventory i ON s.set_num = i.set_num
  9      JOIN inventory_parts ip ON i.id = ip.inventory_id
 10      GROUP BY s.set_num, t.name
 11  )
 12  
 13  -- Step 2: For each theme, calculate the average pieces per set
 14  SELECT 
 15      theme_name,
 16      ROUND(AVG(total_pieces), 2) AS avg_pieces
 17  FROM set_totals
 18  GROUP BY theme_name
 19  ORDER BY avg_pieces DESC
 20  FETCH FIRST 5 ROWS ONLY;

THEME_NAME                                                                                           AVG_PIECES
---------------------------------------------------------------------------------------------------- ----------
Modular Buildings                                                                                       2411.83
Sculptures                                                                                               1895.9
Mosaic                                                                                                  1844.88
Ultimate Collector Series                                                                                  1695
FIRST LEGO League                                                                                       1390.33

SQL>   -- Show top 5 themes with highest average pieces per set
