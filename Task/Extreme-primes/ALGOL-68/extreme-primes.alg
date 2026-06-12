BEGIN # sum the primes below n and report the sums that are prime            #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    []BOOL prime = PRIMESIEVE 2 000 000;     # sieve the primes to 2 000 000 #
    # returns TRUE if n is prime, FALSE otherwise                            #
    PROC is prime = ( LONG INT n )BOOL:
         IF   n <= UPB prime THEN prime[ SHORTEN n ]
         ELIF NOT ODD n      THEN FALSE
         ELSE
             LONG INT f          :=  3;
             LONG INT f2         :=  9;
             LONG INT to next    := 16;
             BOOL     is a prime := TRUE;
             WHILE f2 <= n AND is a prime DO
                 is a prime := n MOD f /= 0;
                 f         +:= 2;
                 f2        +:= to next;
                 to next   +:= 8
             OD;
             is a prime
         FI # is prime # ;
    # sum the primes and test the sums                                        #
    print( ( "The first 30 extreme primes:", newline ) );
    print( ( whole( 2, -6 ), " " ) );  # 2 is the first prime so is "extreme" #
    INT      prime sum count := 1;
    LONG INT prime sum       := 2;
    LONG INT candidate       := 1;
    WHILE prime sum count < 5 000 DO
        IF is prime( candidate +:= 2 ) THEN
            prime sum +:= candidate;                    # have another prime #
            IF is prime( prime sum ) THEN      # the prime sum is also prime #
                prime sum count +:= 1;
                IF prime sum count <= 30 THEN
                    print( ( whole( prime sum, -6 )
                           , IF prime sum count MOD 10 = 0 THEN newline ELSE " " FI
                           )
                         )
                ELIF prime sum count MOD 1000 = 0 THEN
                    print( ( "Extreme prime ", whole( prime sum count, -5 )
                           , " is ",           whole( candidate,      -12 )
                           , ", sum: ",        whole( prime sum,      -18 )
                           , newline
                           )
                         )
                FI
            FI
        FI
    OD
END
