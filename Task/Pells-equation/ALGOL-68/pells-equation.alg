BEGIN
    # find solutions to Pell's eqauation: x^2 - ny^2 = 1 for integer x, y, n #
    MODE BIGINT     = LONG LONG INT;
    MODE BIGPAIR    = STRUCT( BIGINT v1, v2 );
    PROC solve pell = ( INT n )BIGPAIR:
         IF INT x = ENTIER( sqrt( n ) );
            x * x = n
         THEN
            # n is a erfect square - no solution otheg than 1,0              #
            BIGPAIR( 1, 0 )
         ELSE
            # there are non-trivial solutions                                #
            INT     y := x;
            INT     z := 1;
            INT     r := 2*x;
            BIGPAIR e := BIGPAIR( 1, 0 );
            BIGPAIR f := BIGPAIR( 0, 1 );
            BIGINT  a := 0;
            BIGINT  b := 0;
            WHILE
                y := (r*z - y);
                z := ENTIER ((n - y*y) / z);
                r := ENTIER ((x + y) / z);
                e := BIGPAIR( v2 OF e, r * v2 OF e + v1 OF e );
                f := BIGPAIR( v2 OF f, r * v2 OF f + v1 OF f );
                a := (v2 OF e + x*v2 OF f);
                b := v2 OF f;
                a*a - n*b*b /= 1
            DO SKIP OD;
            BIGPAIR( a, b )
         FI # solve pell # ;
    # task test cases                                                        #
    []INT nv = (61, 109, 181, 277);
    FOR i FROM LWB nv TO UPB nv DO
        INT  n = nv[ i ];
        BIGPAIR r = solve pell(n);
        print( ("x^2 - ", whole( n, -3 ), " * y^2 = 1 for x = ", whole( v1 OF r, -21), " and y = ", whole( v2 OF r, -21 ), newline ) )
    OD
END
