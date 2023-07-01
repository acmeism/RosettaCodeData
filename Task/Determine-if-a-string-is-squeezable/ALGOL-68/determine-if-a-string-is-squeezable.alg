BEGIN
    # returns a squeezed version of s                                     #
    #         i.e. s with adjacent duplicate c characters removed         #
    PRIO SQUEEZE = 9;
    OP   SQUEEZE = ( STRING s, CHAR c )STRING:
         IF s = ""
         THEN ""   # empty string                                         #
         ELSE      # non-empty string                                     #
            [ LWB s : UPB s ]CHAR result;
            INT     r pos   := LWB result;
            result[ r pos ] := s[ LWB s ];
            FOR s pos FROM LWB s + 1 TO UPB s DO
                IF  result[ r pos ] /= s[ s pos ]
                OR  result[ r pos ] /= c
                THEN
                    r pos +:= 1;
                    result[ r pos ] := s[ s pos ]
                FI
            OD;
            result[ LWB result : r pos ]
         FI # SQUEEZE # ;
    # test the SQUEEZE operator                                           #
    PROC test squeeze = ( STRING s, CHAR c )VOID:
        BEGIN
            STRING z = s SQUEEZE c;
            print( ( "Squeezing """, c, """ in ", "<<<", s, ">>> (length ", whole( ( UPB s + 1 ) - LWB s, 0 ), ")", newline ) );
            print( ( "       ->        ",         "<<<", z, ">>> (length ", whole( ( UPB z + 1 ) - LWB z, 0 ), ")", newline ) )
        END # test squeeze # ;
    # task test cases                                                     #
    test squeeze( "",                                                                           " " );
    test squeeze( """If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln ", "-" );
    test squeeze( "..1111111111111111111111111111111111111111111111111111111111111117777888",   "7" );
    test squeeze( "I never give 'em hell, I just tell the truth, and they think it's hell. ",   "." );
    STRING hst =  "                                                    --- Harry S Truman  ";
    test squeeze( hst, " " );
    test squeeze( hst, "-" );
    test squeeze( hst, "r" )
END
