BEGIN # draw an Archimedian spiral using ASCII art                           #
      # Translation of Applesoft Basic via AWK and Algol W                   #
    PROC max = ( INT x, y )INT: IF x > y THEN x ELSE y FI;
    PROC min = ( INT x, y )INT: IF x < y THEN x ELSE y FI;
    [ 1 : 255, 1 : 255 ]CHAR arr;
    FOR i FROM 1 LWB arr TO 1 UPB arr DO
        FOR j FROM 2 LWB arr TO 2 UPB arr DO arr[ i, j ] := " " OD
    OD;
    INT x min := 1 UPB arr + 1, y min := 2 UPB arr + 1;
    INT x max := 1 LWB arr - 1, y max := 2 LWB arr - 1;
    REAL m  = 6 * pi, h  = 96, s  = 0.02;
    REAL w  = 1.5 * h;
    REAL t := s;
    WHILE t <= m DO                                           # build spiral #
        REAL r = t + 1;
        INT  x = ROUND ( r * cos( t ) + w );
        INT  y = ROUND ( r * sin( t ) + h );
        IF   x >= 1 LWB arr AND y >= 2 LWB arr
        AND  x <= 1 UPB arr AND y <= 2 UPB arr
        THEN
            arr[ x, y ] := "*";
            x min := min( x min, x );
            x max := max( x max, x );
            y min := min( y min, y );
            y max := max( y max, y );
        FI;
        t +:= s
    OD;
    FOR i FROM x min TO x max DO                              # print spiral #
        FOR j FROM y min TO y max DO
            CHAR c = arr[ i, j ];
            print( ( c, c ) )
        OD;
        print( ( newline ) )
    OD
END
