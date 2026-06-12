BEGIN
    []INT fifth = []INT( 0, 1, 2^5, 3^5, 4^5, 5^5, 6^5, 7^5, 8^5, 9^5 )[ AT 0 ];
    # as observed by the Julia sample, 9^5 * 7 has only 6 digits whereas 9^5 * 6 has 6 digits #
    # so only up to 6 digit numbers need be considered #
    # also, the digit fifth power sum is independent ofg the order of the digits #
    [ 1 : 100 ]INT sums; FOR i TO UPB sums DO sums[ i ] := 0 OD;
    [ 0 :   9 ]INT used; FOR i FROM 0 TO 9 DO used[ i ] := 0 OD;
    INT s count := 0;
    FOR d1 FROM 0 TO 9 DO
        INT s1 = fifth[ d1 ];
        used[ d1 ] +:= 1;
        FOR d2 FROM d1 TO 9 DO
            INT s2 = fifth[ d2 ] + s1;
            used[ d2 ] +:= 1;
            FOR d3 FROM d2 TO 9 DO
                INT s3 = fifth[ d3 ] + s2;
                used[ d3 ] +:= 1;
                FOR d4 FROM d3 TO 9 DO
                    INT s4 = fifth[ d4 ] + s3;
                    used[ d4 ] +:= 1;
                    FOR d5 FROM d4 TO 9 DO
                        INT s5 = fifth[ d5 ] + s4;
                        used[ d5 ] +:= 1;
                        FOR d6 FROM d5 TO 9 DO
                            INT s6 = fifth[ d6 ] + s5;
                            used[ d6 ] +:= 1;
                            # s6 is the sum of the fifth powers of the digits #
                            # check it it is composed of the digits d1 - d6   #
                            [ 0 : 9 ]INT check; FOR i FROM 0 TO 9 DO check[ i ] := 0 OD;
                            INT v := s6;
                            TO 6 DO
                                check[ v MOD 10 ] +:= 1;
                                v OVERAB 10
                            OD;
                            BOOL same := TRUE;
                            FOR i FROM 0 TO 9 WHILE ( same := used[ i ] = check[ i ] ) DO SKIP OD;
                            IF same THEN
                                # found a number that is the sum of the fifth powers of its digits #
                                sums[ s count +:= 1 ] := s6
                            FI;
                            used[ d6 ] -:= 1
                        OD # d6 # ;
                        used[ d5 ] -:= 1
                    OD # d5 # ;
                    used[ d4 ] -:= 1
                OD # d4 # ;
                used[ d3 ] -:= 1
            OD # d3 # ;
            used[ d2 ] -:= 1
        OD # d2 # ;
        used[ d1 ] -:= 1
    OD # d1 # ;
    # sum and print the sums - ignore 0 and 1 #
    INT total := 0;
    print( ( "Numbers that are the sums of the fifth powers of their digits: " ) );
    FOR i TO s count DO
        IF sums[ i ] > 1 THEN
            print( ( " ", whole( sums[ i ], 0 ) ) );
            total +:= sums[ i ]
        FI
    OD;
    print( ( newline ) );
    print( ( "Total: ", whole( total, 0 ), newline ) )
END
