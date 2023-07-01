BEGIN # find some primorial primes - primes that are p - 1 or p + 1      #
      #      for some primorial p                                        #
    PR precision 2000 PR                # allow up to 2000 digit numbers #
    PR read "primes.incl.a68" PR               # include prime utilities #
    # construct a sieve of primes up to 2000                             #
    []BOOL primes = PRIMESIEVE 2000;
    # find the sequence members                                          #
    LONG LONG INT pn      := 1;
    INT           p count := 0;
    INT           p pos   := 0;
    FOR n FROM 1 WHILE p count < 12 DO
        # find the next prime                                            #
        WHILE NOT primes[ p pos +:= 1 ] DO SKIP OD;
        pn *:= p pos;
        IF   is probably prime( pn - 1 )
        THEN
             p count +:= 1;
             print( ( " ", whole( n, 0 ) ) )
        ELIF is probably prime( pn + 1 )
        THEN
             p count +:= 1;
             print( ( " ", whole( n, 0 ) ) )
        FI
    OD;
    print( ( newline ) )
END
