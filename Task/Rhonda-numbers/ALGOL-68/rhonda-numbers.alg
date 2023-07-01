BEGIN # find some Rhonda numbers: numbers n in base b such that the product  #
      # of the digits of n is b * the sum of the prime factors of n          #

    # returns the sum of the prime factors of n                              #
    PROC factor sum = ( INT n )INT:
         BEGIN
             INT result := 0;
             INT v      := ABS n;
             WHILE v > 1 AND v MOD 2 = 0 DO
                 result +:= 2;
                 v   OVERAB 2
             OD;
             FOR f FROM 3 BY 2 WHILE v > 1 DO
                 WHILE v > 1 AND v MOD f = 0 DO
                     result +:= f;
                     v   OVERAB f
                 OD
             OD;
             result
         END # factor sum # ;
    # returns the digit product of n in the specified base                   #
    PROC digit product = ( INT n, base )INT:
         IF n = 0 THEN 0
         ELSE
             INT result := 1;
             INT v      := ABS n;
             WHILE v > 0 DO
                 result *:= v MOD base;
                 v   OVERAB base
             OD;
             result
         FI # digit product # ;
    # returns TRUE  if n is a Rhonda number in the specified base,           #
    #         FALSE otherwise                                                #
    PROC is rhonda = ( INT n, base )BOOL: base * factor sum( n ) = digit product( n, base );

    # returns TRUE if n is prime, FALSE otherwise                            #
    PROC is prime = ( INT n )BOOL:
         IF   n < 3       THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELIF NOT ODD n   THEN FALSE
         ELSE
             INT  f          := 5;
             INT  f2         := 25;
             INT  to next    := 24;
             BOOL is a prime := TRUE;
             WHILE f2 <= n AND is a prime DO
                 is a prime := n MOD f /= 0;
                 f         +:= 2;
                 f2        +:= to next;
                 to next   +:= 8
             OD;
             is a prime
         FI # is prime # ;
    # returns a string representation of n in the specified base             #
    PROC to base string = ( INT n, base )STRING:
         IF n = 0 THEN "0"
         ELSE
             INT under 10 = ABS "0";
             INT over 9   = ABS "a" - 10;
             STRING result := "";
             INT    v      := ABS n;
             WHILE v > 0 DO
                 INT d = v MOD base;
                 REPR ( d + IF d < 10 THEN under 10 ELSE over 9 FI ) +=: result;
                 v OVERAB base
             OD;
             result
         FI # to base string # ;
    # find the first few Rhonda numbers in non-prime bases 2 .. max base     #
    INT max rhonda = 10;
    INT max base   = 16;
    FOR base FROM 2 TO max base DO
        IF NOT is prime( base ) THEN
            print( ( "The first ", whole( max rhonda, 0 )
                   , " Rhonda numbers in base ", whole( base, 0 )
                   , ":", newline
                   )
                 );
            INT r count := 0;
            [ 1 : max rhonda ]INT rhonda;
            FOR n WHILE r count < max rhonda DO
                IF is rhonda( n, base ) THEN
                    rhonda[ r count +:= 1 ] := n
                FI
            OD;
            print( ( "    in base 10:" ) );
            FOR i TO max rhonda DO print( ( " ", whole( rhonda[ i ], 0 ) ) ) OD;
            print( ( newline ) );
            IF base /= 10 THEN
                print( ( "    in base ", whole( base, -2 ), ":" ) );
                FOR i TO max rhonda DO print( ( " ", to base string( rhonda[ i ], base ) ) ) OD;
                print( ( newline ) )
            FI
        FI
    OD
END
