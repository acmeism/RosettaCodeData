BEGIN # Integer square roots #
    PR precision 200 PR
    # returns the integer square root of x; x must be >= 0                   #
    PROC isqrt = ( LONG LONG INT x )LONG LONG INT:
         IF   x < 0 THEN print( ( "Negative number in isqrt", newline ) );stop
         ELIF x < 2 THEN x
         ELSE
            # x is greater than 1                                            #
            # find a power of 4 that's greater than x                        #
            LONG LONG INT q := 1;
            WHILE q <= x DO q *:= 4 OD;
            # find the root                                                  #
            LONG LONG INT z := x;
            LONG LONG INT r := 0;
            WHILE q > 1 DO
                q OVERAB 4;
                LONG LONG INT t = z - r - q;
                r OVERAB 2;
                IF t >= 0 THEN
                    z  := t;
                    r +:= q
                FI
            OD;
            r
         FI; # isqrt #
    # returns a string representation of n with commas                       #
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
    # left-pads a string to at least n characters                            #
    PROC pad left = ( STRING s, INT n )STRING:
         BEGIN
             STRING result := s;
             WHILE ( UPB result - LWB result ) + 1 < n DO " " +=: result OD;
             result
         END; # pad left #
    # task test cases #
    print( ( "Integer square roots of 0..65", newline ) );
    FOR i FROM 0 TO 65 DO print( ( " ", whole( isqrt( i ), 0 ) ) ) OD;
    print( ( newline ) );
    # integer square roots of odd powers of 7                                #
    print( ( "Integer square roots of 7^n", newline ) );
    print( ( " n|", pad left( "7^n", 82 ), "|", pad left( "isqrt(7^n)", 42 ), newline ) );
    LONG LONG INT p7 := 7;
    FOR p BY 2 TO 73 DO
        print( ( whole( p, -2 )
               , "|"
               , pad left( commatise(        p7   ), 82 )
               , "|"
               , pad left( commatise( isqrt( p7 ) ), 42 )
               , newline
               )
             );
        p7 *:= 49
    OD
END
