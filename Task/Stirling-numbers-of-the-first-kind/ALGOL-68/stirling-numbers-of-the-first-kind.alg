BEGIN # show some (unsigned) Stirling numbers of the first kind          #

    # specify the precision of LONG LONG INT, we need about 160 digits   #
    # for Stirling numbers of the first kind with n, k = 100             #
    PR precision 160 PR
    MODE SINT = LONG LONG INT;

    # returns a triangular matrix of Stirling numbers up to max n, max n #
    # the numbers are signed if signed is TRUE, unsigned otherwise       #
    PROC make s1 = ( INT max n, BOOL signed )REF[,]SINT:
    BEGIN

        HEAP[ 0 : max n, 0 : max n ]SINT s1;
        FOR n FROM 0 TO max n DO FOR k FROM 0 TO max n DO s1[ n, k ] := 0 OD OD;
        s1[ 0, 0 ] := 1;
        FOR n FROM 1 TO max n DO s1[ n, 0 ] := 0 OD;
        FOR n FROM 1 TO max n DO
            FOR k FROM 1 TO n DO
                SINT s1 term = ( ( n - 1 ) * s1[ n - 1, k ] );
                s1[ n, k ] := s1[ n - 1, k - 1 ] + IF signed THEN - s1 term ELSE s1 term FI
            OD
        OD;
        s1
    END # make s1 # ;
    # task requirements:                                                #
    # print Stirling numbers up to n, k = 12                            #
    BEGIN
        INT max stirling = 12;
        REF[,]SINT s1 = make s1( max stirling, FALSE );
        print( ( "Unsigned Stirling numbers of the first kind:", newline ) );
        print( ( " k  0" ) );
        FOR k TO max stirling DO print( ( whole( k, IF k < 6 THEN -10 ELSE -9 FI ) ) ) OD;
        print( ( newline, " n", newline ) );
        FOR n FROM 0 TO max stirling DO
            print( ( whole( n, -2 ), whole( s1[ n, 0 ], -3 ) ) );
            FOR k TO n DO
                print( ( whole( s1[ n, k ], IF k < 6 THEN -10 ELSE -9 FI ) ) )
            OD;
            print( ( newline ) )
        OD
    END;
    # find the maximum Stirling number with n = 100                     #
    BEGIN
        INT max stirling = 100;
        REF[,]SINT s1 = make s1( max stirling, FALSE );
        SINT max 100 := 0;
        FOR k FROM 0 TO max stirling DO
            IF s1[ max stirling, k ] > max 100 THEN max 100 := s1[ max stirling, k ] FI
        OD;
        print( ( "Maximum Stirling number of the first kind with n = 100:", newline ) );
        print( ( whole( max 100, 0 ), newline ) )
    END
END
