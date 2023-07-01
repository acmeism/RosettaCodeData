BEGIN
    # returns s with ", " added between each change of character #
    PROC split on characters = ( STRING s )STRING:
         IF s = "" THEN
            # empty string #
            ""
         ELSE
            # allow for 3 times as many characters as in the string #
            # this would handle a string of unique characters       #
            [ 3 * ( ( UPB s - LWB s ) + 1 ) ]CHAR result;
            INT  r pos  := LWB result;
            INT  s pos  := LWB s;
            CHAR s char := s[ LWB s ];
            FOR s pos FROM LWB s TO UPB s DO
                IF s char /= s[ s pos ] THEN
                    # change of character - insert ", " #
                    result[ r pos     ] := ",";
                    result[ r pos + 1 ] := " ";
                    r pos +:= 2;
                    s char := s[ s pos ]
                FI;
                result[ r pos ] := s[ s pos ];
                r pos +:= 1
            OD;
            # return the used portion of the result #
            result[ 1 : r pos - 1 ]
         FI ; # split on characters #

    print( ( split on characters( "gHHH5YY++///\" ), newline ) )
END
