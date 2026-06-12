BEGIN # find words of 6 or more characters where replacing "e" with "i"       #
      # results in another word                                               #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read "sort.incl.a68"  PR                   # include sorting utilities #

    # returns TRUE if words[ low : high ] comntains s, FALSE otherwise       #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;

    # table of possible words - there are around 20 000 6+ character words    #
    [ 1 : 20 000 ]STRING words;                             # in unixdict.txt #

    # stores word in words, if it has 6 or more characters                    #
    # returns TRUE if the word was stored, FASLE otherwise                    #
    # count so far will contain the number of such words found so far         #
    PROC store 6 character words = ( STRING word, INT count so far )BOOL:
         IF ( UPB word - LWB word ) + 1 < 6
         THEN FALSE                                              # short word #
         ELSE words[ count so far + 1 ] := word;        # word is long enough #
              TRUE
         FI # store 6 character words # ;


    IF   INT w count = "unixdict.txt" EACHLINE store 6 character words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE words QUICKSORT ELEMENTS( 1, w count );             # sort the words #
         FOR i TO w count DO        # find the words where changing e to i is #
             STRING word  = words[ i ];                        # still a word #
             IF INT w len = ( UPB word - LWB word ) + 1;
                w len > 5
             THEN                        # word is at least 6 characters long #
                 STRING i word := words[ i ];
                 FOR w pos FROM LWB i word TO UPB i word DO
                     IF i word[ w pos ] = "e" THEN i word[ w pos ] := "i" FI
                 OD;
                 IF i word /= words[ i ] THEN      # there was at least 1 "e" #
                     IF is word( i word, 1, w count )       # the new word is #
                     THEN                                   #    still a word #
                         print( ( words[ i ] ) );
                         TO 18 - w len DO print( ( " " ) ) OD;
                         print( ( "-> ", i word, newline ) )
                     FI
                 FI
             FI
         OD
    FI

END
