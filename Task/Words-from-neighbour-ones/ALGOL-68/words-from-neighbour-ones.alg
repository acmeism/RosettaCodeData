BEGIN # find words where concatenating the nth character from this and the    #
      # next 8 words results in another word - only words of 9 or more        #
      # characters are to be considered                                       #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read "sort.incl.a68" PR                       # include sort utilities #

    # table of possible words - there are around 8 000 9+ character words     #
    [ 1 : 10 000 ]STRING words;                             # in unixdict.txt #

    # returns TRUE if words[ low : high ] comntains s, FALSE otherwise        #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;

    # stores word in words, if it has 9 or more characters                    #
    # returns TRUE if the word was stored, FALSE otherwise                    #
    # count so far will contain the number of such words found so far         #
    PROC store 9 character words = ( STRING word, INT count so far )BOOL:
         IF ( UPB word - LWB word ) + 1 < 9
         THEN FALSE                                              # short word #
         ELSE words[ count so far + 1 ] := word;        # word is long enough #
              TRUE
         FI # store 9 character words # ;

    IF   INT w count = "unixdict.txt" EACHLINE store 9 character words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE                                                   # got the words OK #
         words QUICKSORT ELEMENTS( 1, w count );             # sort the words #
         FOR i TO ( w count + 1 ) - 9 DO            # find the required words #
             STRING c word   := words[ i ][ LWB words[ i ] ];
             INT w pos       := i;
             FOR c pos TO 8 DO
                 STRING w = words[ w pos +:= 1 ];
                 c word +:= w[ c pos + LWB words[ i ] ]
             OD;
             IF is word( c word, 1, w count ) THEN
                 print( ( c word, newline ) )
             FI
        OD
    FI

END
