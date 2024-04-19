BEGIN # show some Stirling numbers of the second kind                        #

    # specify the precision of LONG LONG INT, somewhat under 160 digits are  #
    # needed for Stirling numbers of the second kind with n, k = 100         #
    PR precision 160 PR
    MODE SINT = LONG LONG INT;

    # returns a triangular matrix of Stirling numbers up to max n, max n #
    PROC make s2 = ( INT max n )REF[,]SINT:
    BEGIN
        REF[,]SINT s2 := HEAP[ 0 : max n, 0 : max n ]SINT;
        FOR n FROM 0 TO max n DO FOR k FROM 0 TO max n DO s2[ n, k ] := 0 OD OD;
        FOR n FROM 0 TO max n DO s2[ n, n ] := 1 OD;
        FOR n FROM 0 TO max n - 1 DO
            FOR k FROM 1 TO n DO
                s2[ n + 1, k ] := k * s2[ n, k ] + s2[ n, k - 1 ]
            OD
        OD;
        s2
    END # make s2 # ;
    # task requirements:                                                     #
    # print Stirling numbers up to n, k = 12                                 #
    BEGIN
        INT max stirling = 12;
        REF[,]SINT s2 = make s2( max stirling );
        print( ( "Stirling numbers of the second kind:", newline ) );
        print( ( " k" ) );
        FOR k FROM 0 TO max stirling DO print( ( whole( k, -8 ) ) ) OD;
        print( ( newline, " n", newline ) );
        FOR n FROM 0 TO max stirling DO
            print( ( whole( n, -2 ) ) );
            FOR k FROM 0 TO n DO
                print( ( whole( s2[ n, k ], -8 ) ) )
            OD;
            print( ( newline ) )
        OD
    END;
    # find the maximum Stirling number with n = 100                          #
    BEGIN
        INT max stirling = 100;
        REF[,]SINT s2 = make s2( max stirling );
        SINT max 100 := 0;
        FOR k FROM 0 TO max stirling DO
            IF s2[ max stirling, k ] > max 100 THEN max 100 := s2[ max stirling, k ] FI
        OD;
        print( ( "Maximum Stirling number of the second kind with n = 100:", newline ) );
        print( ( whole( max 100, 0 ), newline ) )
    END
END
