BEGIN # find words with alternating vowels and consonants in unixdict.txt    #

    PR read "files.incl.a68" PR                     # include file utilities #

    # returns TRUE if c is a vowel, FALSE otherwise                          #
    OP   ISVOWEL = ( CHAR c )BOOL:
         ( c = "a" OR c = "e" OR c = "i" OR c = "o" OR c = "u" );

    # prints word if it consists of alternating vowels and consonants        #
    # returns TRUE if it does, FALSE otherwise                               #
    # count so far will contain the number of preceding such words           #
    PROC show vc word = ( STRING word, INT count so far )BOOL:
         IF INT w len = ( UPB word + 1 ) - LWB word;
            w len < 10
         THEN FALSE                                             # short word #
         ELSE                           # the word is at least 10 characters #
            BOOL is alternating  := TRUE;
            BOOL have vowel      := ISVOWEL word[ LWB word ];
            FOR w pos FROM LWB word + 1 TO UPB word
            WHILE BOOL had vowel  = have vowel;
                  have vowel     := ISVOWEL word[ w pos ];
                  is alternating := have vowel = NOT had vowel
            DO SKIP OD;
            IF is alternating THEN
                # have a word alternate between vowels and consonants        #
                INT alternating count = count so far + 1;
                TO 15 - w len DO print( ( " " ) ) OD;
                print( ( word ) );
                IF w len > 15 OR alternating count MOD 6 = 0 THEN print( ( newline ) ) FI
            FI;
            is alternating
         FI # show vc word # ;

    IF   INT alternating count = "unixdict.txt" EACHLINE show vc word;
         alternating count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE print( ( newline, whole( alternating count, 0 ) ) );
         print( ( " words of alternating vowels and consonants found", newline ) )
    FI

END
