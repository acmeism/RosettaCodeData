BEGIN # model Abelian sandpiles #
    # returns TRUE if the sandpile s is stable, FALSE otherwise #
    OP STABLE = ( [,]INT s )BOOL:
       BEGIN
           BOOL result := TRUE;
           FOR i FROM 1 LWB s TO 1 UPB s WHILE result DO
               FOR j FROM 2 LWB s TO 2 UPB s WHILE result := s[ i, j ] < 4 DO SKIP OD
           OD;
           result
       END # STABLE # ;
    # returns the sandpile s after avalanches #
    OP AVALANCHE = ( [,]INT s )[,]INT:
       BEGIN
           [ 1 : 1 UPB s, 1 : 2 UPB s ]INT result := s[ AT 1, AT 1 ];
           WHILE BOOL had avalanche := FALSE;
                 FOR i TO 1 UPB s DO
                     FOR j TO 2 UPB s DO
                         IF result[ i, j ] >= 4 THEN
                             # unstable pile #
                             had avalanche := TRUE;
                             result[ i, j ] -:= 4;
                             IF i > 1       THEN result[ i - 1, j     ] +:= 1 FI;
                             IF i < 1 UPB s THEN result[ i + 1, j     ] +:= 1 FI;
                             IF j > 1       THEN result[ i,     j - 1 ] +:= 1 FI;
                             IF j < 2 UPB s THEN result[ i,     j + 1 ] +:= 1 FI
                         FI
                     OD
                 OD;
                 had avalanche
           DO SKIP OD;
           result
       END # AVALANCHE # ;
    # returns the maximum element of s #
    OP   MAX = ( [,]INT s )INT:
         BEGIN
            INT result := s[ 1 LWB s, 2 LWB s ];
            FOR i FROM 1 LWB s TO 2 UPB s DO
                FOR j FROM 2 LWB s TO 2 UPB s DO
                    IF s[ i, j ] > result THEN result := s[ i, j ] FI
                OD
            OD;
            result
         END # MAX # ;
    # prints the sandpile s #
    PROC show sandpile = ( STRING title, [,]INT s )VOID:
    BEGIN
        print( ( title, newline ) );
        IF 1 UPB s >= 1 LWB s AND 2 UPB s >= 2 LWB s THEN
            # non-empty sandpile #
            INT width := 1; # find tthe width needed for each element #
            INT v     := MAX s;
            WHILE v > 9 DO
                v OVERAB 10;
                width +:= 1
            OD;
            FOR i TO 1 UPB s DO
                FOR j TO 2 UPB s DO
                    print( ( " ", whole( s[ i, j ], - width ) ) )
                OD;
                print( ( newline ) )
            OD
        FI
    END # show sandpile # ;
    # printys a sandpile before and after the avalanches #
    PROC show sandpile before and after = ( [,]INT s )VOID:
         BEGIN
             [ 1 LWB s : 1 UPB s, 2 LWB s : 2 UPB s ]INT t := s;
             show sandpile( "before: ", t );
             WHILE NOT STABLE t DO
                 t := AVALANCHE t
             OD;
             show sandpile( "after: ", t );
             print( ( newline ) )
         END # show sandpile before and after # ;
    # task test case #
    [,]INT s1 = ( (  0,  0,  0,  0,  0 )
                , (  0,  0,  0,  0,  0 )
                , (  0,  0, 16,  0,  0 )
                , (  0,  0,  0,  0,  0 )
                , (  0,  0,  0,  0,  0 )
                );
    show sandpile before and after( s1 );
    # test case from 11l, C, etc. #
    [ 1 : 10, 1 : 10 ]INT s2;
    FOR i FROM 1 LWB s2 TO 1 UPB s2 DO
        FOR j FROM 2 LWB s2 TO 2 UPB s2 DO
            s2[ i, j ] := 0
        OD
    OD;
    s2[ 6, 6 ] := 64;
    show sandpile before and after( s2 )
END
