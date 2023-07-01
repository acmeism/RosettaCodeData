BEGIN
    # returns a collapsed version of s                                    #
    #         i.e. s with adjacent duplicate characters removed           #
    PROC collapse = ( STRING s )STRING:
        IF s = ""
        THEN ""   # empty string                                          #
        ELSE      # non-empty string                                      #
            [ LWB s : UPB s ]CHAR result;
            INT     r pos   := LWB result;
            result[ r pos ] := s[ LWB s ];
            FOR s pos FROM LWB s + 1 TO UPB s DO
                IF result[ r pos ] /= s[ s pos ] THEN
                   r pos +:= 1;
                   result[ r pos ] := s[ s pos ]
                FI
            OD;
            result[ LWB result : r pos ]
        FI # callapse # ;
    # task test cases                                                     #
    []STRING tests = ( ""
                     , """If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln "
                     , "..1111111111111111111111111111111111111111111111111111111111111117777888"
                     , "I never give 'em hell, I just tell the truth, and they think it's hell. "
                     , "                                                    --- Harry S Truman  "
                     );
    FOR t pos FROM LWB tests TO UPB tests DO
        STRING s = tests[ t pos ];
        STRING c = collapse( s );
        print( ( "       <<<", s, ">>> (length ", whole( ( UPB s + 1 ) - LWB s, 0 ), ")", newline ) );
        print( ( "result <<<", c, ">>> (length ", whole( ( UPB c + 1 ) - LWB c, 0 ), ")", newline ) )
    OD
END
