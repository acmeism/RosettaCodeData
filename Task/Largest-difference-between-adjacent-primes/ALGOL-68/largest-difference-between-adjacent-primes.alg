BEGIN # find the largest gap between adjacent primes up to 10 000 000 #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 10 000 000; # sieve the primes to 10 000 000 #
    # find the largest gap between primes #
    INT max gap     :=  0; # gap between 2 and 3 #
    INT max prime   :=  0; # the prime with the maximum gap #
    INT max prev    :=  0; # the prime before the maximum gap #
    INT prev prime  :=  2; # the previous prime #
    INT power of 10 := 10; # next number to print the gap for #
    FOR i FROM 3 BY 2 TO UPB prime DO
        IF prime[ i ] THEN
            # have a prime #
            INT gap = i - prev prime;
            IF gap > max gap THEN
                # have a bigger gap than before #
                max prime := i;
                max prev  := prev prime;
                max gap   := gap
            FI;
            prev prime    := i
        FI;
        IF i = power of 10 - 1 THEN
            # have reached the next power of 10 - report the max gap so far #
            print( ( "Largest gap between primes up to ", whole( power of 10, -9 )
                   , ": ", whole( max gap, -9 ), " between "
                   , whole( max prev, 0 ), " and ", whole( max prime, 0 )
                   , newline
                   )
                 );
            power of 10 *:= 10
        FI
    OD
END
