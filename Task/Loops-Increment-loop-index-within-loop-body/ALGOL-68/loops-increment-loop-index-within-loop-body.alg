BEGIN
    # returns TRUE if n is prime, FALSE otherwise #
    PROC is prime = ( LONG INT n )BOOL:
         IF   n MOD 2 = 0 THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELSE
            LONG INT d := 5;
            BOOL result := TRUE;
            WHILE IF   d * d > n   THEN FALSE
                  ELIF n MOD d = 0 THEN result := FALSE
                  ELIF d +:= 2;
                       n MOD d = 0 THEN result := FALSE
                  ELSE d +:= 4; TRUE
                  FI
            DO SKIP OD;
            result
         FI # is prime # ;

    LONG INT i := 42;
    LONG INT n := 0;
    WHILE n < 42 DO
        IF is prime( i ) THEN
            n +:= 1;
            print( ( "n = "
                   , whole( n,  -2 )
                   , "  "
                   , whole( i, -19 )
                   , newline
                   )
                 );
            i +:= i - 1
        FI;
        i +:= 1
    OD
END
