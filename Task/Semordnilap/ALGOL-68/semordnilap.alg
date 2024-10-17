BEGIN # find the semordnilaps (words that are the reverse of another word)   #

    PR read "files.incl.a68" PR                     # include file utilities #

    [ 1 : 30 000 ]STRING words;       # guess that this will be enough words #
    INT semordnilap count := 0;        # number of semordnilaps found so far #
    INT max report         = 5;             # number of semordnilaps to show #

    # returns TRUE if words[ low : high ] comntains s, FALSE otherwise       #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;

    # returns text with the characters reversed                              #
    OP   REVERSE = ( STRING text )STRING:
         BEGIN
            STRING reversed  := text;
            INT    start pos := LWB text;
            FOR end pos FROM UPB reversed BY -1 TO LWB reversed
            DO
                reversed[ end pos ] := text[ start pos ];
                start pos +:= 1
            OD;
            reversed
         END # REVERSE # ;

    # returns FALSE if the reverse of word is in words, TRUE otherwise       #
    # if the reverse is not present, it is added to words                    #
    # if the reverse is present, it is reported as a seordnilap - if the     #
    # maximum number hasn't been reported yet                                #
    # count so far will contain the number of words stored so far            #
    PROC store non semordnilaps = ( STRING word, INT count so far )BOOL:
         IF   STRING r word = REVERSE word;
              is word( r word, 1, count so far )
         THEN IF   ( semordnilap count +:= 1 ) <= max report
              THEN print( ( word, " & ", r word, newline ) )
              FI;
              FALSE
         ELSE words[ count so far + 1 ] := word;
              TRUE
         FI # store non semordnilaps # ;


    # find the semordnilaps - assumes unixdict.txt is sorted                 #
    IF   "unixdict.txt" EACHLINE store non semordnilaps < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE print( ( whole( semordnilap count, 0 ), " semordnilaps found", newline ) )
    FI

END
