BEGIN # find some Wolstenholme numbers and indicate which are primes         #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n  #
    PROC gcd = ( LONG LONG INT m, n )LONG LONG INT:
         BEGIN
            LONG LONG INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                LONG LONG INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
        END # gcd # ;
    # returns the numerator of the nth second order harmonic number          #
    PROC harmonic2numerator = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT v := 0, f := 1;
            FOR i TO n DO
                f *:= i * i
            OD;
            FOR i TO n DO
                v +:= f OVER ( i * i )
            OD;
            v OVER gcd( v, f )
         END # harmonic2 # ;

    [ 20 ]LONG LONG INT wols;
    print( ( "First ", whole( UPB wols, 0 ), " Wolstenholme numbers:", newline ) );
    FOR i TO UPB wols DO
        wols[ i ] := harmonic2numerator( i );
        print( ( whole( wols[ i ], -18 ) ) );
        IF i MOD 4 = 0 THEN print( ( newline ) ) FI
    OD;
    print( ( newline, "... of the above, the following are prime:" ) );
    FOR i TO UPB wols DO
        IF is probably prime( wols[ i ] ) THEN
            print( ( " ", whole( wols[ i ], 0 ) ) )
        FI
    OD;
    print( ( newline ) )

END
