BEGIN # find some primorial primes - primes that are p - 1 or p + 1      #
      #      for some primorial p                                        #

# is prime PROC based on the one in the primality by trial division task #
  PROC is prime = ( LONG INT p )BOOL:
    IF p <= 1 OR NOT ODD p THEN
      p = 2
    ELSE
      BOOL prime := TRUE;
      FOR i FROM 3 BY 2 TO SHORTEN ENTIER long sqrt(p) WHILE prime := p MOD i /= 0 DO SKIP OD;
      prime
    FI;
# end of code based on the primality by trial divisio task               #

    # construct a sieve of primes up to 200                              #
    [ 0 : 200 ]BOOL primes;
    primes[ 0 ] := primes[ 1 ] := FALSE;
    primes[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB primes DO primes[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB primes DO primes[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB primes ) DO
        IF primes[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB primes DO primes[ s ] := FALSE OD
        FI
    OD;

    PROC show primorial prime = ( INT p number, INT n, CHAR p op, LONG INT p )VOID:
       print( ( whole( p number, -2 ), ":", whole( n, -4 )
              , "# ", p op, " 1 = ", whole( p, 0 )
              , newline
              )
            );

    LONG INT pn      := 1;
    INT      p count := 0;
    INT      p pos   := 0;
    # starting from primorial 0, which is defined to be 1                #
    FOR n FROM 0 WHILE p count < 12 DO
        IF  LONG INT p = pn - 1;
            is prime( p )
        THEN
            show primorial prime( p count +:= 1, n, "-", p )
        FI;
        IF  LONG INT p = pn + 1;
            is prime( p )
        THEN
            show primorial prime( p count +:= 1, n, "+", p )
        FI;
        # find the next prime                                            #
        WHILE NOT primes[ p pos +:= 1 ] DO SKIP OD;
        pn *:= p pos
    OD
END
