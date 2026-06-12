BEGIN # find words of 9 or more characters where the odd letters also         #
      # form a word; the odd characters must therefore form a word of at      #
      # least 5 characters                                                    #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read  "sort.incl.a68" PR                      # include sort utilities #

    # returns w split into n parts by taking alternate characters    #
    PRIO SPLIT = 1;
    OP   SPLIT = ( STRING w, INT n )[]STRING:
         BEGIN
            [ n ]STRING result;
            FOR r pos FROM LWB result TO UPB result DO result[ r pos ] := "" OD;
            INT n pos := 1;
            FOR w pos FROM LWB w TO UPB w DO
                result[ n pos ] +:= w[ w pos ];
                n pos +:= 1;
                IF n pos > n THEN n pos := 1 FI
            OD;
            result
         END # SPLIT # ;

    [ 1 : 25 000 ]STRING words;          # unixdict.txt has around 22 000 5+ #
                                                           # character words #

    # stores word in words, if it is at least 5 characters long              #
    # returns TRUE if word was stored, FALSE otherwise                       #
    # count so far will contain the number of words stored so far            #
    PROC store 5 plus character words = ( STRING word, INT count so far )BOOL:
         IF ( UPB word - LWB word ) + 1 < 5
         THEN FALSE                                              # short word #
         ELSE words[ count so far + 1 ] := word;        # word is long enough #
              TRUE
         FI # store 5 plus character words # ;

    # returns TRUE if words[ low : high ] comntains s, FALSE otherwise       #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;


    IF   INT w count = "unixdict.txt" EACHLINE store 5 plus character words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE words QUICKSORT ELEMENTS( 1, w count );             # sort the words #
         FOR i TO w count DO           # find the words where the odd letters #
             STRING word  = words[ i ];            # form a 5+ character word #
             IF  INT w len = ( UPB word - LWB word ) + 1;
                 w len > 8
             THEN                        # word is at least 9 characters long #
                 []STRING sub word = word SPLIT 2;
                 IF   is word( sub word[ 1 ], 1, w count )
                 THEN print( ( word, ": " ) );
                      FROM w len + 1 TO 18 DO print( ( " " ) ) OD;
                      print( ( sub word[ 1 ], newline ) )
                 FI
             FI
         OD
    FI

END
