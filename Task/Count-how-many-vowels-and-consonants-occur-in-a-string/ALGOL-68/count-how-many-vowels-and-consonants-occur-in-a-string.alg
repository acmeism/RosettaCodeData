BEGIN # count the vowels and consonants in a string                         #
    # returns the 0-based index of the upper case letter c in the alphabet  #
    # or -1 if c is not a letter                                            #
    OP   L = ( CHAR c )INT:
         IF c >= "A" AND c <= "Z" THEN ABS c - ABS "A" ELIF c >= "a" AND c <= "z" THEN ABS c - ABS "a" ELSE -1 FI;
    # prints the counts of vowels and consonants in s                       #
    PROC print vc counts = ( STRING s )VOID:
         BEGIN
            [ 0 : 26 ]BOOL used;  FOR i FROM LWB used  TO UPB used  DO used[  i ] := FALSE OD;
            [ 0 : 26 ]BOOL vowel; FOR i FROM LWB vowel TO UPB vowel DO vowel[ i ] := FALSE OD;
            vowel[ L "A" ] := vowel[ L "E" ] := vowel[ L "I" ] := vowel[ L "O" ] := vowel[ L "U" ] := TRUE;
            INT v total := 0, c total := 0, v count := 0, c count := 0;
            FOR i FROM LWB s TO UPB s DO
                IF   INT c index = L s[ i ];
                     c index >= LWB used
                THEN
                    IF vowel[ c index ] THEN v total ELSE c total FI +:= 1;
                    IF NOT used[ c index ] THEN
                        IF vowel[ c index ] THEN v count ELSE c count FI +:= 1;
                        used[ c index ] := TRUE
                    FI
                FI
            OD;
            print( ( """", s, """ contains", newline ) );
            print( ( "    ", whole( v count, 0 ), " vowels and ", whole( c count, 0 ), " consonants (distinct)", newline ) );
            print( ( "    ", whole( v total, 0 ), " vowels and ", whole( c total, 0 ), " consonants (total)",    newline ) )
         END; # print vc counts #
    # test cases                                                            #
    print vc counts( "Now is the time for all good men to come to the aid of their country" );
    print vc counts( "Help avoid turns" )
END
