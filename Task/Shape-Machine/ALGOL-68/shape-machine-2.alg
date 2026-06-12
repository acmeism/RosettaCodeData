BEGIN
    REAL a      := BEGIN INT n; read( n ); n END;
    REAL prev a := IF a = 0 THEN 1 ELSE 0 FI;
    INT  count  := 0;
    WHILE prev a /= a
    DO
        count +:= 1;
        prev a := a;
        print( ( fixed( a +:= 3 *:= 0.86, -16, 14 ), newline ) )
    OD;
    print( ( whole( count, 0 ), " repetitions" ) )
END
