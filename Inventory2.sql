Scott Schmidt and Quin Soipas
IT378 Advanced Database, Illinois State University
Part 2 Creating and Loading the Kaggle Data (35 Points)
  

5.Use DDL to create the inventories, inventory_parts, parts, and sets tables
 
CREATE TABLE inventory (
    id        NUMBER PRIMARY KEY,
    version   NUMBER NOT NULL,
    set_num   VARCHAR2(20) NOT NULL
);

CREATE TABLE inventory_parts (
    inventory_id  NUMBER NOT NULL,
    part_num      VARCHAR2(30) NOT NULL,
    color_id      NUMBER NOT NULL,
    quantity      NUMBER NOT NULL,
    is_spare      CHAR(1) CHECK (is_spare IN ('f', 't')),
    CONSTRAINT fk_inventory
        FOREIGN KEY (inventory_id)
        REFERENCES inventory(id)
);

CREATE TABLE parts (
    part_num     VARCHAR2(30) PRIMARY KEY,
    name         VARCHAR2(255) NOT NULL,
    part_cat_id  NUMBER NOT NULL
);

CREATE TABLE sets (
    set_num    VARCHAR2(20) PRIMARY KEY,
    name       VARCHAR2(255) NOT NULL,
    year       NUMBER NOT NULL,
    theme_id   NUMBER NOT NULL,
    num_parts  NUMBER NOT NULL
);


6.Load the data from Kaggle.com into the inventories, inventory_parts, parts, and setstables
DONE.
7.Write the DDL needed to create the colors, part_categories, and themes tables.

  CREATE TABLE colors (
    id        NUMBER PRIMARY KEY,
    name      VARCHAR2(50) NOT NULL,
    rgb       CHAR(6) NOT NULL,
    is_trans  CHAR(1) CHECK (is_trans IN ('f', 't')) NOT NULL
);


CREATE TABLE part_categories (
    id    NUMBER PRIMARY KEY,
    name  VARCHAR2(100) NOT NULL
);


CREATE TABLE themes (
    id         NUMBER PRIMARY KEY,
    name       VARCHAR2(100) NOT NULL,
    parent_id  NUMBER,
    CONSTRAINT fk_parent_theme
        FOREIGN KEY (parent_id)
        REFERENCES themes(id)
);
  
8.Load the data from Kaggle.com into the colors, part_categories, and themes tables.
Done.

Note: All Primary Keys and Foreign Keys have already been created: 

 SQL> SET ECHO ON;
SQL> 
SQL> SELECT table_name,
  2         constraint_type,
  3         constraint_name
  4  FROM user_constraints
  5  WHERE table_name IN (
  6      'INVENTORY',
  7      'INVENTORY_PARTS',
  8      'PARTS',
  9      'SETS',
 10      'COLORS',
 11      'PART_CATEGORIES',
 12      'THEMES'
 13  )
 14  AND constraint_type IN ('P', 'R')  -- Only Primary Keys and Foreign Keys
 15  ORDER BY table_name, constraint_type;

TABLE_NAME                                                                                                                       C CONSTRAINT_NAME                                                                                                                 
-------------------------------------------------------------------------------------------------------------------------------- - --------------------------------------------------------------------------------------------------------------------------------
COLORS                                                                                                                           P SYS_C00454170                                                                                                                   
INVENTORY                                                                                                                        P SYS_C00454148                                                                                                                   
INVENTORY_PARTS                                                                                                                  R FK_INVENTORY                                                                                                                    
PARTS                                                                                                                            P SYS_C00454160                                                                                                                   
PART_CATEGORIES                                                                                                                  P SYS_C00454174                                                                                                                   
SETS                                                                                                                             P SYS_C00454165                                                                                                                   
THEMES                                                                                                                           P SYS_C00454176                                                                                                                   
THEMES                                                                                                                           R FK_PARENT_THEME                                                                                                                 
8 rows selected. 

 
9.Write the SQL needed to create all needed primary keys for each table.

See note at 8.5, all primary keys have already been created using a DDL.
However, this is how you would create a primary key if from scratch:

ALTER TABLE colors
ADD CONSTRAINT pk_colors
PRIMARY KEY (id);


10.Create all needed foreign keys. Please note that EVERY relationship in the aboveERD represents a foreign key.
The foreign keys were already created from the DDLs. To check I ran the query below:

See note at 8.5, all primary keys have already been created using a DDL.
However, this is how you would create a foreign key if from scratch:
 
