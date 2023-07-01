BEGIN
    # returns an upper Pascal matrix of size n #
    PROC upper pascal matrix = ( INT n )[,]INT:
         BEGIN
            [ 1 : n, 1 : n ]INT result;
            FOR j        TO n DO result[ 1, j ] := 1 OD;
            FOR i FROM 2 TO n DO
                result[ i, 1 ] := 0;
                FOR j FROM 2 TO n DO
                    result[ i, j ] := result[ i - 1, j - 1 ] + result[ i, j - 1 ]
                OD
            OD;
            result
         END # upper pascal matrix # ;

    # returns a lower Pascal matrix of size n #
    PROC lower pascal matrix = ( INT n )[,]INT:
         BEGIN
            [ 1 : n, 1 : n ]INT result;
            FOR i        TO n DO result[ i, 1 ] := 1 OD;
            FOR j FROM 2 TO n DO
                result[ 1, j ] := 0;
                FOR i FROM 2 TO n DO
                    result[ i, j ] := result[ i - 1, j - 1 ] + result[ i - 1, j ]
                OD
            OD;
            result
         END # lower pascal matrix # ;

    # returns a symmetric Pascal matrix of size n #
    PROC symmetric pascal matrix = ( INT n )[,]INT:
         BEGIN
            [ 1 : n, 1 : n ]INT result;
            FOR i TO n DO
                result[ i, 1 ] := 1;
                result[ 1, i ] := 1
            OD;
            FOR j FROM 2 TO n DO
                FOR i FROM 2 TO n DO
                    result[ i, j ] := result[ i, j - 1 ] + result[ i - 1, j ]
                OD
            OD;
            result
         END # symmetric pascal matrix # ;

    # print the matrix m with the specified field width #
    PROC print matrix = ( [,]INT m, INT field width )VOID:
         BEGIN
             FOR i FROM 1 LWB m TO 1 UPB m DO
                 FOR j FROM 2 LWB m TO 2 UPB m DO
                     print( ( " ", whole( m[ i, j ], - field width ) ) )
                 OD;
                 print( ( newline ) )
             OD
         END # print matrix # ;

    print( ( "upper:",     newline ) ); print matrix( upper pascal matrix(     5 ), 2 );
    print( ( "lower:",     newline ) ); print matrix( lower pascal matrix(     5 ), 2 );
    print( ( "symmetric:", newline ) ); print matrix( symmetric pascal matrix( 5 ), 2 )

END
