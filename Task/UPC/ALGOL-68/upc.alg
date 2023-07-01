BEGIN
    # number of digits encoded by UPC                                         #
    INT upc digits = 12;
    # MODE to hold UPC bar code parse results                                 #
    MODE UPC = STRUCT( BOOL      valid         # TRUE if the UPC was valid,   #
                                               # FASLE otherwise              #
                     , [ 1 : upc digits ]INT digits
                                               # the digits encoded by the    #
                                               # UPC if it was valid          #
                     , BOOL      inverted      # TRUE if the code was scanned #
                                               # upside down, FALSE if it was #
                                               # right-side up                #
                     , STRING    error message # erro rmessage if the string  #
                                               # was invalid                  #
                     );
    # parses the UPC string s and returns a UPC containing the results        #
    PROC parse upc = ( STRING s )UPC:
         BEGIN
             # returns TRUE if we are at the end of s, FALSE otherwise        #
             PROC at end = BOOL: s pos > UPB s;
             # counts and skips spaces in s                                   #
             PROC skip spaces = INT:
                  BEGIN
                     INT spaces := 0;
                     WHILE IF at end THEN FALSE ELSE s[ s pos ] = " " FI DO
                         spaces +:= 1;
                         s pos  +:= 1
                     OD;
                     spaces
                  END; # skip spaces #
             # skips over the next number of bits characters of s and returns #
             # a bit representation ( space = 0, anything else = 1 )          #
             PROC get value = ( INT number of bits )BITS:
                  BEGIN
                     BITS value := 2r0;
                     FOR b TO number of bits WHILE NOT at end DO
                         value := ( value SHL 1 ) OR IF s[ s pos ] = " " THEN 2r0 ELSE 2r1 FI;
                         s pos +:= 1
                     OD;
                     value
                  END; # get value #
             # the representations of the digits                              #
             []BITS representations = ( 2r 0 0 0 1 1 0 1    # 0 #
                                      , 2r 0 0 1 1 0 0 1    # 1 #
                                      , 2r 0 0 1 0 0 1 1    # 2 #
                                      , 2r 0 1 1 1 1 0 1    # 3 #
                                      , 2r 0 1 0 0 0 1 1    # 4 #
                                      , 2r 0 1 1 0 0 0 1    # 5 #
                                      , 2r 0 1 0 1 1 1 1    # 6 #
                                      , 2r 0 1 1 1 0 1 1    # 7 #
                                      , 2r 0 1 1 0 1 1 1    # 8 #
                                      , 2r 0 0 0 1 0 1 1    # 9 #
                                      );
             []BITS reversed digits = ( 2r 0 1 0 0 1 1 1    # 0 #
                                      , 2r 0 1 1 0 0 1 1    # 1 #
                                      , 2r 0 0 1 1 0 1 1    # 2 #
                                      , 2r 0 1 0 0 0 0 1    # 3 #
                                      , 2r 0 0 1 1 1 0 1    # 4 #
                                      , 2r 0 1 1 1 0 0 1    # 5 #
                                      , 2r 0 0 0 0 1 0 1    # 6 #
                                      , 2r 0 0 1 0 0 0 1    # 7 #
                                      , 2r 0 0 0 1 0 0 1    # 8 #
                                      , 2r 0 0 1 0 1 1 1    # 9 #
                                      );
             # number of digits in the left and right sides of the UPC        #
             INT digits per side = upc digits OVER 2;
             UPC result;
             FOR d TO upc digits DO ( digits OF result )[ d ] := 0 OD;
             inverted OF result      := FALSE;
             error message OF result := "unknown error";
             valid OF result         := FALSE;
             INT s pos               := LWB s;
             IF skip spaces < 6 # should be 9 but we are being tolerant       #
             THEN
                 # insufficient leading spaces                                #
                 error message OF result := "missing leading spaces"
             ELIF get value( 3 ) /= 2r101 THEN
                 # no start                                                   #
                 error message OF result := "missing start sequence"
             ELSE
                 # ok so far - should now have six digits, each encoded in    #
                 # seven bits                                                 #
                 # note we store the digits as 1..10 if the are right-sid up  #
                 # and -1..-10 if they are inverted, so we can distinguish    #
                 # right-side up 0 and inverted 0                             #
                 # the digits are corrected to be 0..9 later                  #
                 BOOL valid digits := TRUE;
                 FOR d TO digits per side WHILE valid digits DO
                     BITS code = get value( 7 );
                     BOOL found digit := FALSE;
                     FOR d pos TO UPB representations WHILE NOT found digit DO
                         IF   code = representations[ d pos ] THEN
                             # found a "normal" digit                         #
                             found digit               := TRUE;
                             ( digits OF result )[ d ] := d pos
                         ELIF code = reversed digits[ d pos ] THEN
                             # found a reversed digit                         #
                             found digit               := TRUE;
                             inverted OF result        := TRUE;
                             ( digits OF result )[ d ] := - d pos
                         FI
                     OD;
                     IF NOT found digit THEN
                         # have an invalid digit                              #
                         error message OF result := "invalid digit " + whole( d, 0 );
                         valid digits := FALSE
                     FI
                 OD;
                 IF NOT valid digits THEN
                     # had an error                                           #
                     SKIP
                 ELIF get value( 5 ) /= 2r01010 THEN
                     # no middle separator                                    #
                     error message OF result := "missing middle sequence"
                 ELSE
                     # should now have 6 negated digits                      #
                     FOR d FROM digits per side + 1 TO upc digits WHILE valid digits DO
                         BITS code = NOT get value( 7 ) AND 16r7f;
                         BOOL found digit := FALSE;
                         FOR d pos TO UPB representations WHILE NOT found digit DO
                             IF  code = representations[ d pos ] THEN
                                 # found a normal negated digit               #
                                 found digit               := TRUE;
                                 ( digits OF result )[ d ] := d pos
                             ELIF code = reversed digits[ d pos ] THEN
                                 # found reversed negated digit               #
                                 found digit               := TRUE;
                                 inverted OF result        := TRUE;
                                 ( digits OF result )[ d ] := - d pos
                             FI
                         OD;
                         IF NOT found digit THEN
                             # have an invalid digit                          #
                             error message OF result := "invalid digit " + whole( d, 0 );
                             valid digits            := FALSE
                         FI
                     OD;
                     IF NOT valid digits THEN
                         # had an error                                       #
                         SKIP
                     ELIF get value( 3 ) /= 2r101 THEN
                         # no end sequence                                    #
                         error message OF result := "missing end sequence"
                     ELIF skip spaces < 6 # should be 9 but we are being      #
                                          # tolerant                          #
                     THEN
                         # insufficient trailing spaces                       #
                         error message OF result := "insufficient trailing spaces"
                     ELIF NOT at end THEN
                         # extraneous stuff after the trailing spaces         #
                         error message OF result := "unexpected trailing bits"
                     ELSE
                         # valid so far - if there were reversed digits,      #
                         # check they were all reversed                       #
                         # and correct the digits to be in 0..9               #
                         BOOL all reversed  := TRUE;
                         FOR d TO upc digits DO
                             IF ( digits OF result )[ d ] < 0 THEN
                                 # reversd digit                             #
                                 ( digits OF result )[ d ]  := ABS ( digits OF result )[ d ] - 1
                             ELSE
                                 # normal digit                               #
                                 ( digits OF result )[ d ] -:= 1;
                                 all reversed               := FALSE
                             FI
                         OD;
                         IF inverted OF result AND NOT all reversed
                         THEN
                             # had a mixture of inverted and non-inverted     #
                             # digits                                         #
                             error message OF result := "some reversed digits found"
                         ELSE
                             # the code appears valid - check the check sum   #
                             IF inverted OF result THEN
                                 # the code was reversed - reverse the digits #
                                 FOR d TO digits per side DO
                                     INT right digit
                                          = ( digits OF result )[ ( upc digits + 1 ) - d ];
                                     ( digits OF result )[ ( upc digits + 1 ) - d ]
                                         := ( digits OF result )[ d ];
                                     ( digits OF result )[ d ] := right digit
                                 OD
                             FI;
                             INT check sum := 0;
                             FOR d FROM 1 BY 2 TO upc digits DO check sum +:= 3 * ( digits OF result )[ d ] OD;
                             FOR d FROM 2 BY 2 TO upc digits DO check sum +:=     ( digits OF result )[ d ] OD;
                             IF check sum MOD 10 /= 0 THEN
                                 # invalid check digit                        #
                                 error message OF result := "incorrect check digit"
                             ELSE
                                 # the UPC code appears valid                 #
                                 valid OF result         := TRUE
                             FI
                         FI
                     FI
                 FI
             FI;
             result
         END; # parse upc #
    # task test cases                                                         #
    []STRING tests =
( "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       "
, "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         "
, "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         "
, "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        "
, "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          "
, "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         "
, "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        "
, "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         "
, "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       "
, "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
);
    FOR t pos FROM LWB tests TO UPB tests DO
        UPC code = parse upc( tests[ t pos ] );
        print( ( whole( t pos, -2 ), ":" ) );
        IF NOT valid OF code THEN
            # invalid UPC code                                                #
            print( ( "                       error: ", error message OF code, newline ) )
        ELSE
            # valid code                                                      #
            FOR d TO upc digits - 1 DO print( ( whole( ( digits OF code )[ d ], -2 ) ) ) OD;
            print( ( " valid" ) );
            IF inverted OF code THEN print( ( " (inverted)" ) ) FI;
            print( ( newline ) )
        FI
    OD
END
