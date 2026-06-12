BEGIN # solve equations using the substitution method - translation of Phix  #

    PROC solve2 = ( []REAL e1, e2 )[]REAL:
         BEGIN
             REAL a1 = e1[ 1 ], b1 = e1[ 2 ], c1 = e1[ 3 ];
             REAL a2 = e2[ 1 ], b2 = e2[ 2 ], c2 = e2[ 3 ];
             REAL x  = (b2*c1 - b1*c2) / (b2*a1 - b1*a2);
             REAL y  = (a1*x - c1)/-b1;
             ( x, y )
         END # solve2 # ;

   OP   FMT = ( REAL v )STRING:     # prints v with at most 3 decimal places #
         BEGIN
            STRING result := fixed( ABS v, 0, 3 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" ELSE "" FI + result
         END # FMT # ;

    []REAL xy = solve2( ( 3, 1, -1 ), ( 2, -3, -19 ) );
    print( ( "x = ", FMT xy[ 1 ], ", y = ", FMT xy[ 2 ], newline ) )

END
