BEGIN # Lunar arithmetic                                                     #

    INT max lunar digits = ENTIER log( max int ); # maximum number of digits #
                                                  # a lunar number can have  #
                                                  # if stored in an INT      #
    [ 1 : max lunar digits + 1 ]INT lunar digits;

    PRIO +> = 6, <* = 7;                        # same priorities as + and * #
    OP   +> = ( INT a, b )INT:                   # lunar addition of a and b #
         IF a < 0 OR b < 0
         THEN print( ( "Lunar numbers must be non-negative", newline ) );
              stop
         ELIF a = b
         THEN a
         ELSE INT v1 := a, v2 := b;
              INT d pos := 0;
              WHILE v1 > 0 OR v2 > 0 DO
                  INT d1 = v1 MOD 10, d2 = v2 MOD 10;
                  lunar digits[ d pos +:= 1 ] := IF d1 > d2 THEN d1 ELSE d2 FI;
                  v1 OVERAB 10;
                  v2 OVERAB 10
              OD;
              INT result := lunar digits[ d pos ];
              WHILE ( d pos -:= 1 ) > 0 DO
                  result *:= 10 +:= lunar digits[ d pos ]
              OD;
              result
         FI # +> # ;
    PRIO +>:= = 1;              # lunar add-and-assign, same priority as +:= #
    OP   +>:= = ( REF INT a, INT b )REF INT: a := a +> b;

    OP   <* = ( INT a, b )INT:             # lunar multiplication of a and b #
         IF a < 0 OR b < 0
         THEN printf( ( "Lunar numbers must be non-negative", newline ) );
              stop
         ELIF a = 0 OR b = 0
         THEN 0
         ELSE INT v2 := b, multiplier := 1;
              INT result := 0;
              WHILE v2 > 0 DO
                  INT d2     = v2 MOD 10;
                  INT d pos := 0;
                  INT v1    := a;
                  WHILE v1 > 0 DO
                      INT d1 = v1 MOD 10;
                      lunar digits[ d pos +:= 1 ] := IF d1 < d2 THEN d1 ELSE d2 FI;
                      v1 OVERAB 10
                  OD;
                  INT p1 := lunar digits[ d pos ];
                  WHILE ( d pos -:= 1 ) > 0 DO
                      p1 *:= 10 +:= lunar digits[ d pos ]
                  OD;
                  result    +>:= p1 * multiplier;
                  multiplier *:= 10;
                  v2 OVERAB 10
              OD;
              result
         FI # <* # ;
    PRIO <*:= = 1;         # lunar multiply-and-assign, same priority as *:= #
    OP   <*:= = ( REF INT a, INT b )REF INT: a := a <* b;

    OP   +> = ( []INT a )INT:          # lunar addition of the elements of a #
         BEGIN
            INT result := IF UPB a < LWB a THEN 0 ELSE a[ LWB a ] FI;
            FOR a pos FROM LWB a + 1 TO UPB a DO
                result +>:= a[ a pos ]
            OD;
            result
         END # +> # ;
    OP   CX = ( []INT a )INT:    # lunar multiplication of the elements of a #
         BEGIN         # unfortunately, <* isn't a valid unary operator name #
            INT result := IF UPB a < LWB a THEN 0 ELSE a[ LWB a ] FI;
            FOR a pos FROM LWB a + 1 TO UPB a DO
                result <*:= a[ a pos ]
            OD;
            result
         END # CX # ;

    BEGIN # task                                                             #
        [][]INT tests = ( ( 976, 348 ), ( 23, 321 ), ( 232, 35 ), ( 123, 32192, 415, 8 ) );
        PROC show test = ( []INT v, STRING op name, INT result )VOID:
             IF UPB v >= LWB v THEN
                print( ( whole( v[ LWB v ], -8 ) ) );
                FOR v pos FROM LWB v + 1 TO UPB v DO
                    print( ( " ", op name, " ", whole( v[ v pos ], 0 ) ) )
                OD;
                print( ( " = ", whole( result, 0 ), newline ) )
             FI # show test # ;

        print( ( "Lunar addition (+>):", newline ) );
        FOR t pos FROM 1 LWB tests TO 1 UPB tests DO
            show test( tests[ t pos ], "+>", +> tests[ t pos ] )
        OD;
        print( ( "Lunar multiplication (<*):", newline ) );
        FOR t pos FROM 1 LWB tests TO 1 UPB tests DO
            show test( tests[ t pos ], "<*", CX tests[ t pos ] )
        OD;
        BEGIN
            print( ( "The first 20 distinct even lunar numbers:", newline, "      " ) );
            [ 0 : 1000 ]BOOL even;              # assume they are all < 1001 #
            FOR n FROM LWB even TO UPB even DO even[ n ] := FALSE OD;
            FOR n FROM LWB even TO UPB even DO
                IF INT n2 = n <* 2; n2 <= UPB even THEN even[ n <* 2 ] := TRUE FI
            OD;
            INT found := 0;
            FOR n FROM LWB even WHILE found < 20 DO
                IF even[ n ] THEN print( ( " ", whole( n, 0 ) ) ); found +:= 1 FI
            OD;
            print( ( newline ) )
        END;
        print( ( "The first 20 lunar squares:", newline, "      " ) );
        FOR n FROM 0 TO 19 DO print( ( " ", whole( n <* n, 0 ) ) ) OD;
        print( ( newline ) );
        BEGIN
            INT f max = IF max lunar digits >= 18 THEN 20 ELIF max lunar digits >= 9 THEN 18 ELSE 9 FI;
            print( ( "The first ", whole( f max, 0 ), " lunar factorials:", newline, "      " ) );
            INT lf := 1;
            FOR n TO f max DO print( ( " ", whole( lf <*:= n, 0 ) ) ) OD;
            print( ( newline ) )
        END;
        BEGIN
            print( ( "First lunar square smaller than the previous: " ) );
            INT prev square := 0;
            INT this square := 1;
            INT first n     := 0;
            FOR n FROM 2 WHILE first n = 0 DO
                prev square := this square;
                IF   this square := n <* n;
                     this square < prev square
                THEN first n := n
                FI
            OD;
            print( ( whole( first n, 0 ), " squared = ", whole( this square, 0 ) ) );
            print( ( ", previous = ", whole( prev square, 0 ), newline ) )
        END
    END
END
