BEGIN # convert JSON-style escape sequences to characters                    #
      # the following escapes are recognised: \\, \", \/, \b, \f, \n, \r, \t #
      # and \uXXXX for characters in the Base Multilingual Plane and pairs   #
      # of u\XXXXu\XXXX of surrogates for characters outside that range      #

    # TRUE if CHAR contains Unicode codepoints, FALSE if bytes               #
    BOOL using unicode = max abs char > 511;

    # returns the length of s                                                #
    OP   LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;

    # mode to hold a codepoint                                               #
    MODE CODEPOINT = INT;
    # convert a CODEPOINT to an INT, adjust to suit the CODEPOINT mode       #
    OP   INTOF = ( CODEPOINT p )INT: p;

    # mode to hold the results of unescaping a string                        #
    MODE UNESCAPED = STRUCT( [ 1 : 0 ]CODEPOINT utf32, STRING error );

    # high-surrogate range                                                   #
    CODEPOINT high surrogate min = ABS 16rd800;
    CODEPOINT high surrogate max = ABS 16rdbff;
    # low-surrogate range                                                    #
    CODEPOINT low surrogate min  = ABS 16rdc00;
    CODEPOINT low surrogate max  = ABS 16rdfff;
    # modulus to extract the surrogate value                                 #
    CODEPOINT surrogate base     = ABS 16r03ff + 1;

    # returns the hex-digit corresponding to c, or -1 if it is invalid       #
    OP   HEXDIGIT = ( CHAR c )INT:
         IF   c >= "0" AND c <= "9" THEN        ABS c - ABS "0"
         ELIF c >= "a" AND c <= "f" THEN 10 + ( ABS c - ABS "a" )
         ELIF c >= "A" AND c <= "F" THEN 10 + ( ABS c - ABS "A" )
         ELSE                            -1
         FI # HEXDIGIT # ;
    # returns a string containing the codepoint t, a single UTF-32 character #
    # if that is what CHAR contains or encooded as UTF-8 bytes               #
    OP   CHAROF = ( CODEPOINT t )STRING:
         IF   using unicode THEN REPR t
         ELIF t <= ABS 16r00007f THEN REPR INTOF t
         ELIF t <= ABS 16r0007ff THEN REPR ( 192 + INTOF ( t OVER 64 ) )
                                    + REPR ( 128 + INTOF ( t MOD  64 ) )
         ELIF t <= ABS 16r007fff THEN
             CODEPOINT b1 := t;
             CODEPOINT b3 := b1 MOD 64; b1 OVERAB 64;
             CODEPOINT b2 := b1 MOD 64; b1 OVERAB 64;
             ( REPR INTOF ( 224 + b1 ) + REPR INTOF ( 128 + b2 ) + REPR INTOF ( 128 + b3 ) )
         ELIF t <= ABS 16r10ffff THEN
             CODEPOINT b1 := t;
             CODEPOINT b4 := b1 MOD 64; b1 OVERAB 64;
             CODEPOINT b3 := b1 MOD 64; b1 OVERAB 64;
             CODEPOINT b2 := b1 MOD 64; b1 OVERAB 64;
             ( REPR INTOF ( 240 + b1 ) + REPR INTOF ( 128 + b2 )
             + REPR INTOF ( 128 + b3 ) + REPR INTOF ( 128 + b4 )
             )
         ELSE
             print( ( "Invalid code point: ", whole( t, 0 ), newline ) );
             REPR INTOF ( t MOD max abs char )
         FI # CHAROF # ;

    # converts s to UTF-32, error messages are returned in error             #
    PROC to utf32 = ( STRING s )UNESCAPED:
         BEGIN
            [ 1 : LENGTH s ]CODEPOINT utf32;
            STRING error := "";
            INT s pos := LWB s;
            INT s max := UPB s;
            INT u pos := 0;
            WHILE s pos <= s max AND error = "" DO
                CHAR c := s[ s pos ];
                IF c /= "\" THEN                             # not an escape #
                    INT ich = ABS c;
                    INT additional bytes := 0;
                    IF using unicode THEN               # ich is a codepoint #
                        utf32[ u pos +:= 1 ] := ich
                    ELIF ich >= 240 THEN            # 4-byte UTF-8 character #
                        utf32[ u pos +:= 1 ] := ich MOD  8;
                        additional bytes := 3
                    ELIF ich >= 224 THEN            # 3-byte UTF-8 character #
                        utf32[ u pos +:= 1 ] := ich MOD 16;
                        additional bytes := 2
                    ELIF ich >= 192 THEN            # 2-byte UTF-8 character #
                        utf32[ u pos +:= 1 ] := ich MOD 32;
                        additional bytes := 1
                    ELSE                            # 1-byte character       #
                        utf32[ u pos +:= 1 ] := ABS c
                    FI;
                    IF s pos + additional bytes > s max THEN
                        error := "Truncated UTF-8 sequence"
                    ELSE
                        TO additional bytes DO utf32[ u pos ] *:= 64 +:= ABS s[ s pos +:= 1 ] MOD 64 OD
                    FI
                ELIF s pos >= UPB s THEN               # nothing after the \ #
                    error := "string ends with ""\"""
                ELIF c := s[ s pos +:= 1 ];        # have an escape sequence #
                     c = "\" OR c = """" OR c = "/"
                THEN utf32[ u pos +:= 1 ] := ABS c
                ELIF c = "b" THEN utf32[ u pos +:= 1 ] :=  8
                ELIF c = "f" THEN utf32[ u pos +:= 1 ] := 12
                ELIF c = "n" THEN utf32[ u pos +:= 1 ] := 10
                ELIF c = "r" THEN utf32[ u pos +:= 1 ] := 13
                ELIF c = "t" THEN utf32[ u pos +:= 1 ] :=  9
                ELIF c = "u" THEN                         # UTF-16 character #
                    CODEPOINT u := 0;
                    IF s pos + 4 > UPB s THEN
                        # insufficient characters left in the string         #
                        error := "Missing or truncated hex-digits after \u"
                    ELSE
                        # have four possible hex digits                      #
                        TO 4 WHILE error = "" DO
                            c := s[ s pos +:= 1 ];
                            IF INT digit = HEXDIGIT c;
                               digit < 0 OR digit > 15
                            THEN
                                error := "Invalid hex digit: """ + c + """"
                            ELSE
                                u *:= 16 +:= digit
                            FI
                        OD
                    FI;
                    IF   error /= "" THEN
                        SKIP                         # the string is invalid #
                    ELIF u >= high surrogate min
                     AND u <= high surrogate max
                    THEN
                        # have a UTF-32 character - must be followed by the  #
                        # low surrogate                                      #
                        IF s pos + 6 > UPB s THEN
                            error := "Missing or truncated low-surrogate"
                        ELIF s[ s pos +:= 1 ] /= "\"
                          OR s[ s pos +:= 1 ] /= "u"
                        THEN
                            error := "Expected ""\u"" after a high-surrogate"
                        ELSE
                            CODEPOINT ls := 0;
                            TO 4 WHILE error = "" DO
                                c := s[ s pos +:= 1 ];
                                IF INT digit = HEXDIGIT c;
                                   digit < 0 OR digit > 15
                                THEN
                                    error := "Invalid hex digit: """ + c + """"
                                ELSE
                                    ls *:= 16 +:= digit
                                FI
                            OD;
                            IF ls < low surrogate min
                            OR ls > low surrogate max
                            THEN
                                error := "High-surrogate not followed by a low-surrogate"
                            ELSE
                                ls MODAB surrogate base;
                                u  MODAB surrogate base *:= surrogate base +:= ls +:= ABS 16r10000
                            FI
                        FI;
                        utf32[ u pos +:= 1 ] := u
                    ELIF u >= low surrogate min
                     AND u <= low surrogate max
                    THEN
                        error := "Low surrogate not preceded by a high surrogate"
                    ELSE
                        utf32[ u pos +:= 1 ] := u
                    FI
                ELSE                                        # invalid escape #
                    error := "Invalid escape sequence: ""\" + c + """"
                FI;
                IF error /= "" THEN      # error detected - add the position #
                    error +:= ", at " + whole( s pos, 0 )
                FI;
                s pos +:= 1
            OD;
            ( utf32[ 1 : u pos ], error )
         END # to utf32 # ;

    # returns s left-padded with blanks to at least w characters             #
    PRIO PAD = 1;
    OP   PAD = ( INT w, STRING s )STRING:
         IF LENGTH s >= w THEN s ELSE ( ( w - LENGTH s ) * " " ) + s FI;

    # test cases                                                             #

    []STRING tests = ( "abc"          # abc   No escape sequences                     #
                     , "a☺c"         # a☺c  No escape sequences, extended unicode   #
                     , "a\""c"        # a"c  Two-character escape                     #
                     , "\u0061\u0062\u0063"    # abc       Just escape sequences      #
                     , "a\\c"         # a\c  Two-character escape for reverse solidus #
                     , "a\u263Ac"     # a☺c      \u escape, basic multilingual plane #
                     , "a\\u263Ac"             # a\u263Ac  Escaped \ before u         #
                     , "a𝄞c"          # a𝄞c   No escape sequences, non-BMP character  #
                     , "a\uD834\uDD1Ec"        # a𝄞c       \u escape, surrogate pair  #
                     , "a\ud834\udd1ec"        # a𝄞c       Lower case hex digits      #
                     , "a\u263"                # error     Incomplete escape sequence #
                     , "a\u263Xc"              # error     Invalid hexadecimal digit  #
                     , "a\uDD1Ec"              # error     Lone low surrogate         #
                     , "a\uD834c"              # error     Lone high surrogate        #
                     , "a\uD834\u263Ac"        # error     High surrogate followed by #
                                               #           non-surrogate              #
                     );

    FOR t pos FROM LWB tests TO UPB tests DO
        STRING    test   = tests[ t pos ];
        UNESCAPED result = to utf32( test );
        STRING    error  = error OF result;
        print( ( 20 PAD test, ": " ) );
        IF error /= "" THEN
            print( ( error, newline ) )
        ELSE
            []CODEPOINT utf32 = utf32 OF result;
            print( ( "(" ) );                      # show the codepoints as integers #
            FOR u pos FROM LWB utf32 TO UPB utf32 DO print( ( " ", whole( utf32[ u pos ], 0 ) ) ) OD;
            IF NOT using unicode THEN  # Unicode is not supported - show UTF-8 bytes #
                print( ( " |" ) );
                FOR u pos FROM LWB utf32 TO UPB utf32 DO
                    STRING chars = CHAROF utf32[ u pos ];
                    FOR c pos FROM LWB chars TO UPB chars DO
                        print( ( " ", whole( ABS chars[ c pos ], 0 ) ) )
                    OD
                OD
            FI;
            print( ( " ) """ ) );
            # show the result as a string                                            #
            FOR u pos FROM LWB utf32 TO UPB utf32 DO
                print( ( CHAROF utf32[ u pos ] ) )
            OD;
            print( ( """", newline ) )
        FI
    OD

END
