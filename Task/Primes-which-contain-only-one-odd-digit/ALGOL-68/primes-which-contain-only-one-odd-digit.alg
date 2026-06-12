BEGIN  # find primes whose decimal representation contains only one odd digit #
    # sieve the primes to 1 000 000 #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 1 000 000;
    # show a count of primes #
    PROC show total = ( INT count, INT limit, STRING name )VOID:
         print( ( newline, "Found ", whole( count, 0 ), " ", name, " primes upto ", whole( limit, 0 ), newline ) );
    # find the appropriate primes #
    # 2 is the only even prime, so the final digit must be odd for primes > 2   #
    # so we only need to check that the digits other than the last are all even #
    INT show max     = 1 000;
    INT p1odd count := 0;
    FOR n FROM 3 TO UPB prime DO
        IF prime[ n ] THEN
            BOOL p1odd := TRUE;
            INT  v     := n OVER 10;
            WHILE v > 0 AND ( p1odd := NOT ODD v ) DO
                v OVERAB 10
            OD;
            IF p1odd THEN
                # the prime has only 1 odd digit #
                p1odd count +:= 1;
                IF n <= show max THEN
                    print( ( whole( n, -5 ) ) );
                    IF p1odd count MOD 12 = 0 THEN print( ( newline ) ) FI
                FI
            FI
        FI;
        IF n = show max THEN
            print( ( newline ) );
            show total( p1odd count, show max, "single-odd-digit" )
        FI
    OD;
    show total( p1odd count, UPB prime, "single-odd-digit" )
END
