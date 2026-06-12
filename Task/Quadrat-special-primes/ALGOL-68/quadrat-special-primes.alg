BEGIN # find some primes where the gap between the current prime and the next is a square #
    # an array of squares #
    PROC get squares = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT s;
            FOR i TO n DO s[ i ] := i * i OD;
            s
         END # get squares # ;
    INT max number = 16000;
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE    max number;
    []INT square = get squares(  max number );
    INT   p count, this prime, next prime;
    # the first square gap is 1 (between 2 and 3) the gap between all other primes is even #
    # so we treat 2-3 as a special case                                                    #
    p count := 1; this prime := 2; next prime := 3;
    print( ( " ", whole( this prime, -5 ) ) );
    WHILE next prime < max number DO
        this prime := next prime;
        p count   +:= 1;
        print( ( " ", whole( this prime, -5 ) ) );
        IF p count MOD 12 = 0 THEN print( ( newline ) ) FI;
        INT sq pos := 2;
        WHILE next prime := this prime + square[ sq pos ];
              IF next prime < max number THEN NOT prime[ next prime ] ELSE FALSE FI
        DO sq pos +:= 2 OD
    OD
END
