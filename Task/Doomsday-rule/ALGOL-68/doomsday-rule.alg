BEGIN # find the day of the week of dates using John Conway's Doomsday rule #
    # returns the day of the week (Sunday = 0, Monday = 1,...) for the date #
    #         specified by ccyy, mm and dd                                  #
    PROC dow = ( INT ccyy, mm, dd )INT:
        BEGIN
            INT  doomsday     = ( # Tuesday # 2
                              + ( 5 * ( ccyy MOD   4 ) )
                              + ( 4 * ( ccyy MOD 100 ) )
                              + ( 6 * ( ccyy MOD 400 ) )
                              )
                            MOD 7;
            BOOL is leap year = ccyy MOD 4 = 0
                            AND ( ccyy MOD 100 /= 0 OR ccyy MOD 400 = 0 );
            INT  anchor day   = CASE mm
                                  IN IF is leap year THEN 4 ELSE 3 FI
                                   , IF is leap year THEN 1 ELSE 7 FI
                                   , 7, 4, 2, 6, 4, 1, 5, 3, 7, 5
                                ESAC;
        ( doomsday + ( dd - anchor day ) ) MOD 7
    END # dow # ;
    BEGIN # task test cases #
        # prints a test date and its day of the week #
        PROC test dow = ( INT ccyy, mm, dd )VOID:
             BEGIN
                 []CHAR   digit    = "0123456789"[ AT 0 ];
                 []STRING day name =
                          []STRING( "Sunday",   "Monday", "Tuesday", "Wednesday"
                                  , "Thursday", "Friday", "Saturday"
                                  )[ AT 0 ];
                 print( ( whole( ccyy, 0 )
                        , "-",  digit[ mm OVER 10 ], digit[ mm MOD 10 ]
                        , "-",  digit[ dd OVER 10 ], digit[ dd MOD 10 ]
                        , ": ", day name[ dow( ccyy, mm, dd ) ]
                        , newline
                        )
                      )
            END # test dow # ;
        test dow( 1800,  1,  6 );
        test dow( 1875,  3, 29 );
        test dow( 1915, 12,  7 );
        test dow( 1970, 12, 23 );
        test dow( 2043,  5, 14 );
        test dow( 2077,  2, 12 );
        test dow( 2101,  4,  2 );
        test dow( 2022,  6, 19 )
    END
END
