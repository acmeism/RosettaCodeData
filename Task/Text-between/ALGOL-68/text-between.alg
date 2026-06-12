BEGIN
    # some utility operators                                                 #
    # returns the length of a string                                         #
    OP   LENGTH = ( STRING a )INT: ( UPB a - LWB a ) + 1;
    # returns the position of s in t or UPB t + 1 if s is not present        #
    PRIO INDEXOF = 1;
    OP   INDEXOF = ( STRING t, STRING s )INT:
         IF INT pos; string in string( s, pos, t ) THEN pos ELSE UPB t + 1 FI;
    # returns the text after s in t or "" if s is not present                #
    PRIO AFTER   = 1;
    OP   AFTER   = ( STRING t, STRING s )STRING:
         IF INT pos = t INDEXOF s; pos > UPB t THEN "" ELSE t[ pos + LENGTH s : ] FI;
    # returns the text before s in t or t if s is not present                #
    PRIO BEFORE  = 1;
    OP   BEFORE  = ( STRING t, STRING s )STRING:
         IF INT pos = t INDEXOF s; pos > UPB t THEN t ELSE t[ : pos - 1 ] FI;

    # mode to hold a pair of STRINGs for the BETWEEN operator                #
    MODE STRINGPAIR = STRUCT( STRING left, right );
    # returns a STRINGPAIR composed of a and b (standard priority for AND)   #
    OP   AND     = ( STRING a, STRING b )STRINGPAIR: (        a,         b  );
    # although not used in this task, in general, we would need these        #
    # additional operators for CHARs as "a" is a CHAR denotation,            #
    # not a STRING of length 1 - un-comment as necessary                     #
CO  OP   AND     = ( STRING a, CHAR   b )STRINGPAIR: ( STRING(a),        b  );
    OP   AND     = ( CHAR   a, CHAR   b )STRINGPAIR: ( STRING(a), STRING(b) );
    OP   AND     = ( CHAR   a, STRING b )STRINGPAIR: (        a , STRING(b) );
CO
    # traceing flag for BETWEEN - if TRUE, debug output is shown             #
    BOOL trace between := FALSE;
    # returns the text of s between the delimitors specified in d            #
    PRIO BETWEEN = 1;
    OP   BETWEEN = ( STRING s, STRINGPAIR d )STRING:
         BEGIN
            STRING result := s;
            IF  left OF d /= "start" THEN result := result AFTER   left OF d FI;
            IF right OF d /= "end"   THEN result := result BEFORE right OF d FI;
            IF trace between THEN
                # show debug output                                          #
                print( ( "Text: """,                     s, """", newline
                       , "Start delimiter: """,  left OF d, """", newline
                       , "End delimiter: """,   right OF d, """", newline
                       , "Output: """,              result, """", newline
                       ,                                          newline
                       )
                     )
            FI;
            result
         END # BETWEEN # ;

    # test cases                                                             #
    BEGIN
        STRING s;
        trace between := TRUE;
        s := "Hello Rosetta Code world" BETWEEN "Hello "  AND " world";
        s := "Hello Rosetta Code world" BETWEEN "start"   AND " world";
        s := "Hello Rosetta Code world" BETWEEN "Hello "  AND "end";
        s := "</div><div style=""french"">bonjour</div>"
                                        BETWEEN "<div style=""french"">"
                                                          AND "</div>";
        s := "<text>Hello <span>Rosetta Code</span> world</text><table style=""myTable"">"
                                        BETWEEN "<text>"  AND "<table>";
        s := "<table style=""myTable""><tr><td>hello world</td></tr></table>"
                                        BETWEEN "<table>" AND "</table>";
        s := "The quick brown fox jumps over the lazy other fox"
                                        BETWEEN "quick "  AND " fox";
        s := "One fish two fish red fish blue fish"
                                        BETWEEN "fish "   AND " red";
        s := "FooBarBazFooBuxQuux"      BETWEEN "Foo"     AND "Foo";
        trace between := FALSE
    END
END
