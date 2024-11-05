BEGIN # show some valuies of the Padovan n-step number sequences  #
    # returns an array with the elements set to the elements of   #
    # the Padovan sequences from 2 to max s & elements 1 to max e #
    # max s must be >= 2                                          #
    PROC padovan sequences = ( INT max s, max e )[,]INT:
         BEGIN
            PRIO MIN = 1;
            OP   MIN = ( INT a, b )INT: IF a < b THEN a ELSE b FI;
            # sequence 2                                          #
            [ 2 : max s, 1 : max e ]INT r;
            FOR x TO max e MIN 3 DO r[ 2, x ] := 1 OD;
            FOR x FROM 4 TO max e DO r[ 2, x ] := r[ 2, x - 2 ] + r[ 2, x - 3 ] OD;
            # sequences 3 and above                               #
            FOR n FROM 3 TO max s DO
                FOR x TO max e MIN n + 1 DO r[ n, x ] := r[ n - 1, x ] OD;
                FOR x FROM n + 2 TO max e DO
                    r[ n, x ] := 0;
                    FOR p FROM x - n - 1 TO x - 2 DO r[ n, x ] +:= r[ n, p ] OD
                OD
            OD;
            r
         END # padovan sequences # ;
    # calculate and show the sequences                            #
    [,]INT ps = padovan sequences( 8, 15 );
    print( ( "Padovan n-step sequences:", newline ) );
    FOR n FROM 1 LWB ps TO 1 UPB ps DO
        print( ( whole( n, 0 ), " |" ) );
        FOR x FROM 2 LWB ps TO 2 UPB ps DO print( ( " ", whole( ps[ n, x ], -3 ) ) ) OD;
        print( ( newline ) )
    OD
END
