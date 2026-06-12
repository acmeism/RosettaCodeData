BEGIN # xkcd 1205, translated from the Wren sample #
    []INT    shaved  = ( 1, 5, 30, 60, 300, 1800, 3600, 21600, 86400 );
                                                            # time shaved off in seconds #
    []STRING titles  = ( "1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE", "5 MINUTES"
                       , "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY"
                       );
    REAL diy    = 365.25;
    INT  minute = 60;
    INT  hour   = minute * 60;
    INT  day    = hour * 24;
    INT  week   = day * 7;
    REAL month  = day * diy / 12;
    REAL year   = day * diy;

    []REAL freq = ( 50 * diy, 5 * diy, diy, diy/7, 12, 1 ); # frequency per year #
    INT    mult = 5;                                        # multiplier for table #

    PROC pad right = ( STRING s, INT w )STRING:
         IF INT len = ( UPB s - LWB s ) + 1; len >= w THEN s ELSE s + ( ( w - len ) * " " ) FI;
    PROC center = ( STRING s, INT w )STRING:
         IF INT len = ( UPB s - LWB s ) + 1; len >= w THEN s ELSE ( ( ( w - len ) OVER 2 ) * " " ) + s FI;

    PROC fmt time = ( REAL tf, STRING interval )VOID:
         BEGIN
            INT t  = ENTIER tf;
            print( ( pad right( whole( t, 0 ) + " " + interval + IF t = 1 THEN "" ELSE "S" FI, 13 ) ) )
         END # fmt time # ;

    print( ( center( "HOW OFTEN YOU DO THE TASK", 93 ), newline ) );
    print( ( pad right( "SHAVED OFF", 12 ), " | "
           , pad right( "50/DAY",     13 ), pad right( "5/DAY",   13 ), pad right( "DAILY",  13 )
           , pad right( "WEEKLY",     13 ), pad right( "MONTHLY", 13 ), pad right( "YEARLY", 13 )
           , newline
           )
         );
    print( ( "-" * 93, newline ) );
    FOR y FROM LWB titles TO UPB titles DO
        print( ( pad right( titles[ y ], 12 ), " | " ) );
        FOR x FROM LWB freq TO UPB freq DO
            REAL t = freq[ x ] * shaved[ y ] * mult;
            IF   t < minute THEN
                 fmt time( t,          "SECOND" )
            ELIF t < hour THEN
                 fmt time( t / minute, "MINUTE" )
            ELIF t < day THEN
                 fmt time( t / hour,   "HOUR"   )
            ELIF t < 14 * day THEN
                 fmt time( t / day,    "DAY"    )
            ELIF t < 9 * week THEN
                 fmt time( t / week,   "WEEK"   )
            ELIF t < year THEN
                 fmt time( t / month,  "MONTH"  )
            ELSE
                 print( ( " " * 13 ) )
            FI
        OD;
        print( ( newline ) )
    OD
END
