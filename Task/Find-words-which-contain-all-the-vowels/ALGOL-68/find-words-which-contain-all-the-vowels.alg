BEGIN # find 11 or more character words that contain all the vowels once      #

    PR read "files.incl.a68" PR                     # include file  utilities #

    # prints word if it contains all the vowels once;                         #
    # returns TRUE if it does, FALSE otherwise                                #
    # count so far will contain the number of such words preceding this one   #
    PROC show vowel word = ( STRING word, INT count so far )BOOL:
         IF   ( UPB word - LWB word ) + 1 <= 10
         THEN FALSE
         ELSE                         # have an eleven or more character word #
              INT a count := 0, e count := 0, i count := 0, o count := 0, u count := 0;
              FOR w pos FROM LWB word TO UPB word DO
                  CHAR c = word[ w pos ];
                  IF   c = "a" THEN a count +:= 1
                  ELIF c = "e" THEN e count +:= 1
                  ELIF c = "i" THEN i count +:= 1
                  ELIF c = "o" THEN o count +:= 1
                  ELIF c = "u" THEN u count +:= 1
                  FI
              OD;
              IF a count /= 1 OR e count /= 1 OR i count /= 1 OR o count /= 1 OR u count /= 1
              THEN FALSE
              ELSE INT vowel words = count so far + 1;
                   print( ( whole( vowel words, -5 ), ": ", word, newline ) );
                   TRUE
              FI
         FI # show vowel words # ;

    IF "unixdict.txt" EACHLINE show vowel word < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    FI

END
