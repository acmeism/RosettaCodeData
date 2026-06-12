BEGIN # find alternade words (words whose alternate letters also form words) #

    PR read "files.incl.a68" PR                     # include file utilities #
    PR read  "sort.incl.a68" PR                     # include sort utilities #

    # returns w split into n parts by taking alternate characters            #
    PRIO SPLIT = 1;
    OP   SPLIT = ( STRING w, INT n )[]STRING:
         BEGIN
            [ n ]STRING result;
            FOR init pos FROM LWB result TO UPB result DO result[ init pos ] := "" OD;
            INT r pos := 1;
            FOR w pos FROM LWB w TO UPB w DO
                result[ r pos ] +:= w[ w pos ];
                r pos +:= 1;
                IF r pos > n THEN r pos := 1 FI
            OD;
            result
         END # SPLIT # ;


    [ 1 : 30 000 ]STRING words;

    # stores word in words                                                   #
    # count so far will contain the number of words stored so far            #
    # returns TRUE                                                           #
    PROC store words = ( STRING word, INT count so far )BOOL:
         BEGIN
            words[ count so far + 1 ] := word;
            TRUE
         END # store words # ;

    # returns TRUE if words[ low : high ] comntains s, FALSE otherwise       #
    PROC is word = ( STRING s, INT low, high )BOOL:
         IF   high < low THEN FALSE
         ELSE INT mid = ( low + high ) OVER 2;
              IF   words[ mid ] > s THEN is word( s, low,     mid - 1 )
              ELIF words[ mid ] = s THEN TRUE
              ELSE                       is word( s, mid + 1, high    )
              FI
         FI # is word # ;


    IF   INT w count = "unixdict.txt" EACHLINE store words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE words QUICKSORT ELEMENTS( 1, w count );             # sort the words #
         FOR i TO w count DO                            # find the alternades #
             STRING word  = words[ i ];
             IF  INT w len = ( UPB word - LWB word ) + 1;
                 w len > 5
             THEN                        # word is at least 6 characters long #
                 []STRING sub word = word SPLIT 2;
                 IF   is word( sub word[ 1 ], 1, w count )
                 AND  is word( sub word[ 2 ], 1, w count )
                 THEN print( ( word, ": " ) );
                      TO 18 - w len DO print( ( " " ) ) OD;
                      print( ( sub word[ 1 ], ", ", sub word[ 2 ], newline ) )
                 FI
             FI
         OD
    FI

END
