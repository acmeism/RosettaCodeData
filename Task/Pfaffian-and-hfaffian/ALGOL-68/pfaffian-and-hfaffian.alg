BEGIN # Pfaffian and Hfaffian of a matrix                                    #

    # returns the number of elements of a                                    #
    PRIO LEN = 9;
    OP   LEN = ( INT d, [,]REAL a )INT: ( d UPB a - d LWB a ) + 1;

    # returns TRUE if a is antisymetric, FALSE otherwise                     #
    OP   ANTISYMETRIC = ( [,]REAL a )BOOL:
         IF   1 LEN a /= 2 LEN a
         THEN FALSE # the array is not square                                #
         ELSE BOOL result := TRUE;
              FOR i FROM 1 LWB a TO 1 UPB a WHILE result DO
                  result := a[ i, i ] = 0;
                  FOR j FROM 2 LWB a TO 2 UPB a WHILE result DO
                      IF i /= j THEN result := a[ i, j ] = - a[ j, i ] FI
                  OD
              OD;
              result
         FI # ANTISYMETRIC # ;

    # MODE to hold the results of Pfaffian and Hfaffian calculation          #
    MODE PHV = STRUCT( REAL pf, hf, BOOL valid, STRING message );

    # Computes the Pfaffian and Hfaffian of a 2n x 2n antisymmetric matrix.  #
    PROC faffian = ( [,]REAL a )PHV:
         IF   STRING xaffian name = "Pfaffian/Hfaffian";
              INT m = 1 LEN a;
              ODD m
         THEN ( 0, 0, FALSE, "Matrix size must be even for " + xaffian name )
         ELIF 2 LEN a /= m
         THEN ( 0, 0, FALSE, "Matrix must be square for " + xaffian name )
         ELIF NOT ANTISYMETRIC a
         THEN ( 0, 0, FALSE, "The " + xaffian name + " does not yet support non-antisymmetric matrices." )
         ELSE INT n = m OVER 2;
              INT  factorial n   = BEGIN INT f := 1;
                                         FOR i FROM 2 TO n DO f *:= i OD;
                                         f
                                   END;
              INT  factorial m   = BEGIN INT f := factorial n;
                                         FOR i FROM n + 1 TO m DO f *:= i OD;
                                         f
                                   END;
              REAL normalization = 1 / ( ( 2 ^ n ) * factorial n );
              REAL sumh := 0, sump := 0;
              [ 1 : factorial m, 1 : m ]INT perms;
              [ 1 : factorial m        ]INT signs;

              BEGIN # populate perms and signs                               #
                  [ 1 : m ]INT p; FOR i TO m DO p[ i ] := i OD;
                  INT idx := 1, count := 0;

                  WHILE FOR j TO m DO perms[ idx, j ] := p[ j ] OD;
                        signs[ idx ] := IF ODD count THEN -1 ELSE 1 FI;
                        idx +:= 1;
                        INT i := m - 1;
                        WHILE IF i <= 0 THEN FALSE ELSE p[ i ] >= p[ i + 1 ] FI DO i -:= 1 OD;
                        i /= 0
                  DO    INT j := m;
                        WHILE p[ j ] <= p[ i ] DO j -:= 1 OD;
                        BEGIN INT t = p[ i ]; p[ i ] := p[ j ]; p[ j ] := t END;
                        count +:= 1;
                        INT k := i + 1, l := m;
                        WHILE k < l DO
                            INT t = p[ k ]; p[ k ] := p[ l ]; p[ l ] := t;
                            count +:= 1;
                            k     +:= 1;
                            l     -:= 1
                        OD
                  OD
              END;
              FOR p pos TO factorial m DO
                  REAL prod := 1;
                  FOR i TO n DO
                      prod *:= a[ perms[ p pos, ( 2 * i ) - 1 ], perms[ p pos, 2 * i ] ]
                  OD;
                  sumh +:= prod;
                  sump +:= signs[ p pos ] * prod
              OD;
              ( sump * normalization, sumh * normalization, TRUE, "" )
         FI # faffian # ;

    # tests the PFAFFIAN and HFAFFIAN operators                              #
    PROC test = ( STRING legend, [,]REAL a )VOID:
         BEGIN
            OP   SHOW = ( []REAL v )VOID:   # show a 1D array (row) of reals #
                 BEGIN
                    print( ( "[" ) );
                    FOR i FROM LWB v TO UPB v DO print( ( fixed( v[ i ], -4, 0 ) ) ) OD;
                    print( ( " ]" ) )
                 END # SHOW # ;
            OP   SHOW = ( [,]REAL v )VOID:        # show a 2D array of reals #
                 BEGIN
                    print( ( "[" ) );
                    STRING prefix := " ";
                    FOR i FROM 1 LWB v TO 1 UPB v DO
                        print( ( prefix ) ); SHOW v[ i, : ]; print( ( newline ) );
                        prefix := "  "
                    OD;
                    print( ( "]", newline ) )
                 END # SHOW # ;

             print( ( legend, newline ) );
             SHOW a;
             PHV ph = faffian( a );
             print( ( "    Pfaffian: "
                    , IF   NOT valid OF ph
                      THEN message OF ph
                      ELSE fixed( pf OF ph, -8, 1 )
                      FI
                    , newline
                    )
                  );
             print( ( "    Hfaffian: "
                    , IF   NOT valid OF ph
                      THEN message OF ph
                      ELSE fixed( hf OF ph, -8, 1 )
                      FI
                    , newline
                    )
                  );
             print( ( newline ) )
         END # test # ;

    BEGIN                                                            # tests #
        test( "Tiny matrix (2 x 2).",  ( (  0,  1 ) , ( -1,  0 ) ) );
        test( "Small matrix (4 x 4).", ( (  0,  1, -1,  2 )
                                       , ( -1,  0,  3, -4 )
                                       , (  1, -3,  0,  5 )
                                       , ( -2,  4, -5,  0 )
                                       )
            );
        test( "Symmetric matrix (6 x 6).", ( (  1,  2,  3,  4,  5,  6 )
                                           , (  2,  7,  8,  9, 10, 11 )
                                           , (  3,  8, 12, 13, 14, 15 )
                                           , (  4,  9, 13, 16, 17, 18 )
                                           , (  5, 10, 14, 17, 19, 20 )
                                           , (  6, 11, 15, 18, 20, 21 )
                                           )
            );

        test( "Larger matrix (10 x 10)."
            , ( (  0,  1,  2,  3,  4,  5,  6,  7,  8,  9 )
              , ( -1,  0,  8,  7,  6,  5,  4,  3,  2,  1 )
              , ( -2, -8,  0,  1,  2,  3,  4,  5,  6,  7 )
              , ( -3, -7, -1,  0,  6,  5,  4,  3,  2,  1 )
              , ( -4, -6, -2, -6,  0,  1,  2,  3,  4,  5 )
              , ( -5, -5, -3, -5, -1,  0,  4,  3,  2,  1 )
              , ( -6, -4, -4, -4, -2, -4,  0,  1,  2,  3 )
              , ( -7, -3, -5, -3, -3, -3, -1,  0,  2,  1 )
              , ( -8, -2, -6, -2, -4, -2, -2, -2,  0,  1 )
              , ( -9, -1, -7, -1, -5, -1, -3, -1, -1,  0 )
              )
            )
    END
END
