BEGIN # Gauss-Jordan matrix inversion #
    PROC rref = ( REF[,]REAL m )VOID:
         BEGIN
            INT n = 1 UPB m;
            FOR r TO n DO
                REAL d = m[ r, r ];
                IF d /= 0 THEN
                    FOR c TO  n * 2 DO m[ r, c ] := m[ r, c ] / d OD
                ELSE
                    print( ( "inversion impossible!", newline ) )
                FI;
                FOR i TO n DO
                    IF i /= r THEN
                        REAL w = m[ i, r ];
                        FOR c TO n * 2 DO m[ i, c ] := m[ i, c ] - w * m[ r, c ] OD
                    FI
                OD
            OD
         END # rref # ;
    PROC inverse = ( REF[,]REAL mat )[,]REAL:
         BEGIN
            INT n = 1 UPB mat;
            [ 1 : n, 1 : n     ]REAL inv;
            [ 1 : n, 1 : n * 2 ]REAL aug;
            FOR i TO n DO
                FOR j            TO n     DO aug[ i, j ] := mat[ i, j ] OD;
                FOR j FROM 1 + n TO n * 2 DO aug[ i, j ] := 0           OD;
                aug[ i, i + n ] := 1
            OD;
            rref( aug );
            FOR i TO n DO
                FOR j FROM n + 1 TO 2 * n DO inv[ i, j - n ] := aug[ i, j ] OD
            OD;
            inv
         END # inverse # ;
    PROC show = ( STRING c, [,]REAL m )VOID:
         BEGIN
            INT n = 1 UPB m;
            print( ( "matrix ", c, newline ) );
            FOR i TO n DO
                FOR j TO n DO print( ( " ", fixed( m[ i, j ], -8, 3 ) ) ) OD;
                print( ( newline ) )
            OD
         END # show #;

    INT n = 4;
    [ 1 : n, 1 : n ]REAL a, b, c;
    a := [,]REAL( (  2,  1,  1,  4 )
                , (  0, -1,  0, -1 )
                , (  1,  0, -2,  4 )
                , (  4,  1,  2,  2 )
                );
    show( "a", a );
    b := inverse( a );
    show( "b", b );
    c := inverse( b );
    show( "c", c )
END
