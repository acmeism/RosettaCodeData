BEGIN
    REAL a := BEGIN INT n; read( n ); n END;
    DO
        print( ( fixed( a +:= 3 *:= 0.86, -16, 14 ), newline ) )
    OD
END
