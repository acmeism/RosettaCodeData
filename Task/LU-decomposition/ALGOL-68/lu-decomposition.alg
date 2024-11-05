BEGIN # LU decomposition - translation of the Kotlin sample #

    OP   * = ( [,]REAL this, other )[,]REAL:
         IF  1 LWB this /= 2 LWB other OR 1 UPB this /= 2 UPB other
         THEN print( ( "Cannot multiply matrices: " ) );
              print( ( "[", whole( 1 LWB this,  0 ), ":", whole( 1 UPB this,  0 ) ) );
              print( ( ",", whole( 2 LWB this,  0 ), ":", whole( 2 UPB this,  0 ), "]" ) );
              print( ( " X " ) );
              print( ( "[", whole( 1 LWB other, 0 ), ":", whole( 1 UPB other, 0 ) ) );
              print( ( ",", whole( 2 LWB other, 0 ), ":", whole( 2 UPB other, 0 ), "]" ) );
              print( ( newline ) );
              stop
         ELSE [ 1 LWB this : 1 UPB this, 2 LWB other : 2 UPB other ]REAL result;
              FOR i FROM 1 LWB this TO 1 UPB this DO
                  FOR j FROM 2 LWB other TO 2 UPB other DO
                      result[ i, j ] := 0;
                      FOR k FROM 1 LWB other TO 1 UPB other DO
                          result[ i, j ] +:= this[ i, k ] * other[ k, j ]
                      OD
                  OD
              OD;
              result
         FI # * # ;

    OP   PIVOTISE = ( [,]REAL m in )[,]REAL:
         BEGIN
            [,]REAL m = m in[ AT 1, AT 1 ];
            INT n = ( 1 UPB m - 1 LWB m ) + 1;
            [ 1 : n, 1 : n ]REAL im;
            FOR i TO n DO
                FOR j TO n DO im[ i, j ] := 0 OD;
                im[ i, i ] := 1
            OD;
            FOR i TO n DO
                REAL max := ABS m[ i, i ];
                INT  row := i;
                FOR j FROM i TO n DO
                    IF ABS m[ j, i ] > max THEN
                        max := ABS m[ j, i ];
                        row := j
                    FI
                OD;
                IF i /= row THEN
                    []REAL t      = im[ i,   : ];
                    im[ i,   : ] := im[ row, : ];
                    im[ row, : ] := t
                FI
            OD;
            im
         END # PIVOTISE # ;

    MODE DECOMPOSITION = STRUCT( [ 1 : 1, 1 : 1 ]REAL l, u, p );

    OP   LU = ( [,]REAL a in )DECOMPOSITION:
         BEGIN
            [,]REAL a = a in[ AT 1, AT 1 ];
            INT n = ( 1 UPB a in - 1 LWB a in ) + 1;
            [ 1 : n, 1 : n ]REAL l, u;
            [,]REAL p  = PIVOTISE a;
            [,]REAL a2 = p * a;
            FOR i TO n DO FOR j TO n DO l[ i, j ] := u[ i, j ] := 0 OD OD;
            FOR j TO n DO
                l[ j, j ] := 1;
                FOR i TO j DO
                    REAL sum := 0;
                    FOR k TO i DO sum +:= u[ k, j ] * l[ i, k ] OD;
                    u[ i, j ] := a2[ i, j ] - sum
                OD;
                FOR i FROM j + 1 TO n DO
                    REAL sum := 0;
                    FOR k TO j DO sum +:= u[ k, j ] * l[ i, k ] OD;
                    l[ i, j ] := ( a2[ i, j ] - sum ) / u[ j, j ]
                OD
            OD;
            DECOMPOSITION( l, u, p )
         END # LU # ;

    PROC show matrix = ( STRING title, [,]REAL m, INT fw, fdp )VOID:
         BEGIN
             print( ( "    ", title, newline ) );
             FOR i FROM 1 LWB m TO 1 UPB m DO
                 print( ( "        " ) );
                 FOR j FROM 2 LWB m TO 2 UPB m DO print( ( fixed( m[ i, j ], -fw, fdp ), "  " ) ) OD;
                 print( ( newline ) )
             OD
         END # show matrix # ;

    BEGIN # test the LU decomposition operator                               #
        [,]REAL a1 = ( ( 1.0,  3.0,  5.0 )
                     , ( 2.0,  4.0,  7.0 )
                     , ( 1.0,  1.0,  0.0 )
                     );
        DECOMPOSITION d1 = LU a1;
        print( ( "EXAMPLE 1:-", newline ) );
        show matrix( "A:", a1,      1, 0 );
        show matrix( "L:", l OF d1, 8, 5 );
        show matrix( "U:", u OF d1, 8, 5 );
        show matrix( "P:", p OF d1, 1, 0 );
        print( ( newline ) );
        [,]REAL a2 = ( ( 11.0,  9.0, 24.0,  2.0 )
                     , (  1.0,  5.0,  2.0,  6.0 )
                     , (  3.0, 17.0, 18.0,  1.0 )
                     , (  2.0,  5.0,  7.0,  1.0 )
                     );
        DECOMPOSITION d2 = LU a2;
        print( ( "EXAMPLE 2:-", newline ) );
        show matrix( "A:", a2,      2, 0 );
        show matrix( "L:", l OF d2, 8, 5 );
        show matrix( "U:", u OF d2, 8, 5 );
        show matrix( "P:", p OF d2, 1, 0 )
    END
END
