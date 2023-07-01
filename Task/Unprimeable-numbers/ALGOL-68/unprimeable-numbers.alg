BEGIN # find unprimable numbers - numbers which can't be made into a prime by changing one digit #
    # construct a sieve of primes up to max prime #
    PR read "primes.incl.a68" PR
    INT max prime = 9 999 999;
    []BOOL prime = PRIMESIEVE max prime;
    # returns TRUE if n is unprimeable, FALSE otherwise #
    PROC is unprimeable = ( INT n )BOOL:
         IF   n < 100
         THEN FALSE
         ELIF prime[ n ]
         THEN FALSE
         ELIF
            # need to try changing a digit #
            INT last digit     = n MOD 10;
            INT leading digits = n - last digit;
            prime[ leading digits + 1 ]
         THEN FALSE
         ELIF prime[ leading digits + 3 ] THEN FALSE
         ELIF prime[ leading digits + 7 ] THEN FALSE
         ELIF prime[ leading digits + 9 ] THEN FALSE
         ELIF last digit = 2 OR last digit = 5
         THEN
            # the final digit is 2 or 5, changing the other digits can't make a prime #
            # unless there is only one other digit which we change to 0 #
            INT v  := leading digits;
            INT dc :=  1;
            WHILE ( v OVERAB 10 ) > 0 DO IF v MOD 10 /= 0 THEN dc +:= 1 FI OD;
            dc /= 2
         ELIF NOT ODD last digit
         THEN TRUE # last digit is even - can't make a prime #
         ELSE
            # last digit is 1, 3, 7, 9: must try changing the other digoits #
            INT m10     :=  10;
            INT r10     := 100;
            BOOL result := TRUE;
            WHILE result AND n > r10 DO
               INT base = ( ( n OVER r10 ) * r10 ) + ( n MOD m10 );
               FOR i FROM 0 BY m10 WHILE result AND i < r10 DO
                   result := NOT prime[ base + i ]
               OD;
               m10 *:= 10;
               r10 *:= 10
            OD;
            IF result THEN
                # still not unprimeable, try changing the first digit #
                INT base = n MOD m10;
                FOR i FROM 0 BY m10 WHILE result AND i < r10 DO
                    result := NOT prime[ base + i ]
                OD
            FI;
            result
         FI # is unprimeable # ;
    # returns a string representation of n with commas #
    PROC commatise = ( LONG LONG INT n )STRING:
         BEGIN
            STRING result      := "";
            STRING unformatted  = whole( n, 0 );
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF   ch count <= 2 THEN ch count +:= 1
                ELSE                    ch count  := 1; "," +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END; # commatise #
    # find unprimeable numbers #
    INT u count := 0;
    INT d count := 0;
    [ 0 : 9 ]INT first unprimeable := []INT( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )[ AT 0 ];
    FOR i FROM 100 WHILE i < UPB prime AND d count < 10 DO
        IF is unprimeable( i ) THEN
            u count +:= 1;
            IF   u count =   1 THEN
                print( ( "First 35 unprimeable numbers: ", whole( i, 0 ) ) )
            ELIF u count <= 35 THEN
                print( ( " ", whole( i, 0 ) ) )
            ELIF u count = 600 THEN
                print( ( newline, "600th unprimeable number: ", commatise( i ) ) )
            FI;
            INT final digit = i MOD 10;
            IF first unprimeable[ final digit ] = 0 THEN
                # first unprimeable number with this final digit #
                d count +:= 1;
                first unprimeable[ final digit ] := i
            FI
        FI
    OD;
    # show the first unprimeable number that ends with each digit #
    print( ( newline ) );
    FOR i FROM 0 TO 9 DO
        print( ( "First unprimeable number ending in "
               , whole( i, 0 )
               , ": "
               , commatise( first unprimeable[ i ] )
               , newline
               )
             )
    OD
END
