BEGIN # find words where changing one letter results in another word          #
      # only words of 12 or more characters are to be considered              #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read "sort.incl.a68"  PR                   # include sorting utilities #

    # returns the length of s                                                 #
    OP LENGTH = ( STRING s )INT: 1 + ( UPB s - LWB s );

    # returns TRUE if words[ low : high ] contains s, FALSE otherwise         #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;

    # table of possible words - there are around 1000 12+ character words     #
    [ 1 : 2 000 ]STRING words;                              # in unixdict.txt #

    # stores word in words, if it has 12 or more characters                   #
    # returns TRUE if the word was stored, FALSE otherwise                    #
    # count so far will contain the number of such words found so far         #
    PROC store 12 character words = ( STRING word, INT count so far )BOOL:
         IF LENGTH word < 12
         THEN FALSE
         ELSE words[ count so far + 1 ] := word;
              TRUE
         FI # store 12 character words # ;

    IF   INT w count = "unixdict.txt" EACHLINE store 12 character words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE words QUICKSORT ELEMENTS( 1, w count );             # sort the words #
         FOR i TO w count DO                      # find the changeable words #
             STRING word    = words[ i ];
             STRING c word := word;
             FOR w FROM LWB word TO UPB word DO
                 FOR c FROM ABS word[ w ] + 1 TO ABS "z" DO
                     c word[ w ] := REPR c;
                     IF is word( c word, 1, w count ) THEN
                         FROM LENGTH word TO 15 DO print( ( " " ) ) OD;
                         print( ( word, " <-> ", c word, newline ) )
                     FI
                 OD;
                 c word[ w ] := word[ w ]
             OD
         OD
    FI

END
