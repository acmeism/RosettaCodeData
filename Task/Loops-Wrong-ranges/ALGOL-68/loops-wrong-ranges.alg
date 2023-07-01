BEGIN
    # returns the first n elements of the sequences of values specified by start, stop and increment #
    PROC sequence = ( INT n, start, stop, increment )[]INT:
         BEGIN
            [ 1 : n ]INT s;
            FOR j FROM LWB s TO UPB s DO s[ j ] := 0 OD;
            INT s pos := LWB s - 1;
            FOR j FROM start BY increment TO stop WHILE s pos < n DO
               s[ s pos +:= 1 ] := j
            OD;
            s[ LWB s : s pos ]
         END # sequence # ;

    # tests the sequence procedure #
    PROC test sequence = ( INT start, stop, increment, STRING legend )VOID:
         BEGIN
            []INT s = sequence( 10, start, stop, increment );
            print( ( legend, ": " ) );
            FOR i FROM LWB s TO UPB s DO print( ( " ", whole( s[ i ], -4 ) ) ) OD;
            print( ( newline ) )
         END # test sequence # ;
    # task trest cases #

    test sequence( -2,  2,  1, "Normal                                     " );
    test sequence( -2,  2,  0, "Zero increment                             " );
    test sequence( -2,  2, -1, "Increments away from stop value            " );
    test sequence( -2,  2, 10, "First increment is beyond stop value       " );
    test sequence(  2, -2,  1, "Start more than stop: positive increment   " );
    test sequence(  2,  2,  1, "Start equal stop: positive increment       " );
    test sequence(  2,  2, -1, "Start equal stop: negative increment       " );
    test sequence(  2,  2,  0, "Start equal stop: zero increment           " );
    test sequence(  0,  0,  0, "Start equal stop equal zero: zero increment" )

END
