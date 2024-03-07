BEGIN # find some Fortunate numbers m, m is smallest positive integer > 1    #
      #                           where primorial(n) + m is prime for some n #
      #                            as all primorials are even, m must be odd #

    PR precision 2000 PR        # set the number of digits for LONG LONG INT #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    INT max fortunate = 500;    # largeest fortunate number we will consider #
    []BOOL is prime = PRIMESIEVE 5 000;
    [ 1 : max fortunate ]INT fortunate; FOR i TO max fortunate DO fortunate[ i ] := 0 OD;
    INT primorial pos          := 0;
    LONG LONG INT primorial    := 1;
    INT prime pos              := 0;
    WHILE primorial pos < 100 DO
        WHILE NOT is prime[ prime pos +:= 1 ] DO SKIP OD;
        primorial pos +:= 1;
        primorial     *:= prime pos;
        INT m          := 3;
        WHILE NOT is probably prime( primorial + m ) AND m <= max fortunate DO m +:= 2 OD;
        IF m <= max fortunate THEN
            IF fortunate[ m ] = 0 THEN fortunate[ m ] := primorial pos FI
        FI
    OD;
    print( ( "The first 50 Fortunate numbers:", newline ) );
    INT f count := 0;
    FOR f TO max fortunate WHILE f count < 50 DO
        IF fortunate[ f ] /= 0 THEN
            print( ( whole( f, -5 ) ) );
            IF ( f count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( "The primorial associated with the first 50 Fortunate numbers:", newline ) );
    f count := 0;
    FOR f TO max fortunate WHILE f count < 50 DO
        IF fortunate[ f ] /= 0 THEN
            print( ( whole( fortunate[ f ], -5 ) ) );
            IF ( f count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD

END
