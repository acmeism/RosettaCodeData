DIM a(1 TO 10, 1 TO 10) AS INTEGER
CLS
FOR row = 1 TO 10
        FOR col = 1 TO 10
                a(row, col) = INT(RND * 20) + 1
        NEXT col
NEXT row

FOR row = LBOUND(a, 1) TO UBOUND(a, 1)
        FOR col = LBOUND(a, 2) TO UBOUND(a, 2)
                PRINT a(row, col)
                IF a(row, col) = 20 THEN END
        NEXT col
NEXT row
