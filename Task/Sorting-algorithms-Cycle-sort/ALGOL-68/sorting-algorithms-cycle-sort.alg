BEGIN # cycle sort - translated from the Action! sample                      #

    # prints the elements of a                                               #
    OP   SHOW = ( REF[]INT a )VOID:
         BEGIN
             print( ( "[" ) );
             FOR i FROM LWB a TO UPB a DO
                 print( ( " ", whole( a[ i ], 0 ) ) )
             OD;
             print( " ]" )
         END # SHOW # ;

    # swaps a and b                                                          #
    PRIO =:= = 1;
    OP   =:= = ( REF INT a, b )VOID: BEGIN INT t := a; a := b; b := t END;

    # cycle sorts a                                                          #
    PROC cycle sort = ( REF[]INT a )VOID:
         FOR start pos FROM LWB a TO UPB a - 1 DO
            INT item := a[ start pos ];
            INT pos  := start pos;
            FOR i FROM start pos + 1 TO UPB a DO
                IF a[ i ] < item THEN
                    pos +:= 1
                FI
            OD;
            IF pos /= start pos THEN
                item =:= a[ pos ];
                WHILE pos /= start pos DO
                    pos := start pos;
                    FOR i FROM start pos + 1 TO UPB a DO
                        IF a[ i ] < item THEN
                            pos +:= 1
                        FI
                    OD;
                    WHILE item = a[ pos ] DO
                        pos +:= 1
                    OD;
                    a[ pos ] =:= item
                OD
            FI
         OD # cycle sort # ;

    PROC test = ( REF[]INT a )VOID:
         BEGIN
             print( ( "Array before sort: " ) ); SHOW a; print( ( newline ) );
             cycle sort( a );
             print( ( "Array after  sort: " ) ); SHOW a; print( ( newline ) )
         END # test # ;

    BEGIN # tests                                                            #
        [ 10 ]INT a := []INT( 1, 4, -1, 0, 3, 7, 4, 8, 20, -6 );
        [ 21 ]INT b := []INT( 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
                            , -1, -2, -3, -4, -5, -6, -7, -8, -9, -10
                            );
        [  8 ]INT c := []INT( 101, 102, 103, 104, 105, 106, 107, 108 );
        [ 12 ]INT d := []INT( 1 ,-1, 1,-1, 1, -1, 1, -1, 1, -1, 1, -1 );

        test( a );
        test( b );
        test( c );
        test( d )
    END
END
