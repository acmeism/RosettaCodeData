BEGIN # Legendre prime counting function - translation of EasyLang/Go non-memoised version #

    PR read "primes.incl.a68" PR      # include RC prime utilities #

    OP   PI = ( INT n )INT:
         IF   n < 2 THEN 0
         ELIF n = 2 THEN 1
         ELSE
            INT root n      = ENTIER sqrt( n );
            []INT primes    = EXTRACTPRIMESUPTO root n FROMPRIMESIEVE PRIMESIEVE root n;
            INT prime count = UPB primes;

            PROC phi = ( INT x, a in )INT:
                 BEGIN
                    INT a := a in, sum := 0;
                    BOOL continue := TRUE;
                    WHILE a > 1 AND continue DO
                       INT pa = primes[ a ];
                       IF x <= pa THEN
                          continue := FALSE
                       ELSE
                          a   -:= 1;
                          sum +:= phi( x OVER pa, a )
                       FI
                    OD;
                    IF continue THEN x - ( x OVER 2 ) - sum ELSE 1 FI
                 END;

            phi( n, prime count ) + prime count - 1
         FI;

    FOR i FROM 0 TO 9 DO
        INT n = 10 ^ i;
        print( ( "10^", whole( i, 0 ), "  ", whole( PI n, 0 ), newline ) )
    OD
END
