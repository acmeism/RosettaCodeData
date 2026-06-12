BEGIN # find twin primes whose sum is a square, i.e.:                        #
      # find primes p such that p + 2 is prime and p + p + 2 is a square     #

    INT max prime = 10 000 000;         # maximum possible prime to consider #
    PROC is prime = ( INT n )BOOL:
         BEGIN
            BOOL result := n = 2 OR ( ODD n AND n > 1 );
            FOR k FROM 3 BY 2 WHILE result AND k * k <= n DO result := n MOD k /= 0 OD;
            result
         END # is prime # ;

    # if p is a twin prime then we want p where 2p + 2 = x^2 for some x      #
    # x must be even                                                         #
    FOR x FROM 2 BY 2 TO ENTIER sqrt( ( 2 * max prime ) + 2 ) DO
        INT x2 = x * x;
        INT p = ( x2 - 2 ) OVER 2;
        IF is prime( p ) THEN
            IF is prime( p + 2 ) THEN
                STRING twin sum = whole( p, -8  ) + " + " + whole( p + 2, 0 );
                INT    twin len = ( UPB twin sum - LWB twin sum ) + 1;
                print( ( twin sum, " " * ( 18 - twin len ), " = " ) );
                print( ( whole( x, 0 ), "^2", newline ) )
            FI
        FI
    OD

END
