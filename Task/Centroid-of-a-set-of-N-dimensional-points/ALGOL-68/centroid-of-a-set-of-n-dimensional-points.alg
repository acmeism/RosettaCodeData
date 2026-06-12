BEGIN # find the centroid of some N-dimensional points                       #

    # returns the centroid of points                                         #
    OP   CENTROID = ( [,]REAL points )[]REAL:
         BEGIN
            INT number of points = ( 1 UPB points - 1 LWB points ) + 1;
            [ 2 LWB points : 2 UPB points ]REAL result;
            FOR j FROM 2 LWB points TO 2 UPB points DO
                REAL sum := 0;
                FOR i FROM 1 LWB points TO 1 UPB points DO sum +:= points[ i, j ] OD;
                result[ j ] := sum / number of points
            OD;
            result
         END # CENTROID # ;

    OP   A         = ( INT  v )[]REAL: v;              # coerces v to []REAL #
    OP   FMT       = ( REAL v )STRING:     # formsts v with up to 2 decimals #
         BEGIN
            STRING result := fixed( v, -0, 2 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            " " + result
         END # FMT # ;
    OP   SHOW      = ( []REAL v )VOID:      # show a 1D array (row) of reals #
         BEGIN
            print( ( "[" ) );
            FOR i FROM LWB v TO UPB v DO print( ( FMT v[ i ] ) ) OD;
            print( ( " ]" ) )
         END # SHOW # ;
    OP   SHOW      = ( [,]REAL v )VOID:           # show a 2D array of reals #
         BEGIN
            print( ( "[" ) );
            FOR i FROM 1 LWB v TO 1 UPB v DO SHOW v[ i, : ] OD;
            print( ( "]" ) )
         END # SHOW # ;

    # task test cases                                                        #

    PROC test = ( [,]REAL points )VOID:         # test the CENTROID operator #
         BEGIN SHOW          points; print( ( "   -> " ) );
               SHOW CENTROID points; print( ( newline ) )
         END # test # ;

    test( ( A(1), A(2), A(3) ) );
    test( ( ( 8, 2 ), ( 0, 0 ) ) );
    test( ( ( 5, 5, 0 ), ( 10, 10, 0 ) ) );
    test( ( (  1, 3.1, 6.5 ), ( -2, -5, 3.4 )
          , ( -7,  -4, 9   ), (  2,  0,   3 )
          )
        );
    test( ( ( 0, 0, 0, 0, 1 ), ( 0, 0, 0, 1, 0 )
          , ( 0, 0, 1, 0, 0 ), ( 0, 1, 0, 0, 0 )
          )
        )

END
