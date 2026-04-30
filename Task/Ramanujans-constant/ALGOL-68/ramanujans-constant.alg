BEGIN # Ramanujan's constant #

    PR precision 64 PR

    PROC ramanujan = ( INT n )LONG LONG REAL:
         long long exp( long long pi * long long sqrt( n ) );

    print( ( "Ramanujan's constant to 32 decimal places is: " ) );
    print( ( fixed( ramanujan( 163 ), -52, 32 ), newline, newline ) );

    []INT heegner = ( 19, 43, 67, 163 );
    print( ( "Heegner numbers yielding almost integers:", newline ) );
    FOR hpos FROM LWB heegner TO UPB heegner DO
        INT h = heegner[ hpos ];
        LONG LONG REAL r  = ramanujan( h );
        LONG LONG INT rc := ENTIER r;
        IF rc /= r THEN rc +:= 1 FI;
        LONG LONG REAL diff = rc - r;
        print( ( whole( h, -3 ), ":", fixed ( r, -52, 32 ) ) );
        print( ( " ~ ", whole( rc, -20 ), newline ) );
        print( ( "        diff:         ", fixed( diff, -34, 32 ), newline ) )
    OD
END
