BEGIN # find numbers whose digit sums in binary and ternary are prime #
    # returns the digit sum of n in base b #
    PRIO DIGITSUM = 9;
    OP   DIGITSUM = ( INT n, b )INT:
         BEGIN
            INT d sum := 0;
            INT v     := ABS n;
            WHILE v > 0 DO
                d sum +:= v MOD b;
                v  OVERAB b
            OD;
            d sum
         END # DIGITSUM # ;

    PR read "primes.incl.a68" PR
    []BOOL prime    = PRIMESIEVE 200;
    INT    n count := 0;
    FOR n TO UPB prime DO
        INT d sum 2 = n DIGITSUM 2;
        IF prime[ d sum 2 ] THEN
            INT d sum 3 = n DIGITSUM 3;
            IF prime[ d sum 3 ] THEN
                # the base 2 and base 3 digit sums of n are both prime #
                print( ( " ", whole( n, -3 ), IF prime[ n ] THEN "*" ELSE " " FI ) );
                n count +:= 1;
                IF n count MOD 14 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;
    print( ( newline ) );
    print( ( "Found ", whole( n count, 0 ) ) );
    print( ( " numbers whose binary and ternary digit sums are prime", newline ) );
    print( ( "    those that are themselves prime are suffixed with a ""*""", newline ) )
END
