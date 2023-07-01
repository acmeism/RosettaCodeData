BEGIN
    # return the position of the first different character in s           #
    #     or UPB s + 1 if all the characters are the same                 #
    OP  FIRSTDIFF = ( STRING s )INT:
        IF UPB s <= LWB s
        THEN
            # 0 or 1 character                                            #
            UPB s + 1
        ELSE
            # two or more characters                                      #
            INT  result := LWB s + 1;
            CHAR c1      = s[ LWB s ];
            FOR s pos FROM LWB s + 1 TO UPB s WHILE s[ s pos ] = c1 DO result +:= 1 OD;
            result
        FI # FIRSTDIFF # ;
    # convert a character to a hex string                                 #
    PROC hex = ( CHAR c )STRING:
        BEGIN
            STRING result := "";
            INT    n      := ABS c;
            IF n = 0
            THEN
                result := "0"
            ELSE
                WHILE n > 0 DO
                    INT d = n MOD 16;
                    n OVERAB 16;
                    IF d < 10
                    THEN REPR ( d + ABS "0" )
                    ELSE REPR ( ( d - 10 ) + ABS "a" )
                    FI +=: result
                OD
            FI;
            result
        END # hex # ;
    # show whether s contains all the same character of the first diff    #
    PROC show first diff = ( STRING s )VOID:
        IF  print( ( """", s, """ (length ", whole( ( UPB s + 1 ) - LWB s, 0 ), "): " ) );
            INT diff pos = FIRSTDIFF s;
            diff pos > UPB s
        THEN
            # all characters the same                                     #
            print( ( "all characters are the same", newline ) )
        ELSE
            # not all characters are the same                             #
            print( ( "first different character """
                   , s[ diff pos ]
                   , """(0x", hex( s[ diff pos ] )
                   , ") at position: "
                   , whole( diff pos, 0 )
                   , newline
                   )
                 )
        FI # show first diff # ;
    # task test cases                                                     #
    show first diff( ""          );
    show first diff( "   "       );
    show first diff( "2"         );
    show first diff( "333"       );
    show first diff( ".55"       );
    show first diff( "tttTTT"    );
    show first diff( "4444 444k" );
    show first diff( "4444|444k" )
END
