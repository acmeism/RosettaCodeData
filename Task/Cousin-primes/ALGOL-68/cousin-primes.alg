BEGIN # find cousin primes - pairs of primes that differ by 4 #
    # sieve the primes as required by the task #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 1000;
    # returns text right padded to length, if it is shorter #
    PROC right pad = ( STRING text, INT length )STRING:
         IF INT t length = ( UPB text - LWB text ) + 1;
            t length >= length
         THEN text
         ELSE text + ( ( length - t length ) * " " )
         FI # right pad # ;
    # look through the primes for cousins #
    INT p count := 0;
    FOR i TO UPB prime - 4 DO
        IF prime[ i ] THEN
            IF prime[ i + 4 ] THEN
                # have a pair of cousin primes #
                p count +:= 1;
                print( ( whole( i, -5 ), "-", right pad( whole( i + 4, 0 ), 5 ) ) );
                IF p count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( p count, 0 ), " cousin primes", newline ) )
END
