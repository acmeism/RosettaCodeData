DIM i             AS Integer
DIM row           AS Integer
DIM nrows         AS Integer
DIM values(100)   AS Integer

INPUT "Number of rows: "; nrows
values(1) = 1
PRINT TAB((nrows)*3);"  1"
FOR row = 2 TO nrows
    PRINT TAB((nrows-row)*3+1);
    FOR i = row TO 1 STEP -1
        values(i) = values(i) + values(i-1)
        PRINT USING "##### "; values(i);
    NEXT i
    PRINT
NEXT row
