BEGIN # find some Mersenne Primrs - primes of the form 2^n - 1, n must be prime #
    # This assumes LONG INT is at least 64 bits (as in e.g. Algol 68G)          #
    # we handle 2 as a special case and then the odd numbers starting at 3      #
    PR read "primes.incl.a68" PR                      # include prime utilities #
    # 2^0 - 1 = 0 and 2^1 - 1 = 1, neither of which is prime                    #
    # start from 2^2                                                            #
    INT      n  := 2;
    LONG INT p2 := 4;
    IF is probably prime( p2 - 1 ) THEN print( ( " ", whole( n, 0 ) ) ) FI;
    # 2^3, 2^5, etc.                                                            #
    n  +:= 1;
    p2 *:= 2;
    WHILE n < 61 DO
        IF is probably prime( p2 - 1 ) THEN print( ( " ", whole( n, 0 ) ) ) FI;
        n  +:= 2;
        p2 *:= 4
    OD;
    IF is probably prime( p2 - 1 ) THEN print( ( " ", whole( n, 0 ) ) ) FI
END
