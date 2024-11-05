BEGIN # compare string lengths #
    # returns the length of s using the builtin UPB and LWB operators #
    OP LENGTH = ( STRING s )INT: ( UPB s + 1 ) - LWB s;
    # prints s and its length #
    PROC show string = ( STRING s )VOID:
         print( ( """", s, """ has length: ", whole( LENGTH s, 0 ), " bytes.", newline ) );
    STRING shorter     = "short";
    STRING not shorter = "longer";
    IF LENGTH shorter >  LENGTH not shorter THEN show string( shorter ) FI;
    show string( not shorter );
    IF LENGTH shorter <= LENGTH not shorter THEN show string( shorter ) FI
END
