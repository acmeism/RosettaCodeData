BEGIN # find some primes whose first and last digits are 3                   #
    INT max prime = 1 000 000; # largest number to consider                  #
    # sieve the primes to max prime                                          #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    INT p3count := 0;
    # prints n, if it is prime, handles newlines                             #
    PROC p = ( INT n )VOID:
         IF prime[ n ] THEN
             print( ( " ", whole( n, - 4 ) ) );
             IF ( p3count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
         FI # p #;
    # find 3x3 primes                                                        #
    p( 3 ); p( 33 );                                # a & 2 digit 3x3 primes #
    FOR i FROM 0 BY 10 TO  90 DO p(  303 + i ) OD;  # 3 digit 3x3 primes     #
    FOR i FROM 0 BY 10 TO 990 DO p( 3003 + i ) OD;  # 4 digit 3x3 primes     #
    # 5 and 6 digit 3x3 primes                                               #
    FOR i FROM 0 BY 10 TO  9 990 DO IF prime[  30 003 + i ] THEN p3count +:= 1 FI OD;
    FOR i FROM 0 BY 10 TO 99 990 DO IF prime[ 300 003 + i ] THEN p3count +:= 1 FI OD;
    print( ( newline, "Found ", whole( p3count, 0 ), " ""3x3"" primes below 1000000", newline ) )
END
