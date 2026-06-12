BEGIN # separate house numbers from street names in German/Netherlands       #
      #                                                            addresses #

    # returns the position of the start of the house number in a             #
    PROC house position = ( STRING a )INT:
         BEGIN
            CHAR eol ch = REPR 0;
            INT  a pos := UPB a;
            PROC eol    = BOOL: a pos < LWB a OR a pos > UPB a;
            PROC ch     = ( INT pos )CHAR:
                 IF pos < LWB a OR pos > UPB a THEN eol ch ELSE a[ pos ] FI;
            PROC curr   = CHAR: ch( a pos );
            PROC prev   = CHAR: IF a pos >= LWB a THEN a pos -:= 1; curr ELSE eol ch FI;
            PROC next   = CHAR: IF a pos <= UPB a THEN a pos +:= 1; curr ELSE eol ch FI;
            PROC have   = ( CHAR c )BOOL: curr = c;
            PROC range  = ( CHAR ra, rz, INT pos )BOOL: ch( pos ) >= ra AND ch( pos ) <= rz;
            PROC digit  = ( INT pos )BOOL: range( "0", "9", pos );

            WHILE have( " " ) DO prev OD;
            IF    have( "." ) THEN prev; WHILE have( " " ) DO prev OD FI;
            WHILE have( "I" ) DO prev OD;
            WHILE have( " " ) DO prev OD;
            WHILE range( "a", "z", a pos ) OR digit( a pos )
               OR have( " " ) OR have( "." ) OR have( "/" ) OR have( "-" )
            DO
               prev
            OD;
            IF have( "'" ) THEN                           # abbreviated year #
                WHILE next;
                      digit( a pos )
                DO SKIP OD
            FI;
            IF eol THEN                         # must not be the whole line #
                WHILE next;
                  NOT have( " " ) AND NOT eol
                DO SKIP OD
            FI;
            # must start with a number that doesn't look like a 1940s year   #
            WHILE WHILE have( " " ) DO next OD;
                  IF NOT digit( a pos ) THEN
                      WHILE NOT have( " " ) AND NOT eol DO next OD
                  FI;
                  WHILE NOT digit( a pos ) AND NOT eol DO next OD;
                  ch( a pos     ) = "1" AND ch(    a pos + 1 ) = "9"
              AND ch( a pos + 2 ) = "4" AND digit( a pos + 3 )
            DO
                WHILE digit( a pos ) DO next OD
            OD;
            a pos
         END # house position # ;

    []STRING test cases
        = ( "Plataanstraat 5"      , "Straat 12"            , "Straat 12 II"
          , "Dr. J. Straat   12"   , "Dr. J. Straat 12 a"   , "Dr. J. Straat 12-14"
          , "Laan 1940 - 1945 37"  , "Plein 1940 2"         , "1213-laan 11"
          , "16 april 1944 Pad 1"  , "1e Kruisweg 36"       , "Laan 1940-'45 66"
          , "Laan '40-'45"         , "Langeloërduinen 3 46" , "Marienwaerdt 2e Dreef 2"
          , "Provincialeweg N205 1", "Rivium 2e Straat 59." , "Nieuwe gracht 20rd"
          , "Nieuwe gracht 20rd 2" , "Nieuwe gracht 20zw /2", "Nieuwe gracht 20zw/3"
          , "Nieuwe gracht 20 zw/4", "Bahnhofstr. 4"        , "Wertstr. 10"
          , "Lindenhof 1"          , "Nordesch 20"          , "Weilstr. 6"
          , "Harthauer Weg 2"      , "Mainaustr. 49"        , "August-Horch-Str. 3"
          , "Marktplatz 31"        , "Schmidener Weg 3"     , "Karl-Weysser-Str. 6"
          );
    FOR i FROM LWB test cases TO UPB test cases DO
        PROC rtrim = ( STRING s )STRING:
             BEGIN
                INT s end := UPB s;
                WHILE IF s end < LWB s THEN FALSE ELSE s[ s end ] = " " FI DO
                    s end -:= 1
                OD;
                s[ LWB s : s end ]
             END # rtrim # ;
        PROC lpad = ( STRING s, INT len )STRING:
             IF INT s len = ( UPB s + 1 ) - LWB s;
                s len >= len
             THEN s
             ELSE " " * ( len - s len ) + s
             FI # lpad # ;
        STRING test   = rtrim( test cases[ i ] );
        INT    h pos  = house position( test );
        STRING street = IF h pos > UPB test THEN test     ELSE test[ LWB test : h pos - 1 ] FI;
        STRING house  = IF h pos > UPB test THEN "(none)" ELSE test[ h pos    :           ] FI;
        print( ( lpad( rtrim( street ), 40 ), "   ", rtrim( house ), newline ) )
    OD

END
