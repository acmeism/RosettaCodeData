BEGIN # Convert words to Pig Latin #

    # returns TRUE if c is a lowercase letter, FALSE otherwise #
    OP   ISLOWER = ( CHAR c )BOOL: c >= "a" AND c <= "z";

    # returns TRUE if c is an uppercase letter, FALSE otherwise #
    OP   ISUPPER = ( CHAR c )BOOL: c >= "A" AND c <= "Z";

    # returns TRUE if c is a letter, FALSE otherwise #
    OP   ISLETTER = ( CHAR c )BOOL: ISUPPER c OR ISLOWER c;

    # returns TRUE s starts with a letter or ' followed by a letter #
    OP   ISLETTER = ( STRING s )BOOL:
         ISLETTER s[ LWB s ] OR ( s[ LWB s ] = "'" AND ISLETTER s[ LWB s + 1 ] );

    # returns c in lowercase if it is an uppercase letter, c otherwise #
    OP   TOLOWER = ( CHAR c )CHAR: IF ISUPPER c THEN REPR ( ( ABS c - ABS "A" ) + ABS "a" ) ELSE c FI;

    # returns c in uppercase if it is an lowercase letter, c otherwise #
    OP   TOUPPER = ( CHAR c )CHAR: IF ISLOWER c THEN REPR ( ( ABS c - ABS "a" ) + ABS "A" ) ELSE c FI;

    # returns TRUE if c is a vowel, FALSE otherwise #
    OP   ISVOWEL = ( CHAR c )BOOL: char in string( c, NIL, "aeiouAEIOU" );

    # returns TRUE if c is a vowel or y, FALSE otherwise #
    OP   ISVOWELY = ( CHAR c )BOOL: ISVOWEL c OR TOUPPER c = "Y";

    # returns s encoded in Pig Latin #
    OP   TOPIGLATIN = ( STRING sentence )STRING:
         BEGIN
            STRING result  := "";
            BOOL   in word := FALSE;
            INT    s max    = UPB sentence;
            STRING s        = sentence + REPR 0;
            INT    s pos   := LWB s;
            WHILE s pos <= s max AND s[ s pos ] /= REPR 0 DO
                # copy to a word #
                WHILE s pos <= s max AND NOT ISLETTER s[ s pos ] DO
                    result +:= s[ s pos ];
                    s pos  +:= 1
                OD;
                IF ISLETTER s[ s pos ] THEN
                    # have another word #
                    STRING front  := "", word :=  "";
                    # get the front - the text up to the first vowel #
                    BOOL uppercase  = ISUPPER s[ s pos ];
                    BOOL all upper := uppercase;
                    IF s pos <= s max AND TOUPPER s[ s pos ] = "Y" THEN
                        # word starts with a Y/y treat it as a consonant, all other Y/ys are "vowels" #
                        front +:= "y";
                        s pos +:= 1
                    FI;
                    WHILE s pos <= s max AND ISLETTER s[ s pos ] AND NOT ISVOWELY s[ s pos ] DO
                        all upper := all upper AND ISUPPER s[ s pos ];
                        front +:= s[ s pos ];
                        IF s pos < s max AND TOUPPER s[ s pos ] = "Q" AND TOUPPER s[ s pos + 1 ] = "U"
                        THEN
                            all upper := all upper AND ISUPPER s[ s pos + 1 ];
                            front +:= s[ s pos + 1 ];
                            s pos +:= 1
                        FI;
                        s pos     +:= 1
                    OD;
                    WHILE IF s pos <= s max THEN ISLETTER s[ s pos : s pos + 1 ] ELSE FALSE FI DO
                        IF ISLETTER s[ s pos ] THEN all upper := all upper AND ISUPPER s[ s pos ] FI;
                        word  +:= s[ s pos ];
                        s pos +:= 1
                    OD;
                    IF all upper THEN
                        # the whole word was in uppercase, ensure the result is #
                        IF front /= "" THEN front[ LWB front ] := TOUPPER front[ LWB front ] FI;
                        word +:= IF front = "" THEN "WAY" ELSE front + "AY" FI
                    ELSE
                        IF front /= "" THEN front[ LWB front ] := TOLOWER front[ LWB front ] FI;
                        word +:= IF front = "" THEN "way" ELSE front + "ay" FI;
                        IF uppercase THEN
                            # should upcase the first letter of the new word #
                            word[ LWB word ] := TOUPPER word[ LWB word ]
                        FI
                    FI;
                    result +:= word
                FI
            OD;
            result
         END # TOPIGLATIN # ;

    []STRING tests =
             ( ""
             , " "
             , "123456!"
             , "Stop! In the name of Wuv!"
             , "My word!"
             , "ESA JAXA NASA"
             , "this is 'quoted'"
             , "MgClBr (Na,K)AlSiO4"

             , "pig  latin"
             , "rosetta  code"
             , "the quick brown fox jumps over the lazy dog"
             , "by the way"
             , "ytterbium"
             , "banana"
             , "BaNaNa"
             , "bAnAnA"
             , "BANANA"
             , "pig"
             , "black"
             , "a"
             , "open"
             , "hello world"
             , "Hello, World!"
             , "o'hare O'HARE o'hare don't"
             );
    FOR t pos FROM LWB tests TO UPB tests DO
        STRING test = tests[ t pos ];
        INT    pad  = 25 - ( UPB test - LWB test );
        IF pad > 0 THEN print( ( " " * pad ) ) FI;
        print( ( "[", tests[ t pos ], "]" ) );
        IF pad < 0 THEN print( ( newline, 28 * " " ) ) FI;
        print( ( " -> [", TOPIGLATIN test, "]", newline ) )
    OD
END
