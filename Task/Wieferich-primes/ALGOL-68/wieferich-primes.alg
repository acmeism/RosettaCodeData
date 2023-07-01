BEGIN # find Wierferich Primes: primes p where p^2 evenly divides 2^(p-1)-1  #

    INT max number = 5 000; # maximum number we will consider                #
    # set precision of LONG LONG INT - p^5000 has over 1500 digits           #
    PR precision 1600 PR
    PR read "primes.incl.a68" PR                    # include prime utlities #
    # get a list of primes up to max number                                  #
    []INT prime = EXTRACTPRIMESUPTO max number
                     FROMPRIMESIEVE PRIMESIEVE max number;

    # find the primes                                                        #
    INT           p pos            := LWB prime;
    LONG LONG INT two to p minus 1 := 1;
    INT           power            := 0;
    INT           w count          := 0;
    WHILE w count < 2 DO
        INT p = prime[ p pos ];
        WHILE power < ( p - 1 ) DO
            two to p minus 1 *:= 2;
            power            +:= 1
        OD;
        IF ( two to p minus 1 - 1 ) MOD ( p * p ) = 0 THEN
            print( ( " ", whole( p, 0 ) ) );
            w count +:= 1
        FI;
        p pos +:= 1
    OD
END
