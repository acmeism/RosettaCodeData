BEGIN # find and classify the complex conjugate transpose of a complex matrix #
    # returns the conjugate transpose of m #
    OP   CONJUGATETRANSPOSE = ( [,]COMPL m )[,]COMPL:
         BEGIN
            [ 2 LWB m : 2 UPB m, 1 LWB m : 1 UPB m ]COMPL result;
            FOR i FROM 1 LWB m TO 1 UPB m DO
                FOR j FROM 2 LWB m TO 2 UPB m DO
                    result[ j, i ] := CONJ m[ i, j ]
                OD
            OD;
            result
         END # CONJUGATETRANSPOSE # ;
    # returns TRUE if m is an identity matrix, FALSE otherwise #
    OP   ISIDENTITY  = ( [,]COMPL m )BOOL:
         IF 1 LWB m /= 2 LWB m OR 1 UPB m /= 2 UPB m THEN
            # non-square matrix #
            FALSE
         ELSE
            # the matrix is square #
            # returns TRUE IF v - e is nearly 0, FALSE Otherwise #
            PROC nearly equal = ( COMPL v, REAL e )BOOL: ABS re OF v - e < 1e-14 AND ABS im OF v < 1e-14;
            BOOL result := TRUE;
            FOR i FROM 1 LWB m TO 1 UPB m WHILE result DO
                IF result := nearly equal( m[ i, i ], 1 ) THEN
                    # the diagonal element is 1 - test the non-diagonals #
                    FOR j FROM 1 LWB m TO 1 UPB m WHILE result DO
                        IF i /= j THEN result := nearly equal( m[ i, j ], 0 ) FI
                    OD
                FI
            OD;
            result
         FI # ISIDENTITY # ;
    # returns m multiplied by n #
    PRIO X = 7;
    OP   X = ( [,]COMPL m, n )[,]COMPL:
         BEGIN
            [ 1 : 1 UPB m, 1 : 2 UPB n ]COMPL r;
            FOR i FROM 1 LWB m TO 1 UPB m DO
                FOR j FROM 2 LWB n TO 2 UPB n DO
                    r[ i, j ] := 0;
                    FOR k TO 2 UPB n DO
                        r[ i, j ] +:= m[ i, k ] * n[ k, j ]
                    OD
                OD
            OD;
            r
         END # X # ;
    # prints the complex matris m #
    PROC show matrix = ( [,]COMPL m )VOID:
         FOR i FROM 1 LWB m TO 1 UPB m DO
             print( ( "    " ) );
             FOR j FROM 2 LWB m TO 2 UPB m DO
                 print( ( "( ", fixed( re OF m[ i, j ], -8, 4 )
                        , ", ", fixed( im OF m[ i, j ], -8, 4 )
                        , "i )"
                        )
                      )
             OD;
             print( ( newline ) )
         OD # show matrix # ;
    # display the matrix m, its conjugate transpose and whether it is Hermitian, Normal and Unitary #
    PROC show = ( [,]COMPL m )VOID:
         BEGIN
            [,]COMPL c  = CONJUGATETRANSPOSE m;
            [,]COMPL cm = c X m;
            [,]COMPL mc = m X c;
            print( ( "Matrix:", newline ) );
            show matrix( m );
            print( ( "Conjugate Transpose:", newline ) );
            show matrix( c );
            BOOL is normal  = cm = mc;
            BOOL is unitary = IF   NOT is normal     THEN FALSE
                              ELSE     ISIDENTITY mc
                              FI;
            print( ( IF c = m      THEN "" ELSE "not " FI, "Hermitian; "
                   , IF is normal  THEN "" ELSE "not " FI, "Normal; "
                   , IF is unitary THEN "" ELSE "not " FI, "Unitary"
                   , newline
                   )
                 );
            print( ( newline ) )
         END # show # ;
    # test some matrices for Hermitian, Normal and Unitary                             #
    show( ( ( ( 3.0000 I  0.0000 ), ( 2.0000 I 1.0000 ) )
          , ( ( 2.0000 I -1.0000 ), ( 1.0000 I 0.0000 ) )
          )
        );
    show( ( ( ( 1.0000 I 0.0000 ), ( 1.0000 I  0.0000 ), ( 0.0000 I 0.0000 ) )
          , ( ( 0.0000 I 0.0000 ), ( 1.0000 I  0.0000 ), ( 1.0000 I 0.0000 ) )
          , ( ( 1.0000 I 0.0000 ), ( 0.0000 I  0.0000 ), ( 1.0000 I 0.0000 ) )
          )
        );
    REAL rh = sqrt( 0.5 );
    show( ( ( ( rh     I 0.0000 ), ( rh     I  0.0000 ), ( 0.0000 I 0.0000 ) )
          , ( ( 0.0000 I rh     ), ( 0.0000 I - rh    ), ( 0.0000 I 0.0000 ) )
          , ( ( 0.0000 I 0.0000 ), ( 0.0000 I  0.0000 ), ( 0.0000 I 1.0000 ) )
          )
        )
END
