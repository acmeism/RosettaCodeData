BEGIN # show the minimum number of cells above, below, before and after each #
      # cell in a suare matrix                                               #

    PROC min = ( INT a, b )INT: IF a < b THEN a ELSE b FI;

    PROC print min cells = ( INT n )VOID:
         BEGIN
            # deduce how many digits we need to show so the counts are all   #
            # the same width                                                 #
            INT w = BEGIN
                        INT width := 1, v := ( ( n - ( ABS NOT ODD n ) ) OVER 2 );
                        WHILE v > 9 DO v OVERAB 10; width +:= 1 OD;
                        width
                    END;
            print( ( "Minimum number of cells after, before, above and below "
                   , whole( n, 0 )
                   , " x "
                   , whole( n, 0 )
                   , " square:"
                   , newline
                   )
                 );
            FOR r FROM 0 TO n - 1 DO
                FOR c FROM 0 TO n - 1 DO print( ( whole( min( n-r-1, min( r, min( c, n-c-1 ) ) ), -w ), " " ) ) OD;
                print( ( newline ) )
            OD
         END # print min cells # ;

    []INT tests = ( 10, 9, 2, 1, 21 );
    FOR i FROM LWB tests TO UPB tests DO
        print min cells( tests[ i ] );
        print( ( newline ) )
    OD

END
