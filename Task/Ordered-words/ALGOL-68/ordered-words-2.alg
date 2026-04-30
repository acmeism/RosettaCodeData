BEGIN # find the longest words in unixdict.txt that have all letters in order     #

    PR read "files.incl.a68" PR                          # include file utilities #

    INT    max length := -1;
    [ 1 : 1000 ]STRING ordered words;
    INT    o count    := 0;

    # stores ordered words with the maximum length                                #
    PROC store ordered words = ( STRING word )VOID:
         IF   BOOL ordered := TRUE;
              FOR w pos FROM LWB word + 1 TO UPB word WHILE ordered DO
                  ordered := word[ w pos - 1 ] <= word[ w pos ]
              OD;
              ordered
         THEN INT this length = ( 1 + UPB word ) - LWB word;
              IF this length >= max length THEN
                  IF this length > max length THEN
                      max length := this length;
                      o count    := 0
                  FI;
                  ordered words[ o count +:= 1 ] := word
              FI
         FI # store ordered words # ;

    # read the list of words and store the ordered ones of maximum length         #

    IF  "unixdict.txt" EACHLINE store ordered words < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    ELSE
        print( ( "Maximum length of ordered words: ", whole( max length, 0 ), newline ) );
        print( ( "Found ", whole( o count, 0 ), " ordered words of maximum length:", newline ) );
        FOR o pos TO o count DO
            print( ( "    ", ordered words[ o pos ], newline ) )
        OD
    FI
END
