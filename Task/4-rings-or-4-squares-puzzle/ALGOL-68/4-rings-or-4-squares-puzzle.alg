BEGIN
    # solve the 4 rings or 4 squares puzzle                                             #
    # we need to find solutions to the equations: a + b = b + c + d = d + e + f = f + g #
    # where a, b, c, d, e, f, g in lo : hi ( not necessarily unique )                   #
    # depending on show, the solutions will be printed or not                           #
    PROC four rings = ( INT lo, hi, BOOL allow duplicates, show )VOID:
    BEGIN
        INT  solutions := 0;
        # calculate field width for printinhg solutions #
        INT  width := -1;
        INT  max := ABS IF ABS lo > ABS hi THEN lo ELSE hi FI;
        WHILE max > 0 DO
            width -:= 1;
            max OVERAB 10
        OD;
        # find solutions #
        FOR a FROM lo TO hi DO
            FOR b FROM lo TO hi DO
                IF allow duplicates OR a /= b THEN
                    INT t = a + b;
                    FOR c FROM lo TO hi DO
                        IF allow duplicates OR ( a /= c AND b /= c ) THEN
                            INT d = t - ( b + c );
                            IF  d >= lo AND d <= hi
                            AND (  allow duplicates
                                OR ( a /= d AND b /= d AND c /= d )
                                )
                            THEN
                                FOR e FROM lo TO hi DO
                                    IF allow duplicates
                                    OR ( a /= e AND b /= e AND c /= e AND d /= e )
                                    THEN
                                        INT g = d + e;
                                        INT f = t - g;
                                        IF  f >= lo AND f <= hi
                                        AND g >= lo AND g <= hi
                                        AND (  allow duplicates
                                            OR (   a /= f AND b /= f AND c /= f
                                               AND d /= f AND e /= f
                                               AND a /= g AND b /= g AND c /= g
                                               AND d /= g AND e /= g AND f /= g
                                               )
                                            )
                                        THEN
                                            solutions +:= 1;
                                            IF show THEN
                                                print( ( whole( a, width ), whole( b, width )
                                                       , whole( c, width ), whole( d, width )
                                                       , whole( e, width ), whole( f, width )
                                                       , whole( g, width ), newline
                                                       )
                                                     )
                                            FI
                                        FI
                                    FI
                                OD # e #
                            FI
                        FI
                    OD # c #
                FI
            OD # b #
        OD # a # ;
        print( ( whole( solutions, 0 )
               , IF allow duplicates THEN " non-unique" ELSE " unique" FI
               , " solutions in "
               , whole( lo, 0 )
               , " to "
               , whole( hi, 0 )
               , newline
               , newline
               )
             )
    END # four rings # ;

    # find the solutions as required for the task #
    four rings( 1, 7, FALSE, TRUE  );
    four rings( 3, 9, FALSE, TRUE  );
    four rings( 0, 9, TRUE,  FALSE )
END
