BEGIN # print some catalan numbers                                           #
    PROC print catalan = ( LONG INT n, cn )VOID:
         print( ( whole( n, -3 ), ": ", whole( cn, 0 ), newline ) );

    LONG INT cprev := 1; # C0 #
    print catalan( 0, cprev );
    FOR n TO 15 DO
        cprev := ROUND ( ( ( ( 4 * n ) - 2 ) / ( n + 1 ) ) * cprev );
        print catalan( n, cprev )
    OD
END
