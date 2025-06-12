BEGIN # Test processing/2 - using thee file from Text processing/1,          #
      #                     verify the format, detect duplicate dates and    #
      #                     count the number of records with all instruments #
      #                     functioning                                      #

    PR read "files.incl.a68" PR     # include file utilities: EACHLINE, etc. #

    CHAR tab = REPR 9;

    INT instruments = 24;           # expected number of instrument readings #
    MODE READING    = STRUCT( STRING date
                            , [ 1 : instruments ]REAL data
                            , [ 1 : instruments ]INT status
                            , BOOL   format ok
                            , STRING message
                            );
    OP   INIT = ( REF READING r )VOID:
         BEGIN
            FOR n TO instruments DO ( data OF r )[ n ] := ( status OF r )[ n ] := 0 OD;
            format ok OF r := TRUE;
            date OF r      := "";
            message OF r   := ""
         END # INIT # ;

    INT all good count := 0; # number of lines which have all instruments ok #
    STRING last date   := "";                    # date of the previous line #

    # return the date and instrument readings and status values on the line  #
    PROC parse readings = ( STRING line )READING:
         BEGIN
            BOOL data error := FALSE;
            # returns v converted to a REAL, returns 0 and sets data error   #
            #         to TRUE if v is invalid                                #
            OP   TOREAL = ( STRING v )REAL:
                 BEGIN
                    REAL value := 0;
                    FILE real value;
                    associate( real value, LOC STRING := v );
                    on value error
                        ( real value
                        , ( REF FILE ef )BOOL:  # "handles" invalid data and #
                                         BEGIN  # returns TRUE so processing #
                                             value      := 0; # can continue #
                                             data error := TRUE
                                         END
                        );
                     get( real value, value );
                     close( real value );
                     value
                 END # TOREAL # ;
            # returns v converted to an INT, returns 0 and sets data error   #
            #         to TRUE if v is invalid                                #
            OP   TOINT    = ( STRING text )INT:
                 BEGIN
                    INT  value      := 0;
                    BOOL is numeric := TRUE;
                    FOR ch pos FROM UPB text BY -1 TO LWB text WHILE is numeric DO
                        CHAR c = text[ ch pos ];
                        IF   c = "-"
                        THEN value := - value;
                             is numeric := ch pos = LWB text AND ch pos /= UPB text
                        ELSE is numeric := is numeric AND c >= "0" AND c <= "9";
                             IF is numeric THEN ( value *:= 10 ) +:= ABS c - ABS "0" FI
                        FI
                    OD;
                    IF NOT is numeric THEN data error := TRUE FI;
                    value
                 END # TOINT # ;
            # superficially checks v is in the format yyyy-mm-dd             #
            PROC check date format = ( STRING v )BOOL:
                 BEGIN
                    STRING ymd := v[ AT 1 ];
                    IF NOT ( data error := UPB ymd /= 10 ) THEN
                        # length is correct for yyyy-mm-dd                   #
                        IF NOT ( data error := ymd[ 5 ] /= "-" OR ymd[ 8 ] /= "-" ) THEN
                            INT d;
                            d := ( TOINT ymd[ 1 :  4 ] * 10000 )
                               + ( TOINT ymd[ 6 :  7 ] *   100 )
                               +   TOINT ymd[ 9 : 10 ]
                        FI
                    FI;
                    NOT data error
                 END # check date format # ;

            READING result; INIT result;
            INT     c pos        := LWB line;
            INT     max pos       = UPB line;
            INT     field number := 0;
            WHILE c pos <= max pos DO
                # skip leading spaces and tabs                               #
                WHILE IF   c pos > max pos
                      THEN FALSE
                      ELSE CHAR ch = line[ c pos ]; ch = " " OR ch = tab
                      FI
                DO    c pos +:= 1 OD;
                IF c pos <= max pos THEN                      # have a field #
                    INT start pos = c pos;
                    WHILE IF   c pos > max pos
                          THEN FALSE
                          ELSE CHAR ch := line[ c pos ]; ch /= " " AND ch /= tab
                          FI
                    DO    c pos +:= 1 OD;
                    STRING f := line[ start pos : c pos - 1 ];
                    IF ( field number +:= 1 ) = 1 THEN            # the date #
                        IF NOT check date format( f ) THEN
                            format ok OF result := FALSE;
                            message OF result   := "Invalid date: " + f
                        FI;
                        date OF result := f
                    ELIF INT instrument = field number OVER 2;
                         instrument > instruments THEN
                        format ok OF result := FALSE;    # too many readings #
                        message OF result   := "Too many instruments"
                    ELIF ODD field number THEN
                        # field 3, 5, 7... the instrument state of reading   #
                        ( status OF result )[ field number OVER 2 ] := TOINT f;
                        IF data error THEN
                            format ok OF result := FALSE;
                            message OF result   := "Invalid status for instrument " + whole( instrument, 0 )
                        FI
                    ELSE                  # must be the instrument reading   #
                        ( data OF result )[   field number OVER 2 ] := TOREAL f;
                        IF data error THEN
                            format ok OF result := FALSE;
                            message OF result   := "Invalid reading for instrument " + whole( instrument, 0 )
                        FI
                    FI
                FI
            OD;
            IF format ok OF result AND field number /= 2 * instruments + 1 THEN
                format ok OF result := FALSE;
                message OF result   := "Incorrect number of readings/status values"
            FI;
            result
         END # parse readings # ;

    # checks the readings and date on line                                   #
    PROC check readings = ( STRING line, INT line count )BOOL:
         BEGIN
            READING data := parse readings( line );
            IF format ok OF data AND line count > 1 AND date OF data = last date THEN
                format ok OF data := FALSE;
                message OF data   := "Duplicate date: " + date OF data
            FI;
            IF NOT format ok OF data THEN            # line has invalid data #
                print( ( "Line: ", whole( line count, 0 ), ": ", message OF data, newline ) )
            ELSE                                       # the line appears ok #
                BOOL all good := TRUE;
                FOR i TO instruments WHILE all good := ( status OF data )[ i ] > 0 DO SKIP OD;
                IF all good THEN all good count +:= 1 FI;
                last date := date OF data
            FI;
            TRUE
         END # check readings # ;

    IF   STRING file name   = "readings.txt";
         INT    total lines = file name EACHLINE check readings;
         total lines < 0
    THEN print( ( "Unable to open ", file name, newline ) )
    ELSE print( ( whole( total lines, 0 ), " lines in ", file name, ", " ) );
         print( ( whole( all good count, 0 ), " have all instruments in a good state.", newline ) )
    FI

END
