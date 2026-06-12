BEGIN # show some strange numbers - numbers whose digits differ by a prime #
    # returns TRUE if n is strange, FALSE otherwise                        #
    PROC is strange = ( INT n )BOOL:
         BEGIN
            INT d1       := ABS n MOD  10;
            INT v        := ABS n OVER 10;
            BOOL strange := TRUE;
            WHILE strange AND v > 0 DO
                INT d2     = v MOD 10;
                v     OVERAB 10;
                INT diff   = ABS ( d1 - d2 );
                strange   := diff = 2 OR diff = 3 OR diff = 5 OR diff = 7;
                d1        := d2
            OD;
            strange
         END # is strange # ;
    INT s count := 0;
    FOR n FROM 101 TO 499 DO
        IF is strange( n ) THEN
            print( ( whole( n, -4 ) ) );
            IF ( s count +:= 1 ) MOD 20 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
