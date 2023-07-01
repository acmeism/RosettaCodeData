CO in the string "abracadabra", replace the first  'a' with 'A', the second 'a' with 'B'
                                      , the fourth 'a' with 'C', the fifth  'a' with 'D'
                                        the first  'b' with 'E', the second 'r' with 'F'
CO
BEGIN
    [,]STRING replacements = ( ( "a", "ABaCD" ), ( "b", "E" ), ( "r", "rF" ) );
    [ 1 LWB replacements : 1 UPB replacements ]INT position;
    STRING input = "abracadabra";
    [ LWB input : UPB input ]CHAR output;
    FOR i FROM LWB position TO UPB position DO position[ i ] := LWB replacements[ i, 2 ] OD;
    FOR c pos FROM LWB input TO UPB input DO
        CHAR c           = input[ c pos ];
        output[ c pos ] := c;
        BOOL found      := FALSE;
        FOR r pos FROM 1 LWB replacements TO 1 UPB replacements WHILE NOT found DO
            STRING r = replacements[ r pos, 1 ];
            IF c = r[ LWB r ] THEN
                found := TRUE;
                IF position[ r pos ] <= UPB replacements[ r pos, 2 ] THEN
                    output[   c pos ]  := replacements[ r pos, 2 ][ position[ r pos ] ];
                    position[ r pos ] +:= 1;
                    found              := TRUE
                FI
            FI
        OD
    OD;
    print( ( """", input, """ -> """, output, """" ) );
    IF output /= "AErBcadCbFD" THEN print( ( " ** UNEXPECTED RESULT" ) ) FI;
    print( ( newline ) )
END
