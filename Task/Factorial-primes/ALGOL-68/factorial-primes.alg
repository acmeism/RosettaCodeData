BEGIN # find some factorial primes - primes that are f - 1 or f + 1      #
      #      for some factorial f                                        #

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

    PROC show factorial prime = ( INT fp number, INT n, CHAR fp op, LONG INT fp )VOID:
       print( ( whole( fp number, -2 ), ":", whole( n, -4 )
              , "! ", fp op, " 1 = ", whole( fp, 0 )
              , newline
              )
            );
    LONG INT f        := 1;
    INT      fp count := 0;
    FOR n WHILE fp count < 10 DO
        f *:= n;
        IF  LONG INT fp = f - 1;
            is prime( fp )
        THEN
            show factorial prime( fp count +:= 1, n, "-", fp )
        FI;
        IF  LONG INT fp = f + 1;
            is prime( fp )
        THEN
            show factorial prime( fp count +:= 1, n, "+", fp )
        FI
    OD
END
