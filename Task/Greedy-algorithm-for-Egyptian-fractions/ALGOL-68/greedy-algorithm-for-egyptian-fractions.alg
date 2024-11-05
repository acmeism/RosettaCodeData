BEGIN # compute some Egyptian fractions #
    PR precision 2000 PR # set the number of digits for LONG LONG INT #
    PROC gcd = ( LONG LONG INT a, b )LONG LONG INT:
        IF b = 0 THEN
            IF a < 0 THEN
                - a
            ELSE
                a
            FI
        ELSE
            gcd( b, a MOD b )
        FI ; # gcd #
    MODE RATIONAL       = STRUCT( LONG LONG INT num, den );
    MODE LISTOFRATIONAL = STRUCT( RATIONAL element, REF LISTOFRATIONAL next );
    REF LISTOFRATIONAL  nil list of rational = NIL;
    OP   TOSTRING = (           INT a )STRING: whole( a, 0 );
CO  OP   TOSTRING = (      LONG INT a )STRING: whole( a, 0 ); # not needed for the task # CO
    OP   TOSTRING = ( LONG LONG INT a )STRING: whole( a, 0 );
    OP   TOSTRING = (      RATIONAL a )STRING:
         IF den OF a = 1
         THEN TOSTRING num OF a
         ELSE TOSTRING num OF a + "/" + TOSTRING den OF a
         FI ; # TOSTRING #
    OP   TOSTRING = ( REF LISTOFRATIONAL lr )STRING:
         BEGIN
             REF LISTOFRATIONAL p      := lr;
             STRING             result := "[";
             WHILE p ISNT nil list of rational DO
                 result +:= TOSTRING element OF p;
                 IF next OF p IS nil list of rational THEN
                     p := NIL
                 ELSE
                     p := next OF p;
                     result +:= " + "
                 FI
             OD;
             result + "]"
         END ; # TOSTRING #
    OP   CEIL = ( LONG LONG REAL v )LONG LONG INT:
         IF LONG LONG INT result := ENTIER v;
            ABS v > ABS result
         THEN result + 1
         ELSE result
         FI ;  # CEIL #
    OP   EGYPTIAN = ( RATIONAL rp )REF LISTOFRATIONAL:
         IF RATIONAL r := rp;
            num OF r = 0 OR num OF r = 1
         THEN HEAP LISTOFRATIONAL := ( r, nil list of rational )
         ELSE
            REF LISTOFRATIONAL result     := nil list of rational;
            REF LISTOFRATIONAL end result := nil list of rational;
            PROC add = ( RATIONAL rn )VOID:
                 IF end result IS nil list of rational THEN
                    result     := HEAP LISTOFRATIONAL := ( rn, nil list of rational );
                    end result := result
                 ELSE
                    next OF end result := HEAP LISTOFRATIONAL := ( rn, nil list of rational );
                    end result         := next OF end result
                 FI ; # add #
            IF num OF r > den OF r THEN
                add( RATIONAL( num OF r OVER den OF r, 1 ) );
                r := ( num OF r MOD den OF r, den OF r )
            FI;
            PROC mod func = ( LONG LONG INT m, n )LONG LONG INT: ( ( m MOD n ) + n ) MOD n;
            WHILE num OF r /= 0 DO
                LONG LONG INT q = CEIL( den OF r / num OF r );
                add( RATIONAL( 1, q ) );
                r := RATIONAL( mod func( - ( den OF r ), num OF r ), ( den OF r ) * q )
            OD;
            result
         FI ; # EGYPTIAN #
    BEGIN # task test cases #
        []RATIONAL test cases = ( RATIONAL( 43, 48 ), RATIONAL( 5, 121 ), RATIONAL( 2014, 59 ) );
        FOR r pos FROM LWB test cases TO UPB test cases DO
            print( ( TOSTRING test cases[ r pos ], " -> ", TOSTRING EGYPTIAN test cases[ r pos ], newline ) )
        OD;
        # find the fractions with the most terms and the largest denominator #
        print( ( "For rationals with numerator and denominator in 1..99:", newline ) );
        RATIONAL           largest denominator  := ( 0, 1 );
        REF LISTOFRATIONAL max denominator list := nil list of rational;
        LONG LONG INT      max denominator      := 0;
        RATIONAL           most terms           := ( 0, 1 );
        REF LISTOFRATIONAL most terms list      := nil list of rational;
        INT                max terms            := 0;
        FOR num TO 99 DO
            FOR den TO 99 DO
                RATIONAL           r  = RATIONAL( num, den );
                REF LISTOFRATIONAL e := EGYPTIAN r;
                REF LISTOFRATIONAL p := e;
                INT terms := 0;
                WHILE p ISNT nil list of rational DO
                   terms +:= 1;
                   IF den OF element OF p > max denominator THEN
                       largest denominator  := r;
                       max denominator      := den OF element OF p;
                       max denominator list := e
                   FI;
                   p := next OF p
                OD;
                IF terms > max terms THEN
                    most terms      := r;
                    max terms       := terms;
                    most terms list := e
                FI
            OD
        OD;
        print( ( "    ", TOSTRING most terms, " has the most terms: ", TOSTRING max terms, newline
               , "    ", TOSTRING most terms list, newline
               )
             );
        print( ( "    ", TOSTRING largest denominator, " has the largest denominator:", newline
               , "    ", TOSTRING max denominator list, newline
               )
             )
    END
END
