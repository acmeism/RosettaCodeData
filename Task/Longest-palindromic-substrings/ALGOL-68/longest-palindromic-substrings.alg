BEGIN # find the longest palindromic substring of a string #
    # returns the length of s #
    OP   LENGTH = ( STRING s )INT: ( UPB s + 1 ) - LWB s;
    # returns s right-padded with blanks to at least w characters or s if it is already wide enough #
    PRIO PAD = 1;
    OP   PAD = ( STRING s, INT w )STRING:
         BEGIN
            STRING result := s;
            WHILE LENGTH result < w DO result +:= " " OD;
            result
         END # PAD # ;
    # returns the longest palindromic substring of s #
    #         if there are multiple substrings with the longest length, the leftmost is returned #
    PROC longest palindromic substring = ( STRING s )STRING:
         IF   LENGTH s < 2
         THEN s
         ELSE
            INT lwb s = LWB s;
            INT upb s = UPB s;
            STRING result := s[ lwb s ];
            IF s[ lwb s + 1 ] = s[ lwb s ] THEN
                # the first two characters are a palindrome #
                result +:= s[ lwb s + 1 ]
            FI;
            FOR i FROM lwb s + 1 TO upb s - 1 DO
                INT  p start := i;
                INT  p end   := i + 1;
                IF  IF   s[ i - 1 ] = s[ i + 1 ] THEN
                         # odd length palindrome at i - 1 #
                         p start -:= 1;
                         TRUE
                    ELIF s[ i ] = s[ i + 1 ] THEN
                         # even length palindrome at i #
                         TRUE
                    ELSE FALSE
                    FI
                THEN
                    # have a palindrome at p start : p end #
                    # attempt to enlarge the range #
                    WHILE IF   p start = lwb s OR p end = upb s
                          THEN FALSE
                          ELSE s[ p start - 1 ] = s[ p end + 1 ]
                          FI
                    DO    # can extend he palindrome #
                          p start -:= 1;
                          p end   +:= 1
                    OD;
                    IF ( p end + 1 ) - p start > LENGTH result
                    THEN
                        # have a longer palindrome #
                        result := s[ p start : p end ]
                    FI
                FI
            OD;
            result
         FI # longest palindromic substring # ;
    # finds the longest palindromic substring of s and checks it is the expacted value #
    PROC test = ( STRING s, expected value )VOID:
         BEGIN
            STRING palindrome = longest palindromic substring( s );
            print( ( ( """" + s + """" ) PAD 38, " -> ", ( """" + palindrome + """" ) PAD 36
                   , IF palindrome = expected value THEN "" ELSE " NOT " + expected value + " ???" FI
                   , newline
                   )
                 )
         END # test longest palindromic substring # ;
    test( "three old rotators",                 "rotator"                     );
    test( "never reverse",                      "ever reve"                   );
    test( "stable was I ere I saw elbatrosses", "table was I ere I saw elbat" );
    test( "abracadabra",                        "aca"                         );
    test( "drome",                              "d"                           );
    test( "x",                                  "x"                           );
    test( "the abbatial palace",                "abba"                        );
    test( "",                                   ""                            );
    test( "abcc",                               "cc"                          );
    test( "abbccc",                             "ccc"                         )
END
