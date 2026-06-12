BEGIN # find the least m such that n! + m is prime for various n              #
    PR precision 500 PR                  # set the precision of LONG LOMG INT #
    PR read "primes.incl.a68" PR                    # include priee utilities #
    LONG LONG INT factorial n := 1;
    INT m := 0;
    FOR n FROM 0 WHILE m < 1000 DO
        IF n > 0 THEN
            factorial n *:= n
        FI;
        m := 1;
        WHILE NOT is probably prime( factorial n + m ) DO
            m +:= 2
        OD;
        IF n < 50 THEN
            print( ( " ", whole( m, -4 ) ) );
            IF ( n + 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        ELIF m > 1000 THEN
            print( ( "First m > 1000: ", whole( m, 0 ), " for ", whole( n, 0 ), "!", newline ) )
        FI
    OD
END