ALTER TABLE child_table
ADD CONSTRAINT fk_constraint_name
FOREIGN KEY (child_column)
REFERENCES parent_table(parent_column);

 
11.SET ECHO ON and Run DESC on each table created for this project

SET ECHO ON;
DESC colors;
DESC themes;
DESC part_categories;
DESC parts;
DESC sets;
DESC inventory_parts;

SQL> SET ECHO ON;
SQL> 
SQL> DESC colors;
Name     Null?    Type         
-------- -------- ------------ 
ID       NOT NULL NUMBER       
NAME     NOT NULL VARCHAR2(50) 
RGB      NOT NULL CHAR(6)      
IS_TRANS NOT NULL CHAR(1)      
SQL> DESC themes;
Name      Null?    Type          
--------- -------- ------------- 
ID        NOT NULL NUMBER        
NAME      NOT NULL VARCHAR2(100) 
PARENT_ID          NUMBER        
SQL> DESC part_categories;
Name Null?    Type          
---- -------- ------------- 
ID   NOT NULL NUMBER        
NAME NOT NULL VARCHAR2(100) 
SQL> DESC parts;
Name        Null?    Type          
----------- -------- ------------- 
PART_NUM    NOT NULL VARCHAR2(30)  
NAME        NOT NULL VARCHAR2(255) 
PART_CAT_ID NOT NULL NUMBER        
SQL> DESC sets;
Name      Null?    Type          
--------- -------- ------------- 
SET_NUM   NOT NULL VARCHAR2(20)  
NAME      NOT NULL VARCHAR2(255) 
YEAR      NOT NULL NUMBER        
THEME_ID  NOT NULL NUMBER        
NUM_PARTS NOT NULL NUMBER        
SQL> DESC inventory_parts;
Name         Null?    Type         
------------ -------- ------------ 
INVENTORY_ID NOT NULL NUMBER       
PART_NUM     NOT NULL VARCHAR2(30) 
COLOR_ID     NOT NULL NUMBER       
QUANTITY     NOT NULL NUMBER       
IS_SPARE              CHAR(1)      


 

12.SET ECHO ON and Run SELECT * on each table created for this project.
 UseFORMAT and SET PAGESIZE as needed to improve the appearance of the results. 
 Showonly the first 10 rows from each table.

SET ECHO ON;
SET PAGESIZE 50;
SET LINESIZE 120;

-- COLORS
PROMPT === COLORS ===
SELECT * FROM colors WHERE ROWNUM <= 10;

-- THEMES
PROMPT === THEMES ===
SELECT * FROM themes WHERE ROWNUM <= 10;

-- PART_CATEGORIES
PROMPT === PART_CATEGORIES ===
SELECT * FROM part_categories WHERE ROWNUM <= 10;

-- PARTS
PROMPT === PARTS ===
SELECT * FROM parts WHERE ROWNUM <= 10;

-- SETS
PROMPT === SETS ===
SELECT * FROM sets WHERE ROWNUM <= 10;

-- INVENTORY_PARTS
PROMPT === INVENTORY_PARTS ===
SELECT * FROM inventory_parts WHERE ROWNUM <= 10;



SQL> SET ECHO ON;
SQL> SET PAGESIZE 50;
SQL> SET LINESIZE 120;
SQL> 
SQL> -- COLORS
SQL> PROMPT === COLORS ===
=== COLORS ===
SQL> SELECT * FROM colors WHERE ROWNUM <= 10;

        ID NAME                                               RGB    I
---------- -------------------------------------------------- ------ -
        -1 Unknown                                            0033B2 f
         0 Black                                              05131D f
         1 Blue                                               0055BF f
         2 Green                                              237841 f
         3 Dark Turquoise                                     008F9B f
         4 Red                                                C91A09 f
         5 Dark Pink                                          C870A0 f
         6 Brown                                              583927 f
         7 Light Gray                                         9BA19D f
         8 Dark Gray                                          6D6E5C f

10 rows selected. 

SQL> 
SQL> -- THEMES
SQL> PROMPT === THEMES ===
=== THEMES ===
SQL> SELECT * FROM themes WHERE ROWNUM <= 10;

        ID NAME
---------- ----------------------------------------------------------------------------------------------------
 PARENT_ID
