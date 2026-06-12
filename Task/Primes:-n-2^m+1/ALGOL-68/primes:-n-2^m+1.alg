BEGIN # find primes of the form 1+n*2^m where m is the lowest integer >= 0   #
      # such that 1+n*2^m is prime                                           #
    PR read "primes.incl.a68" PR # include peime utilities                   #
    PR precision 8000 PR # set the precision of LONG LONG INT                #
    INT max m := 8000;   # maximum m we will consider                        #
    FOR n TO 400 DO
        INT           m         := 0;
        LONG LONG INT nx2 to m  := n;
        LONG LONG INT p         := 0;
        BOOL          found     := FALSE;
        WHILE NOT found AND m <= max m DO
            IF NOT ( found := is probably prime( p := nx2 to m + 1 ) ) THEN
                nx2 to m *:= 2;
                m        +:= 1
            FI
        OD;
        IF NOT found THEN
            print( ( whole( n, -3 ), " not found", newline ) )
        ELSE
            print( ( whole( n, -3 ), " ", whole( m, -8 ), ": ", whole( p, 0 ), newline ) )
        FI
    OD
END
