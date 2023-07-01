BEGIN
    # returns s parsed according to delimiter and escape                      #
    PROC parse with escapes = ( STRING s, CHAR delimiter, escape )[]STRING:
         IF ( UPB s - LWB s ) + 1 < 1 THEN
            # empty string                                                    #
            [ 1 : 0 ]STRING empty array;
            empty array
         ELSE
            # at least one character                                          #
            # allow for a string composed entirely of delimiter characters    #
            [ 1 : ( UPB s - LWB s ) + 3 ]STRING result;
            INT r pos := 1;
            INT s pos := LWB s;
            result[ r pos ] := "";
            WHILE s pos <= UPB s DO
                CHAR c = s[ s pos ];
                IF  c = delimiter THEN
                    # start a new element                                     #
                    result[ r pos +:= 1 ] := ""
                ELIF c = escape THEN
                    # use the next character even if it is an escape          #
                    s pos +:= 1;
                    IF s pos < UPB s THEN
                        # the escape is not the last character                #
                        result[ r pos ] +:= s[ s pos ]
                    FI
                ELSE
                    # normal character                                        #
                    result[ r pos ] +:= c
                FI;
                s pos +:= 1
            OD;
            result[ 1 : r pos ]
         FI; # parse with escapes #
    # task test case                                                          #
    []STRING tokens = parse with escapes( "one^|uno||three^^^^|four^^^|^cuatro|", "|", "^" );
    FOR t pos FROM LWB tokens TO UPB tokens DO print( ( "[", tokens[ t pos ], "]", newline ) ) OD
END
