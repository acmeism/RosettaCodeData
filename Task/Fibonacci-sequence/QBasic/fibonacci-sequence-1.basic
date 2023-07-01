FUNCTION itFib (n)
    n1 = 0
    n2 = 1
    FOR k = 1 TO ABS(n)
        sum = n1 + n2
        n1 = n2
        n2 = sum
    NEXT k
    IF n < 0 THEN
        itFib = n1 * ((-1) ^ ((-n) + 1))
    ELSE
        itFib = n1
    END IF
END FUNCTION
