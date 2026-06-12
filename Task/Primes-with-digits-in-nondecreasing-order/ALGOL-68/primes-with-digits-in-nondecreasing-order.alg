BEGIN # find primes where the digits are non-descending #
    INT max number = 1000;
    # sieve the primes to max number #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max number;
    # we can easily generate candidate numbers with a few nested loops #
    INT p count := 0;
    # apart from 1 digit primes, the final digit can only be 1, 3, 7 or 9 #
    # however we don't optimise that here                                 #
    FOR h FROM 0 TO 9 DO
        FOR i FROM h TO 9 DO
            INT hi = ( h * 10 ) + i;
            FOR j FROM i TO 9 DO
                INT hij = ( 10 * hi ) + j;
                FOR k FROM IF j = 0 THEN 1 ELSE j FI TO 9
                WHILE INT hijk = ( hij * 10 ) + k;
                      hijk <= max number
                DO
                    IF prime[ hijk ] THEN
                        p count +:= 1;
                        print( ( " ", whole( hijk, -6 ) ) );
                        IF p count MOD 12 = 0 THEN print( ( newline ) ) FI
                    FI
                OD # k #
            OD # j #
        OD # i #
    OD # h # ;
    print( ( newline
           , newline
           , "Found "
           , whole( p count, 0 )
           , " non-descending primes up to "
           , whole( max number, 0 )
           , newline
           )
         )
END
