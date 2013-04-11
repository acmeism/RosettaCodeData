DECLARE FUNCTION fibonacci& (n AS INTEGER)

REDIM SHARED fibNum(1) AS LONG

fibNum(1) = 1

'*****sample inputs*****
PRINT fibonacci(0)      'no calculation needed
PRINT fibonacci(13)     'figure F(2)..F(13)
PRINT fibonacci(-42)    'figure F(14)..F(42)
PRINT fibonacci(47)     'error: too big
'*****sample inputs*****

FUNCTION fibonacci& (n AS INTEGER)
    DIM a AS INTEGER
    a = ABS(n)
    SELECT CASE a
        CASE 0 TO 46
            SHARED fibNum() AS LONG
            DIM u AS INTEGER, L0 AS INTEGER
            u = UBOUND(fibNum)
            IF a > u THEN
                REDIM PRESERVE fibNum(a) AS LONG
                FOR L0 = u + 1 TO a
                    fibNum(L0) = fibNum(L0 - 1) + fibNum(L0 - 2)
                NEXT
            END IF
            IF n < 0 THEN
                fibonacci = fibNum(a) * ((-1) ^ (a + 1))
            ELSE
                fibonacci = fibNum(n)
            END IF
        CASE ELSE
            'limited to signed 32-bit int (LONG)
            'F(47)=&hB11924E1
            ERROR 6 'overflow
    END SELECT
END FUNCTION
