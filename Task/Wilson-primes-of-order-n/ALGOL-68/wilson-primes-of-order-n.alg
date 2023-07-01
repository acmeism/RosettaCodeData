BEGIN # find Wilson primes of order n, primes such that:                    #
      #                    ( ( n - 1 )! x ( p - n )! - (-1)^n ) mod p^2 = 0 #
    PR read "primes.incl.a68" PR                  # include prime utilities #
    []BOOL primes = PRIMESIEVE 11 000;         # sieve the primes to 11 500 #
    # returns TRUE if p is an nth order Wilson prime                        #
    PROC is wilson = ( INT n, p )BOOL:
         IF p < n THEN FALSE
         ELSE
            LONG INT p2    = p * p;
            LONG INT prod := 1;
            FOR i TO n - 1 DO # prod := ( n - 1 )! MOD p2                    #
                prod := ( prod * i ) MOD p2
            OD;
            FOR i TO p - n DO # prod := ( ( p - n )! * ( n - 1 )! ) MOD p2   #
                prod := ( prod * i ) MOD p2
            OD;
            0 = ( p2 + prod + IF ODD n THEN 1 ELSE -1 FI ) MOD p2
         FI # is wilson # ;
    # find the Wilson primes #
    print( ( " n: Wilson primes", newline ) );
    print( ( "-----------------", newline ) );
    FOR n TO 11 DO
        print( ( whole( n, -2 ), ":" ) );
        IF is wilson( n, 2 ) THEN print( ( " 2" ) ) FI;
        FOR p FROM 3 BY 2 TO UPB primes DO
            IF primes[ p ] THEN
                IF is wilson( n, p ) THEN print( ( " ", whole( p, 0 ) ) ) FI
            FI
        OD;
        print( ( newline ) )
    OD
END
