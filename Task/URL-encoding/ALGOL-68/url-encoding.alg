BEGIN
    # encodes the specified url - 0-9, A-Z and a-z are unchanged,            #
    # everything else is converted to %xx where xx are hex-digits            #
    PROC encode url = ( STRING url )STRING:
         IF url = "" THEN "" # empty string                                  #
         ELSE
            # non-empty string                                               #
            # ensure result will be big enough for a string of all encodable #
            # characters                                                     #
            STRING hex digits = "0123456789ABCDEF";
            [ 1 : ( ( UPB url - LWB url ) + 1 ) * 3 ]CHAR result;
            INT r pos := 0;
            FOR u pos FROM LWB url TO UPB url DO
                CHAR c = url[ u pos ];
                IF ( c >= "0" AND c <= "9" )
                OR ( c >= "A" AND c <= "Z" )
                OR ( c >= "a" AND c <= "z" )
                THEN
                    # no need to encode this character                       #
                    result[ r pos +:= 1 ] := c
                ELSE
                    # must encode                                            #
                    INT c code = ABS c;
                    result[ r pos +:= 1 ] := "%";
                    result[ r pos +:= 1 ] := hex digits[ ( c code OVER 16 ) + 1 ];
                    result[ r pos +:= 1 ] := hex digits[ ( c code  MOD 16 ) + 1 ]
                FI
            OD;
            result[ 1 : r pos ]
         FI; # encode url #
    # task test case                                                         #
    print( ( encode url( "http://foo bar/" ), newline ) )
END
