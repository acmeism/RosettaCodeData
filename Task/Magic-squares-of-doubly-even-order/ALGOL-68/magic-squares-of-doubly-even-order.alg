BEGIN # Magic squares of doubly even order #
    PROC doubly even magic square = ( INT n )[,]INT:
         IF n MOD 4 /= 0 THEN
            # not a doubly even number #
            [ 1 : 0, 1 : 0 ]INT empty square;
            empty square
         ELSE
            # ok to create the square #
            [ 1 : 4, 1 : 4 ]INT pattern;
            FOR r TO 4 DO
                FOR c TO 4 DO
                    pattern[ r, c ] := IF ( ( c = 1 OR c = 4 ) AND ( r = 1 OR r = 4 ) )
                                       OR ( ( c = 2 OR c = 3 ) AND ( r = 2 OR r = 3 ) )
                                       THEN 1
                                       ELSE 0
                                       FI
                OD
            OD;
            [ 1 : n, 1 : n ]INT result;
            INT s  = n * n, m = n OVER 4;
            INT i := 0;
            FOR r TO n DO
                FOR c TO n DO
                    result[ r, c ] := IF pattern[ ( r - 1 ) OVER m + 1, ( c - 1 ) OVER m + 1 ] = 1
                                      THEN i + 1
                                      ELSE s - i
                                      FI;
                    i +:= 1
                OD
            OD;
            result
         FI # doubly eben magic square # ;
    # test doubly even magic square #
    FOR order FROM 8 BY 4 TO 12 DO
        # calculate the field width for the elements of the square #
        INT w := 1, v := order * order;
        WHILE ( v OVERAB 10 ) > 0 DO w +:= 1 OD;
        # construct the square #
        [,]INT square = doubly even magic square( order );
        print( ( "magic square -- n = ", whole( order, 0 ), newline ) );
        FOR r FROM 1 LWB square TO 1 UPB square DO
            FOR c FROM 2 LWB square TO 2 UPB square DO
                print( ( " ", whole( square[ r, c ], - w ) ) )
            OD;
            print( ( newline ) )
        OD;
        print( ( "magic constant = ", whole( ( ( ( order * order ) + 1 ) * order ) OVER 2, 0 ), newline ) )
    OD
END
