BEGIN # Modified random distribution - translation of the Wren sample #

    next random; # initialise the random number generator #

    PROC rng = ( PROC(REAL)REAL modifier fn )REAL:
         BEGIN
            REAL r1, r2;
            WHILE
                r1 := random;
                r2 := random;
                r2 >= modifier fn( r1 )
            DO SKIP OD;
            r1
         END # rng # ;

    PROC modifier = ( REAL x )REAL: 2 * ABS ( 0.5 - x );

    INT  n              = 100 000;
    INT  num bins       = 21;
    REAL bin size       = 1 / num bins;
    CHAR hist char      = "#";
    INT  hist char size = 125;
    [ 0 : num bins - 1 ]INT  bins ; FOR i FROM LWB bins TO UPB bins DO bins[ i ] := 0 OD;
    FROM 0 TO n DO
        bins[ ENTIER ( rng( modifier ) / bin size ) ] +:= 1
    OD;

    PROC f2 = ( REAL v )STRING:        # formatting routine #
         BEGIN
            STRING result := fixed( ABS v, 0, 2 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            IF v < 0 THEN "-" +=: result FI;
            result
         END # FMT # ;

    print( ( "Modified random distribution with ", whole( n, 0 ), " samples in range [0, 1):", newline ) );
    print( ( "    Range       Number of samples within that range", newline ) );
    FOR i FROM LWB bins TO UPB bins DO
        STRING hist = hist char * ROUND ( bins[ i ] / hist char size );
        print( ( f2( bin size * i ), " ..< " ) );
        print( ( f2( bin size * ( i + 1 ) ), "  ", whole( bins[ i ], -5 ), " ", hist, newline ) )
    OD

END
