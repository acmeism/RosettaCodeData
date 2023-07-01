BEGIN # Find Brilliant numbers - semi-primes whose two prime factors have    #
      # the same number of digits                                            #
    PR read "primes.incl.a68" PR          # include prime utilities          #
    INT max prime = 1 010;                # maximum prime we will consider   #
                # should be enough to find the first brilliant number > 10^6 #
    []BOOL prime = PRIMESIEVE max prime;  # sieve of primes to max prime     #
    # construct a table of brilliant numbers #
    [ 1 : max prime * max prime ]BOOL brilliant;
    FOR n FROM LWB brilliant TO UPB brilliant DO brilliant[ n ] := FALSE OD;
    # brilliant numbers where one of the fators is 2 #
    brilliant[ 4 ] := TRUE;
    FOR p FROM 3 BY 2 TO 7 DO brilliant[ 2 * p ] := TRUE OD;
    # brilliant numbers where both factors are odd #
    INT p start := 1, p end := 9;
    WHILE pstart < max prime DO
        FOR p FROM p start BY 2 TO p end DO
            IF prime[ p ] THEN
                brilliant[ p * p ] := TRUE;
                FOR q FROM p + 2 BY 2 TO p end DO
                    IF prime[ q ] THEN
                        brilliant[ p * q ] := TRUE
                    FI
                OD
            FI
        OD;
        p start := p end + 2;
        p end   := ( ( p start - 1 ) * 10 ) - 1;
        IF p end > max prime THEN p end := max prime FI
    OD;
    # show the first 100 brilliant numbers #
    INT b count := 0;
    FOR n TO UPB brilliant WHILE b count < 100 DO
        IF brilliant[ n ] THEN
            print( ( whole( n, -6 ) ) );
            IF ( b count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    # first brilliant number >= 10^n, n = 1, 2, ..., 6 #
    b count := 0;
    INT power of 10 := 10;
    FOR n TO UPB brilliant DO
        IF brilliant[ n ] THEN
            b count +:= 1;
            IF n >= power of 10 THEN
                print( ( "First brilliant number >= ", whole( power of 10, -8 )
                       , ": "                        , whole( n, -8 )
                       , " at position "             , whole( b count, -6 )
                       , newline
                       )
                     );
                power of 10 *:= 10
            FI
        FI
    OD
END
