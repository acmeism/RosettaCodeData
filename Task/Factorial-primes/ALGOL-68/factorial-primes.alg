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
# end of code based on the primality by trial division task              #

    LONG INT f        := 1;
    INT      fp count := 0;
    FOR n WHILE fp count < 10 DO
        f *:= n;
        CHAR fp op := "-";
        FOR offset FROM -1 BY 2 TO 1 DO
            IF  LONG INT fp = f + offset;
                is prime( fp )
            THEN
                print( ( whole( fp count +:= 1, -2 ), ":", whole( n, -4 )
                       , "! ", fp op, " 1 = ", whole( fp, 0 )
                      , newline
                      )
                    )
            FI;
            fp op := "+"
        OD
    OD
END
