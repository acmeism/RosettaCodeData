BEGIN # Chebyshev Coefficients #

    PROC chebyshev coef = ( PROC( REAL )REAL func, REAL min, max, INT n )[]REAL:
         BEGIN

            PROC map = ( REAL x, min x, max x, min to, max to )REAL:
               ( x - min x ) / ( max x - min x ) * ( max to - min to ) + min to;

            [ 0 : n - 1 ]REAL coef; FOR i FROM LWB coef TO UPB coef DO coef[ i ] := 0 OD;
            FOR i FROM 0 TO UPB coef DO
                REAL m = map( cos( pi * ( i + 0.5 ) / n ), -1, 1, min, max );
                REAL f = func( m ) * 2 / n;
                FOR j FROM 0 TO UPB coef DO
                    coef[ j ] +:= f * cos( pi * j * ( i + 0.5 ) / n )
                OD
            OD;
            coef
         END # chebyshev coef # ;

    BEGIN
        INT n = 10;
        REAL min := 0, max := 1;
        []REAL c = chebyshev coef( cos, min, max, n );
        print( ( "Coefficients:", newline ) );
        FOR i FROM LWB c TO UPB c DO
            print( ( fixed( c[ i ], -18, 14 ), newline ) )
        OD
    END

END
