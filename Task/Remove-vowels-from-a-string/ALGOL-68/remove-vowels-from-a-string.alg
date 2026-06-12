BEGIN
    # returns s with the vowels removed #
    OP DEVOWEL = ( STRING s )STRING:
       BEGIN
            [ LWB s : UPB s ]CHAR result;
            INT r pos := LWB result - 1;
            FOR s pos FROM LWB s TO UPB s DO
                IF NOT char in string( s[ s pos ], NIL, "aeiouAEIOU" ) THEN
                    # have a non-vowel - add it to the output #
                    r pos +:= 1;
                    result[ r pos ] := s[ s pos ]
                FI
            OD;
            result[ LWB s : r pos ]
       END # DEVOWEL # ;
    # tests the DEVOWEL operator #
    PROC test devowel = ( STRING s )VOID:
         print( ( "<", s, "> -> <", DEVOWEL s, ">", newline ) );
    # some test cases #
    test devowel( ""                              );
    test devowel( "aAeEiIoOuU"                    );
    test devowel( "bcdfghjklmnprstvwxyz"          );
    test devowel( "abcdefghijklmnoprstuvwxyz"     );
    test devowel( "Algol 68 Programming Language" )
END
