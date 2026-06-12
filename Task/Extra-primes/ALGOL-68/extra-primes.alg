BEGIN # find extra primes - numbers whose digits are prime and whose         #
      # digit sum is prime; other than the 1 digit primes, the first three   #
      # digits can be 0, 2, 3, 5, 7 and the final digit can only be 3 or 7   #
      # which means there are at most 5^3 * 2 = 250 possible numbers         #
      # so we will use trial division for primality testing                  #

    # returns TRUE if n is prime, FALSE otherwise - uses trial division      #
    PROC is prime = ( INT n )BOOL:
         IF   n < 3       THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELIF NOT ODD n   THEN FALSE
         ELSE
             BOOL is a prime := TRUE;
             FOR f FROM 5 BY 2 WHILE f * f <= n AND is a prime DO
                 is a prime := n MOD f /= 0
             OD;
             is a prime
         FI # is prime # ;

    # first four numbers ) i.e. the 1 digit primes ) as a special case       #
    print( ( "    2    3    5    7" ) );
    INT count := 4;
    # 2, 3 and 5 digit numbers                                               #
    FOR i1 FROM -1 BY 2 TO 7 DO
        INT d1 = IF i1 < 3 THEN i1 + 1 ELSE i1 FI;
        FOR i2 FROM -1 BY 2 TO 7 DO
            INT d2 = IF i2 < 3 THEN i2 + 1 ELSE i2 FI;
            IF ( d1 + d2 ) = 0 OR d2 /= 0 THEN
                FOR i3 FROM 1 BY 2 TO 7 DO
                    INT d3 = IF i3 < 3 THEN i3 + 1 ELSE i3 FI;
                    FOR d4 FROM 3 BY 4 TO 7 DO
                        INT sum = d1 + d2 + d3 + d4;
                        INT n   = ( ( ( ( ( d1 * 10 ) + d2 ) * 10 ) + d3 ) * 10 ) + d4;
                        IF is prime( sum ) AND is prime( n ) THEN
                            # found a prime whose prime digits sum to a prime #
                            print( ( " ", whole( n, -4 ) ) );
                            IF ( count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
                        FI
                    OD
                OD
            FI
        OD
    OD
END
