BEGIN # convert Old Russian units to/from metric                             #
    # mode to hold details of the units - value is in meters                 #
    MODE UNIT = STRUCT( STRING name, REAL value );
    # gets a UNIT from the standard input                                    #
    PROC read unit = UNIT:
         BEGIN
            UNIT r;
            read( ( value OF r, name OF r, newline ) );
            # trim leading and trailing spaces from the name                 #
            INT f pos := LWB name OF r;
            WHILE IF f pos <= UPB name OF r THEN ( name OF r )[ f pos ] = " " ELSE FALSE FI
            DO
                f pos +:= 1
            OD;
            INT b pos := UPB name OF r;
            WHILE IF b pos >= LWB name OF r THEN ( name OF r )[ b pos ] = " " ELSE FALSE FI
            DO
                b pos -:= 1
            OD;
            IF f pos > b pos THEN
                # no name                                                    #
                name OF r := ""
            ELIF ( name OF r )[ b pos ] = "s" THEN
                # the user entered a plural - remove the "S"                 #
                name OF r := ( name OF r )[ f pos : b pos - 1 ]
            ELSE
                # non-blank, non-plural name                                 #
                name OF r := ( name OF r )[ f pos : b pos     ]
            FI;
            r
         END # read unit # ;
    # units and their value in meters                                        #
    []UNIT units = ( ( "arshin",  0.7112 ), ( "centimeter", 0.01     ), ( "diuym",   0.0254  )
                   , ( "fut",     0.3048 ), ( "kilometer",  1000.0   ), ( "liniya",  0.00254 )
                   , ( "meter",   1.0    ), ( "milia",      7467.6   ), ( "piad",    0.1778  )
                   , ( "sazhen",  2.1336 ), ( "tochka",     0.000254 ), ( "vershok", 0.04445 )
                   , ( "versta",  1066.8 )
                   );
    WHILE # prompt for units and show their conversions                      #
        print( ( "Enter the unit to convert - value followed by unit name (or 0 to quit): " ) );
        UNIT r := read unit;
        value OF r /= 0
    DO
        # find the unit name in the table of valid units                     #
        INT u pos := LWB units - 1;
        FOR i FROM LWB units TO UPB units WHILE u pos < LWB units DO
            IF name OF r = name OF units[ i ] THEN
                u pos := i
            FI
        OD;
        IF u pos < LWB units THEN
            # didn't find the units                                          #
            print( ( "Unknown units - please enter one of:", newline, "    " ) );
            FOR i FROM LWB units TO UPB units DO
                print( ( name OF units[ i ], IF i = UPB units THEN newline ELSE ", " FI ) )
            OD
        ELSE
            # found the units - show the values in the other units           #
            UNIT u = units[ u pos ];
            print( ( fixed( value OF r, -12, 6 ), " ", name OF u, " is:", newline ) );
            FOR i FROM LWB units TO UPB units DO
                IF i /= u pos THEN
                    print( ( fixed( ( value OF r * value OF u )/ value OF units[ i ], -16, 6 )
                           , " ", name OF units[ i ], newline
                           )
                         )
                FI
            OD
        FI
    OD
END
