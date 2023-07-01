BEGIN # find circular primes - primes where all cyclic permutations  #
      # of the digits are also prime                                 #
    # genertes a sieve of circular primes, only the first            #
    # permutation of each prime is flagged as TRUE                   #
    OP   CIRCULARPRIMESIEVE = ( INT n )[]BOOL:
         BEGIN
            [ 0 : n ]BOOL prime;
            prime[ 0 ] := prime[ 1 ] := FALSE;
            prime[ 2 ] := TRUE;
            FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
            FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
            FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
                IF prime[ i ] THEN
                    FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
                FI
            OD;
            INT first digit multiplier := 10;
            INT max with multiplier    := 99;
            # the 1 digit primes are non-curcular, so start at 10    #
            FOR i FROM 10 TO UPB prime DO
                IF i > max with multiplier THEN
                    # starting a new power of ten                    #
                    first digit multiplier *:= 10;
                    max with multiplier    *:= 10 +:= 9
                FI;
                IF prime[ i ] THEN
                    # have a prime #
                    # cycically permute the number until we get back #
                    # to the original - flag all the permutations    #
                    # except the original as non-prime               #
                    INT permutation := i;
                    WHILE permutation :=   ( permutation OVER 10 )
                                       + ( ( permutation MOD  10 ) * first digit multiplier )
                                       ;
                          permutation /= i
                    DO
                        IF NOT prime[ permutation ] THEN
                            # the permutation is not prime           #
                            prime[ i ] := FALSE
                        ELIF permutation > i THEN
                            # haven't permutated e.g. 101 to 11      #
                            IF NOT prime[ permutation ] THEN
                                # i is not a circular prime          #
                                prime[ i ] := FALSE
                            FI;
                            prime[ permutation ] := FALSE
                        FI
                    OD
                FI
            OD;
            prime
         END # CIRCULARPRIMESIEVE # ;
    # construct a sieve of circular primes up to 999 999              #
    # only the first permutation is included                          #
    []BOOL prime = CIRCULARPRIMESIEVE 999 999;
    # print the first 19 circular primes #
    INT c count := 0;
    print( ( "First 19 circular primes: " ) );
    FOR i WHILE c count < 19 DO
        IF prime[ i ] THEN
            print( ( " ", whole( i, 0 ) ) );
            c count +:= 1
        FI
    OD;
    print( ( newline ) )
END