----------
         1 Technic                                                                                              
          

         2 Arctic Technic                                                                                       
         1

         3 Competition                                                                                          
         1

         4 Expert Builder                                                                                       
         1

         5 Model                                                                                                
         1

         6 Airport                                                                                              
         5

         7 Construction                                                                                         
         5

         8 Farm                                                                                                 
         5

         9 Fire                                                                                                 
         5

        10 Harbor                                                                                               
         5
10 rows selected. 


         
SQL> 
SQL> -- PART_CATEGORIES
SQL> PROMPT === PART_CATEGORIES ===
=== PART_CATEGORIES ===
SQL> SELECT * FROM part_categories WHERE ROWNUM <= 10;

        ID NAME                                                                                                
---------- ----------------------------------------------------------------------------------------------------
         1 Baseplates                                                                                          
         2 Bricks Printed                                                                                      
         3 Bricks Sloped                                                                                       
         4 Duplo, Quatro and Primo                                                                             
         5 Bricks Special                                                                                      
         6 Bricks Wedged                                                                                       
         7 Containers                                                                                          
         8 Technic Bricks                                                                                      
         9 Plates Special                                                                                      
        10 Tiles Printed                                                                                       

10 rows selected. 

SQL> 
SQL> -- PARTS
SQL> PROMPT === PARTS ===
=== PARTS ===
SQL> SELECT * FROM parts WHERE ROWNUM <= 10;

PART_NUM
------------------------------
NAME
------------------------------------------------------------------------------------------------------------------------
PART_CAT_ID
-----------
1093                           
Lego Computer Interface A User's Guide (12059)                                                                          
         17

10a                            
Baseplate 24 x 32 with Squared Corners                                                                                  
          1

10b                            
Baseplate 24 x 32 with Rounded Corners                                                                                  
          1

10p01                          
Baseplate 24 x 32 with Dots Print [363 / 555]                                                                           
          1

10p02                          
Baseplate 24 x 32 with Dots Print [354 / 560-2]                                                                         
          1

10p03                          
Baseplate 24 x 32 with Dots Print [358]                                                                                 
          1

10p04                          
Baseplate 24 x 32 with Dots Print [345]                                                                                 
          1

10p05                          
Baseplate 24 x 32 with Dots Print [545-2 / 351]                                                                         
          1

10p06                          
Baseplate 24 x 32 with Dots Print [149]                                                                                 
          1

10p07                          
Baseplate 24 x 32 with Dots Print [346-2]                                                                               
          1


10 rows selected. 

SQL> 
SQL> -- SETS
SQL> PROMPT === SETS ===
=== SETS ===
SQL> SELECT * FROM sets WHERE ROWNUM <= 10;

SET_NUM
--------------------
NAME
------------------------------------------------------------------------------------------------------------------------
      YEAR   THEME_ID  NUM_PARTS
---------- ---------- ----------
10591-1              
Fire Boat                                                                                                               
      2015        504         19

10592-1              
Fire Truck                                                                                                              
      2015        504         26

10593-1              
Fire Station                                                                                                            
      2015        504        104

10594-1              
Sofia the Firstâ„¢ Royal Stable                                                                                         
      2015        504         38

10595-1              
Sofia the Firstâ„¢ Royal Castle                                                                                         
      2015        504         87

10596-1              
Disney Princessâ„¢ Collection                                                                                           
      2015        504         63

10597-1              
Mickey & Minnie Birthday Parade                                                                                         
      2015        504         24

10599-1              
Batman Adventure                                                                                                        
      2015        504         46

10600-1              
Disney â€¢ Pixar Carsâ„¢ Classic Race                                                                                   
      2015        506         29

1060-1               
Road Plates and Signs                                                                                                   
      1981        533         30


10 rows selected. 

SQL> 
SQL> -- INVENTORY_PARTS
SQL> PROMPT === INVENTORY_PARTS ===
=== INVENTORY_PARTS ===
SQL> SELECT * FROM inventory_parts WHERE ROWNUM <= 10;

INVENTORY_ID PART_NUM                         COLOR_ID   QUANTITY I
------------ ------------------------------ ---------- ---------- -
          38 3029                                    1          7 f
          38 3030                                   72          2 f
          38 3031                                   14          1 f
          38 3031                                   70          1 f
          38 3031                                   19          3 f
          38 3031                                   15          4 f
          38 3032                                   70          1 f
          38 3032                                    4          4 f
          38 3033                                   72          1 f
          38 3034                                   19          2 f

10 rows selected. 
