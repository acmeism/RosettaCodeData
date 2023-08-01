BEGIN # find some Pell numbers - trans FreeBASIC ( which is trans Phix )     #

    PR read "primes.incl.a68" PR

    [ 0 : 90 ]LONG INT p, pl;
    p[  0 ] := 0; p[  1 ] := 1;
    pl[ 0 ] := 2; pl[ 1 ] := 2;
    FOR n FROM 2 TO UPB p DO
        p[  n ] := 2 * p[  n - 1 ] + p[  n - 2 ];
        pl[ n ] := 2 * pl[ n - 1 ] + pl[ n - 2 ]
    OD;

    print( ( "First 20 Pell numbers:", newline ) );
    FOR n FROM 0 TO 19 DO print( ( " ", whole( p[  n ], 0 ) ) ) OD;
    print( ( newline, newline, "First 20 Pell-Lucas numbers:", newline ) );
    FOR n FROM 0 TO 19 DO print( ( " ", whole( pl[ n ], 0 ) ) ) OD;

    print( ( newline, newline, "First 20 rational approximations of sqrt(2) (" ) );
    print( ( fixed( sqrt( 2 ), -15, 13 ), "):", newline ) );
    FOR n TO 20 DO
        LONG INT j = pl[ n ] OVER 2, d = p[ n ];
        print( ( " ", whole( j, 0 ), "/", whole( d, 0 ), " ~= ", fixed( j / d, -15, 13 ), newline ) )
    OD;

    print( ( newline, "First 10 Pell primes:", newline, "index Pell prime", newline ) );
    INT c := 0;
    FOR pdx FROM 2 WHILE c < 10 DO
        IF is probably prime( p[ pdx ] ) THEN
            print( ( whole( pdx, -5 ), " ", whole( p[ pdx ], 0 ), newline ) );
            c +:= 1
        FI
    OD;

    print( ( newline, newline, "First 20 Newman-Shank-Williams numbers:", newline ) );
    FOR n FROM 0 TO 19 DO
        LONG INT nsw = p[ 2 * n ] + p[ 2 * n + 1 ];
        print( ( " ", whole( nsw, 0 ) ) ); IF n = 13 THEN print( ( newline ) ) FI
    OD;

    print( ( newline, newline, "First 20 near isosceles right triangles:", newline ) );
    LONG INT i0 := 0, i1 := 1, t := 1, found := 0;
    FOR i FROM 2 WHILE found < 20 DO
        LONG INT i2 = i1*2 + i0;
        IF ODD i THEN
            print( ( " [", whole( t, 0 ), ", ", whole( t + 1, 0 ), ", ", whole( i2, 0 ), "]", newline ) );
            found +:= 1
        FI;
        t +:= i2; i0 := i1; i1 := i2
    OD

END
