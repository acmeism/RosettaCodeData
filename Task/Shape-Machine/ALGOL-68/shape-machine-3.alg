BEGIN
    INT n; read( ( n, newline ) );
    SHORT REAL a      := n;
    SHORT REAL prev a := IF a = 0 THEN 1 ELSE 0 FI;
    INT  count  := 0;
    WHILE prev a /= a
    DO
        count +:= 1;
        prev a := a;
        print( ( fixed( a +:= 3 *:= 0.86, -9, 5 ), newline ) )
    OD;
    print( ( whole( count, 0 ), " repetitions" ) )
END
