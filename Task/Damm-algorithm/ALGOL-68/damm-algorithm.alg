BEGIN
    # returns TRUE if the check digit of s is correct according to the Damm algorithm, #
    # FALSE otherwise #
    PROC has valid damm check digit = ( STRING s )BOOL:
         BEGIN
            # operation table - as per wikipedia example #
            [,]INT operation table =
                ( [,]INT( ( 0, 3, 1, 7, 5, 9, 8, 6, 4, 2 )
                        , ( 7, 0, 9, 2, 1, 5, 4, 8, 6, 3 )
                        , ( 4, 2, 0, 6, 8, 7, 1, 3, 5, 9 )
                        , ( 1, 7, 5, 0, 9, 8, 3, 4, 2, 6 )
                        , ( 6, 1, 2, 3, 0, 4, 5, 9, 7, 8 )
                        , ( 3, 6, 7, 4, 2, 0, 9, 5, 8, 1 )
                        , ( 5, 8, 6, 9, 7, 2, 0, 1, 3, 4 )
                        , ( 8, 9, 4, 5, 3, 6, 2, 0, 1, 7 )
                        , ( 9, 4, 3, 8, 6, 1, 7, 2, 0, 5 )
                        , ( 2, 5, 8, 1, 4, 3, 6, 7, 9, 0 )
                        )
                ) [ AT 0, AT 0 ]
                ;
            INT interim digit := 0;
            FOR s pos FROM LWB s TO UPB s DO
                INT next digit = ABS s[ s pos ] - ABS "0";
                IF next digit < 0 OR next digit > 9 THEN
                    # invalid digit #
                    print( ( "Invalid damm digit: ", s[ s pos ], newline ) );
                    stop
                ELSE
                    # have a valid digit #
                    interim digit := operation table[ interim digit, next digit ]
                FI
            OD;
            interim digit = 0
         END # has valid damm check digit # ;

    # test the damm algorithm #
    PROC test damm algorithm = ( STRING s, BOOL expected )VOID:
         BEGIN
            BOOL valid = has valid damm check digit( s );
            print( ( "check digit of ", s, " is "
                   , IF valid THEN "valid" ELSE "invalid" FI
                   , IF valid = expected THEN "" ELSE " *** NOT AS EXPECTED" FI
                   , newline
                   )
                 )
         END # test damm algorithm # ;
    # test cases - as per other language samples #
    test damm algorithm( "5724",   TRUE  );
    test damm algorithm( "5727",   FALSE );
    test damm algorithm( "112946", TRUE  )
END
