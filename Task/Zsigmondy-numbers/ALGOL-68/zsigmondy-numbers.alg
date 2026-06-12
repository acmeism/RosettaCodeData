BEGIN # find some Zsigmondy numbers                                      #

    # integral mode that has precision to suit the task - adjust to suit #
    MODE INTEGER = LONG INT;
    # returns the square root of n, use the sqrt routine appropriate for #
    #         the INTEGER mode                                           #
    PROC isqrt   = ( INTEGER n )INTEGER: ENTIER long sqrt( n );

    # returns the gcd of m and n                                         #
    PRIO GCD = 1;
    OP   GCD = ( INTEGER m, n )INTEGER:
         BEGIN
            INTEGER a := ABS m, b := ABS n;
            WHILE b /= 0 DO
               INTEGER new a = b;
               b            := a MOD b;
               a            := new a
            OD;
            a
         END # GCD # ;

    # returns TRUE if all m are coprime to n, FALSE otherwise            #
    PRIO ALLCOPRIME = 1;
    OP   ALLCOPRIME = ( []INTEGER m, INTEGER n )BOOL:
         BEGIN
            BOOL     coprime := TRUE;
            FOR i FROM LWB m TO UPB m WHILE coprime := ( m[ i ] GCD n ) = 1 DO SKIP OD;
            coprime
         END # ALLCOPRIME # ;

    # returns the sequence of Zsigmondy numbers of n to a, b             #
    PROC zsigmondy = ( INT n, a, b )[]INTEGER:
         BEGIN
            [ 1 : n - 1 ]INTEGER am minus bm;
            INTEGER am := 1, bm := 1;
            FOR m TO n - 1 DO
                am minus bm[ m ] := ( am *:= a ) - ( bm *:= b )
            OD;
            INTEGER an := 1, bn := 1;
            [ 1 : n ]INTEGER z;
            FOR i TO n DO
                INTEGER an minus bn      = ( an *:= a ) - ( bn *:= b );
                INTEGER largest divisor := 1;
                IF am minus bm[ 1 : i - 1 ] ALLCOPRIME an minus bn THEN
                    largest divisor := an minus bn
                ELSE
                    INTEGER d     := 1;
                    INTEGER max d := isqrt( an minus bn );
                    INT     step   = IF ODD an minus bn THEN 2 ELSE 1 FI;
                    WHILE ( d +:= step ) <= max d AND largest divisor <= max d DO
                        IF an minus bn MOD d = 0 THEN
                            # d is a divisor of a^n - b^n                #
                            IF d > largest divisor THEN
                                IF am minus bm[ 1 : i - 1 ] ALLCOPRIME d THEN largest divisor := d FI
                            FI;
                            INTEGER other d = an minus bn OVER d;
                            IF other d > d AND other d > largest divisor THEN
                                IF am minus bm[ 1 : i - 1 ] ALLCOPRIME other d THEN
                                    largest divisor := other d
                                FI
                            FI
                        FI
                    OD
                FI;
                z[ i ] := largest divisor
            OD;
            z
         END # zsigmondy # ;

    [,]INT tests = ( ( 2, 1 ), ( 3, 1 ), ( 4, 1 ), ( 5, 1 ), ( 6, 1 )
                   , ( 7, 1 ), ( 3, 2 ), ( 5, 3 ), ( 7, 3 ), ( 7, 5 )
                   );
    FOR i FROM LWB tests TO UPB tests DO
        INT a = tests[ i, 1 ], b = tests[ i, 2 ];
        []INTEGER z = zsigmondy( 20, a, b );
        print( ( "zsigmondy( 20, ", whole( a, 0 ), ", ", whole( b, 0 ), " ):", newline, "    " ) );
        FOR z pos FROM LWB z TO UPB z DO print( ( " ", whole( z[ z pos ], 0 ) ) ) OD;
        print( ( newline, newline ) )
    OD

END
