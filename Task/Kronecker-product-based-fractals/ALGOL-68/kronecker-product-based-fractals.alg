BEGIN # Kronecker product based fractals - translated from the Kotlin sample #

    MODE MATRIX = FLEX[ 1 : 0, 1 : 0 ]INT;

    PROC kronecker product = ( MATRIX a in, b in )MATRIX:
         BEGIN
             MATRIX a = a in[ AT 0, AT 0 ], b = b in[ AT 0, AT 0 ];
             INT m   = 1 UPB a + 1, n = 2 UPB a + 1;
             INT p   = 1 UPB b + 1, q = 2 UPB b + 1;
             INT rtn = m * p, ctn = n * q;
             [ 0 : rtn - 1, 0 : ctn - 1 ]INT r;
             FOR i FROM 0 TO rtn - 1 DO FOR j FROM 0 TO ctn - 1 DO r[ i, j ] := 0 OD OD;
             FOR i FROM 0 TO m - 1 DO
                 FOR j FROM 0 TO n - 1 DO
                     FOR k FROM 0 TO p - 1 DO
                         FOR l FROM 0 TO q - 1 DO
                             r[ p * i + k, q * j + l ] := a[ i, j ] * b[ k, l ]
                         OD
                     OD
                 OD
             OD;
             r
         END # kronecker product # ;

    PROC kronecker power = ( MATRIX a, INT n )MATRIX:
         BEGIN
             MATRIX pow := a;
             FOR i TO n - 1 DO pow := kronecker product( pow, a ) OD;
             pow
         END # kronecker power # ;

    PROC print matrix = ( STRING text, MATRIX m )VOID:
         BEGIN
             print( ( text, " fractal :", newline ) );
             FOR i FROM 1 LWB m TO 1 UPB m DO
                 FOR j FROM 2 LWB m TO 2 UPB m DO
                     print( ( IF m[ i, j ] = 1 THEN "*" ELSE " " FI ) )
                 OD;
                 print( ( newline ) )
             OD;
             print( ( newline ) )
         END # print matrix # ;

    MATRIX a := MATRIX( ( 0, 1, 0 )
                      , ( 1, 1, 1 )
                      , ( 0, 1, 0 )
                      );
    print matrix( "Vicsek", kronecker power( a, 4 ) );

    a := MATRIX( ( 1, 1, 1 )
               , ( 1, 0, 1 )
               , ( 1, 1, 1 )
               );
    print matrix( "Sierpinski carpet", kronecker power( a, 4 ) )
END
