BEGIN  # find primes whose decimal representation is the concatenation of 2 primes #
    INT max low prime = 99;  # for the task, only need component primes up to 99   #
    INT max prime     = max low prime * max low prime;
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # construct a list of the primes up to the maximum low prime to consider #
    []INT low prime = EXTRACTPRIMESUPTO max low prime FROMPRIMESIEVE prime;
    # find the primes that can be concatenated to form another prime #
    [ 1 : max prime ]BOOL concat prime; FOR i TO UPB concat prime DO concat prime[ i ] := FALSE OD;
    # note that all possible concatenated primes have at least 2 digits, so the final digit can't be 2 #
    #      ( or 5 but we don't check that here ) #
    FOR i TO UPB low prime WHILE low prime[ i ] <= max low prime DO
        INT p1 = low prime[ i ];
        FOR j FROM 2 TO UPB low prime WHILE low prime[ j ] <= max low prime DO
            INT p2 = low prime[ j ];
            INT pc = ( p1 * IF p2 < 10 THEN 10 ELSE 100 FI ) + p2;
            concat prime[ pc ] := prime[ pc ]
        OD
    OD;
    # show the concatenated primes #
    INT c count := 0;
    FOR n TO UPB concat prime DO
        IF concat prime[ n ] THEN
            print( ( whole( n, -5 ) ) );
            IF ( c count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline, newline, "Found ", whole( c count, 0 ), " concat primes", newline ) )
END
