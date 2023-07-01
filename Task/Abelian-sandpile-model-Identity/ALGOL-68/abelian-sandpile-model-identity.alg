BEGIN # model Abelian sandpiles #
    # represents a sandpile #
    INT elements = 3;
    MODE SANDPILE = [ 1 : elements, 1 : elements ]INT;
    # returns TRUE if the sandpiles a and b have the same values, FALSE otherwise #
    OP = = ( SANDPILE a, b )BOOL:
    BEGIN
        BOOL result := TRUE;
        FOR i TO elements WHILE result DO
            FOR j TO elements WHILE ( result := a[ i, j ] = b[ i, j ] ) DO SKIP OD
        OD;
        result
    END # = # ;
    # returns TRUE if the sandpile s is stable, FALSE otherwise #
    OP STABLE = ( SANDPILE s )BOOL:
       BEGIN
           BOOL result := TRUE;
           FOR i TO elements WHILE result DO
               FOR j TO elements WHILE result := s[ i, j ] < 4 DO SKIP OD
           OD;
           result
       END # STABLE # ;
    # returns the sandpile s after avalanches #
    OP AVALANCHE = ( SANDPILE s )SANDPILE:
       BEGIN
           SANDPILE result := s;
           WHILE BOOL had avalanche := FALSE;
                 FOR i TO elements DO
                     FOR j TO elements DO
                         IF result[ i, j ] >= 4 THEN
                             # unstable pile #
                             had avalanche := TRUE;
                             result[ i, j ] -:= 4;
                             IF i > 1        THEN result[ i - 1, j     ] +:= 1 FI;
                             IF i < elements THEN result[ i + 1, j     ] +:= 1 FI;
                             IF j > 1        THEN result[ i,     j - 1 ] +:= 1 FI;
                             IF j < elements THEN result[ i,     j + 1 ] +:= 1 FI
                         FI
                     OD
                 OD;
                 had avalanche
           DO SKIP OD;
           result
       END # AVALANCHE # ;
    # returns the result of adding the sandpile b to a, handling avalanches #
    OP + = ( SANDPILE a, b )SANDPILE:
    BEGIN
        SANDPILE result;
        FOR i TO elements DO
            FOR j TO elements DO result[ i, j ] := a[ i, j ] + b[ i, j ] OD
        OD;
        # handle avalanches #
        AVALANCHE result
    END # + # ;
    # prints the sandpile s #
    PROC show sandpile = ( STRING title, SANDPILE s )VOID:
    BEGIN
        print( ( title, newline ) );
        FOR i TO elements DO
            FOR j TO elements DO
                print( ( " ", whole( s[ i, j ], 0 ) ) )
            OD;
            print( ( newline ) )
        OD
    END # show sandpile # ;
    # task test cases #
    SANDPILE us    = ( ( 4, 3, 3 )
                     , ( 3, 1, 2 )
                     , ( 0, 2, 3 )
                     );
    SANDPILE s1    = ( ( 1, 2, 0 )
                     , ( 2, 1, 1 )
                     , ( 0, 1, 3 )
                     );
    SANDPILE s2    = ( ( 2, 1, 3 )
                     , ( 1, 0, 1 )
                     , ( 0, 1, 0 )
                     );
    SANDPILE s3    = ( ( 3, 3, 3 )
                     , ( 3, 3, 3 )
                     , ( 3, 3, 3 )
                     );
    SANDPILE s3_id = ( ( 2, 1, 2 )
                     , ( 1, 0, 1 )
                     , ( 2, 1, 2 )
                     );
    SANDPILE t := us;
    WHILE NOT STABLE t DO
        show sandpile( "unstable:", t );
        t := AVALANCHE t
    OD;
    show sandpile( "stable: ", t );
    print( ( newline ) );
    show sandpile( "s1:", s1 );
    show sandpile( "s2:", s2 );
    show sandpile( "s1 + s2:", s1 + s2 );
    show sandpile( "s2 + s1:", s2 + s1 );
    print( ( newline ) );
    show sandpile( "s3:", s3 );
    show sandpile( "s3_id:", s3_id );
    print( ( newline ) );
    print( ( "s3 + s3_id = s3 is ", IF s3 + s3_id = s3 THEN "TRUE" ELSE "FALSE" FI, newline ) );
    show sandpile( "s3 + s3_id", s3 + s3_id );
    print( ( "s3_id + s3 = s3 is ", IF s3 + s3_id = s3 THEN "TRUE" ELSE "FALSE" FI, newline ) );
    show sandpile( "s3_id + s3", s3_id + s3 );
    show sandpile( "s3_id + s3_id:", s3_id + s3_id )

END
