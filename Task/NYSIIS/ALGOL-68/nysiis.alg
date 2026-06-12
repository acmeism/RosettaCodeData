BEGIN # NYSIIS algorithm                                                     #

    # returns str in upper-case with non-letters removed                     #
    OP   TOALPHAUPPER = ( STRING str )STRING:
         BEGIN
            STRING result := "";
            FOR i FROM LWB str TO UPB str DO
                CHAR c = str[ i ];
                IF   c >= "a" AND c <= "z"
                THEN result +:= REPR ( ABS c + ( ABS "A" - ABS "a" ) )
                ELIF c >= "A" AND c <= "Z"
                THEN result +:= c
                FI
            OD;
            result
         END # TOALPHAUPPER # ;
    # returns str with all characters in delete removed                      #
    PRIO REMOVE = 1;
    OP   REMOVE = ( STRING str, CHAR delete )STRING:
         BEGIN
            STRING result := "";
            FOR i FROM LWB str TO UPB str DO
                CHAR c = str[ i ];
                IF c /= delete THEN
                    result +:= c
                FI
            OD;
            result
         END # REMOVE # ;
    # returns str with with the character at pos removed                     #
    OP   REMOVE = ( STRING str, INT pos )STRING:
         IF pos < LWB str OR pos > UPB str
         THEN str
         ELIF pos = LWB str
         THEN str[ LWB str + 1 : ]
         ELIF pos = UPB str
         THEN str[ : LENGTH str - 1 ]
         ELSE str[ : pos - 1 ] + str[ pos + 1 : ]
         FI # REMOVE # ;
    # returns the length of str                                              #
    OP   LENGTH = ( STRING str )INT: ( UPB str - LWB str ) + 1;
    # returns TRUE is str starts with prefix, FALSE otherwise                #
    PRIO STARTSWITH = 9;
    OP   STARTSWITH = ( STRING str, prefix )BOOL:
         IF INT p len = LENGTH prefix;
            p len > LENGTH str
         THEN FALSE
         ELSE str[ LWB str : LWB str + p len - 1 ] = prefix
         FI # STARTSWITH # ;
    OP   STARTSWITH = ( STRING str, CHAR prefix )BOOL: str STARTSWITH STRING(prefix);
    # returns TRUE if c is a vowel (AEIOU), FALSE otherwise                  #
    OP   VOWEL = ( CHAR c )BOOL: c = "A" OR c = "E" OR c = "I" OR c = "O" OR c = "U";
    # returns the character from str following pos, if there is one,         #
    #         REPR 0 otherwise                                               #
    PRIO FOLLOWING = 9;
    OP   FOLLOWING = ( STRING str, INT pos )CHAR: IF pos < UPB str THEN str[ pos + 1 ] ELSE REPR 0 FI;
    # left pads str to at least w charaters                                  #
    PRIO PAD = 9;
    OP   PAD = ( INT w, STRING str )STRING:
         IF LENGTH str >= w THEN str ELSE ( ( w - LENGTH str ) * " " ) + str FI;

    # returns the NYSIIS code of name                                        #
    OP   NYSIIS = ( STRING name )STRING:
         BEGIN
            STRING cname := ( TOALPHAUPPER ( name REMOVE " " ) );
            IF   cname STARTSWITH "MAC" THEN cname[ 1 : 3 ] := "MCC"
            ELIF cname STARTSWITH "KN"  THEN cname[ 1 : 2 ] := "NN"
            ELIF cname STARTSWITH "K"   THEN cname[ 1     ] := "C"
            ELIF cname STARTSWITH "PH"  THEN cname[ 1 : 2 ] := "FF"
            ELIF cname STARTSWITH "PF"  THEN cname[ 1 : 2 ] := "FF"
            ELIF cname STARTSWITH "SCH" THEN cname[ 1 : 3 ] := "SSS"
            FI;
            INT    r len  := LENGTH cname;
            STRING suffix = cname[ r len - 1 : r len ];
            IF   suffix = "EE" OR suffix = "IE" THEN cname[ r len - 1 : ] := "Y "
            ELIF suffix = "DT" OR suffix = "RT" OR suffix = "RD"
              OR suffix = "NT" OR suffix = "ND" THEN cname[ r len - 1 : ] := "D "
            FI;
            INT r pos := 2;
            WHILE IF r pos > r len THEN FALSE ELSE cname[ r pos ] /= " " FI DO
                CHAR p = cname[ r pos - 1 ];
                CHAR c = cname[ r pos     ];
                CHAR n = cname FOLLOWING r pos;
                IF c = "E" THEN
                    IF n = "V" THEN cname[ r pos : r pos + 1 ] := "AF" ELSE cname[ r pos ] := "A" FI
                ELIF VOWEL c THEN cname[ r pos ] := "A"
                ELIF c = "Q" THEN cname[ r pos ] := "G"
                ELIF c = "Z" THEN cname[ r pos ] := "S"
                ELIF c = "M" THEN cname[ r pos ] := "N"
                ELIF IF r pos >= r len - 1 THEN FALSE ELSE cname[ r pos : r pos + 2 ] = "SCH" FI
                THEN cname[ r pos : r pos + 2 ] := "SSS"
                ELIF c = "P" AND n = "H" THEN cname[ r pos : r pos + 1 ] := "FF"
                ELIF c = "K" THEN cname[ r pos ] := IF n = "N" THEN "N" ELSE "C" FI
                ELIF c = "H"
                 AND ( NOT VOWEL p OR NOT VOWEL n ) THEN cname[ r pos ] := p
                ELIF c = "W" AND VOWEL p
                THEN cname[ r pos ] := p
                FI;
                IF cname[ r pos ] = p
                THEN cname := cname REMOVE r pos; r len -:= 1
                ELSE r pos +:= 1
                FI
            OD;
            IF cname[ r len ] = " " THEN cname := cname REMOVE r len; r len -:= 1 FI;
            IF IF r len < 1 THEN FALSE ELSE c name[ r len ] = "S" FI
            THEN cname := cname REMOVE r len;
                 r len -:= 1
            FI;
            IF IF r len < 2 THEN FALSE ELSE c name[ r len - 1 : ] = "AY" FI
            THEN cname := cname REMOVE r len;
                 cname[ r len -:= 1 ] := "Y"
            FI;
            IF IF r len < 1 THEN FALSE ELSE c name[ r len ] = "A" FI
            THEN cname := cname REMOVE r len;
                 r len -:= 1
            FI;
            cname
         END # NYSIIS # ;

    # test cases as used in other samples, e.g. 11l                          #
    [,]STRING tests = ( (      "Bishop", "BASAP"    )
                      , (     "Carlson", "CARLSAN"  )
                      , (        "Carr", "CAR"      )
                      , (     "Chapman", "CAPNAN"   )
                      , (    "Franklin", "FRANCLAN" )
                      , (      "Greene", "GRAN"     )
                      , (      "Harper", "HARPAR"   )
                      , (      "Jacobs", "JACAB"    )
                      , (      "Larson", "LARSAN"   )
                      , (    "Lawrence", "LARANC"   )
                      , (      "Lawson", "LASAN"    )
                      , (  "Louis, XVI", "LASXV"    )
                      , (       "Lynch", "LYNC"     )
                      , (   "Mackenzie", "MCANSY"   )
                      , (    "Matthews", "MAT"      )
                      , (   "McCormack", "MCARNAC"  )
                      , (    "McDaniel", "MCDANAL"  )
                      , (    "McDonald", "MCDANALD" )
                      , (  "Mclaughlin", "MCLAGLAN" )
                      , (    "Morrison", "MARASAN"  )
                      , (    "O'Banion", "OBANAN"   )
                      , (     "O'Brien", "OBRAN"    )
                      , (    "Richards", "RACARD"   )
                      , (       "Silva", "SALV"     )
                      , (     "Watkins", "WATCAN"   )
                      , (     "Wheeler", "WALAR"    )
                      , (      "Willis", "WAL"      )
                      , (   "brown, sr", "BRANSR"   )
                      , ( "browne, III", "BRAN"     )
                      , (  "browne, IV", "BRANAV"   )
                      , (       "hayes", "HAY"      )
                      , (      "knight", "NAGT"     )
                      , (    "mitchell", "MATCAL"   )
                      , (    "o'daniel", "ODANAL"   )
                      );
    FOR t FROM 1 LWB tests TO 1 UPB tests DO
        STRING name     = tests[ t, 1 ];
        STRING code     = NYSIIS name;
        STRING expected = tests[ t, 2 ];
        print( ( 12 PAD name, " -> ", code
               , IF code = expected
                 THEN ""
                 ELSE "    !! expected " + expected
                 FI
               , newline
               )
             )
    OD
END
