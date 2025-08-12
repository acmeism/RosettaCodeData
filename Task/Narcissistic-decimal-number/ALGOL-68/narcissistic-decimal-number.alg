# print the first 25 narcissistic numbers                                 #
BEGIN

    [ 0 : 9 ]INT power := ( []INT( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ) )[ AT 0 ];
    INT count       := 0;
    INT candidate   := 0;
    INT prev digits := 0;
    INT digits      := 0;

    FOR d9 FROM 0 TO 2 DO
        IF d9 > 0 AND digits < 9 THEN digits := 9 FI;
        FOR d8 FROM 0 TO 9 DO
            IF d8 > 0 AND digits < 8 THEN digits := 8 FI;
            FOR d7 FROM 0 TO 9 DO
                IF d7 > 0 AND digits < 7 THEN digits := 7 FI;
                FOR d6 FROM 0 TO 9 DO
                    IF d6 > 0 AND digits < 6 THEN digits := 6 FI;
                    FOR d5 FROM 0 TO 9 DO
                        IF d5 > 0 AND digits < 5 THEN digits := 5 FI;
                        FOR d4 FROM 0 TO 9 DO
                            IF d4 > 0 AND digits < 4 THEN digits := 4 FI;
                            FOR d3 FROM 0 TO 9 DO
                                IF d3 > 0 AND digits < 3 THEN digits := 3 FI;
                                FOR d2 FROM 0 TO 9 DO
                                    IF d2 > 0 AND digits < 2 THEN digits := 2 FI;
                                    FOR d1 FROM 0 TO 9 DO

                                        IF prev digits /= digits THEN
                                            # number of digits has increased - increase the powers #
                                            prev digits := digits;
                                            FOR i FROM 2 TO 9 DO power[ i ] *:= i OD
                                        FI;

                                        # sum the digits'th powers of the    #
                                        # digits of candidate                #
                                        INT sum = power[ d1 ] + power[ d2 ] + power[ d3 ]
                                                + power[ d4 ] + power[ d5 ] + power[ d6 ]
                                                + power[ d7 ] + power[ d8 ] + power[ d9 ]
                                                ;
                                        IF candidate = sum THEN
                                            # found another narcissistic decimal number            #
                                            print( ( " ", whole( candidate, 0 ) ) );
                                            count +:= + 1;
                                            IF count >= 25 THEN GOTO done FI
                                        FI;
                                        candidate +:= 1
                                    OD
                                OD
                            OD
                        OD
                    OD
                OD
            OD
        OD
    OD;
done:
    print( ( newline ) )

END
