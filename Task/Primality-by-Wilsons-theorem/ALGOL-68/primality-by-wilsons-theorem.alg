BEGIN
    # find primes using Wilson's theorem:                               #
    #    p is prime if ( ( p - 1 )! + 1 ) mod p = 0                     #

    # returns true if p is a prime by Wilson's theorem, false otherwise #
    #         computes the factorial mod p at each stage, so as to      #
    #         allow numbers whose factorial won't fit in 32 bits        #
    PROC is wilson prime = ( INT p )BOOL:
         BEGIN
            INT factorial mod p := 1;
            FOR i FROM 2 TO p - 1 DO factorial mod p *:= i MODAB p OD;
            factorial mod p = p - 1
         END # is wilson prime # ;

    FOR i TO 100 DO IF is wilson prime( i ) THEN print( ( " ", whole( i, 0 ) ) ) FI OD
END
