BEGIN
    LONG INT n := 0;
    TO 8 DO
        LONG INT n3 = ( n * 10 ) + 3;
        print( ( whole( n3, 0 ), " ", whole( n3 * n3, 0 ), newline ) );
        n *:= 10 +:= 1
    OD
END
