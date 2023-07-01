BEGIN #   DISCORDIAN DATE CALCULATION - TRANSLATION OF MAD VIA ALGOL W    #
    INT      greg, gmonth, gday, gyear;
    []STRING holys  = []STRING( "MUNG", "MOJO",  "SYA",   "ZARA", "MALA" )[ AT 0 ];
    []STRING holys0 = []STRING( "CHAO", "DISCO", "CONFU", "BURE", "AF"   )[ AT 0 ];
    []STRING disday = []STRING( "SWEETMORN", "BOOMTIME", "PUNGENday", "PRICKLE-PRICKLE", "SETTING ORANGE" )[ AT 0 ];
    []STRING disssn = []STRING( "CHAOS",     "DISCORD",  "CONFUSION", "BUREAUCRACY",     "THE AFTERMATH"  )[ AT 0 ];
    []INT    mlengt = []INT( 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 )[ AT 0 ];
    CHAR     slash1, slash2;

    # input date should contain MM/DD/YYYY in the gregorian calendar      #
    read( ( gmonth, slash1, gday, slash2, gyear ) );
    IF slash1 /= "/" OR slash2 /= "/" THEN print( ( "Invalid date format", newline ) ); stop FI;

    IF gmonth = 2 AND gday = 29
    THEN print( ( "SAINT TIB'S DAY IN THE Y.O.L.D. ", whole( gyear + 1166, -4 ), newline ) )
    ELSE
        INT yrday  := mlengt[ gmonth ] + gday;
        INT season := yrday OVER 73;
        INT day    := yrday - ( season * 73 );
        INT wkday  := ( yrday - 1 ) MOD 5;
        print( ( disday[ wkday ], ", DAY ", whole( day, -2 ), " OF ", disssn[ season ]
               , " IN THE Y.O.L.D ", whole( gyear + 1166, 0 ), newline
               )
             );
        IF   day = 5  THEN print( ( "CELEBRATE ", holys[  season ], "DAY"  ) )
        ELIF day = 50 THEN print( ( "CELEBRATE ", holys0[ season ], "FLUX" ) )
        FI
    FI
END
