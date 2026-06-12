BEGIN # find words that contain more than 3 es and no other vowels            #

    PR read "files.incl.a68" PR                     # include file  utilities #

    # prints word if it contains four or more "e"s and no other vowels        #
    # returns TRUE if word contains four or more "e"s, FALSE otherwoise       #
    # count so far contains the number of preceding matching words            #
    PROC show eeee word = ( STRING word, INT count so far )BOOL:
         IF   INT e count := 0, other vowel count := 0;
              FOR w pos FROM LWB word TO UPB word DO
                  CHAR c = word[ w pos ];
                  IF   c = "e"
                  THEN e count +:= 1
                  ELIF c = "a" OR c = "i" OR c = "o" OR c = "u"
                  THEN other vowel count +:= 1
                  FI
               OD;
               e count < 4 OR other vowel count > 0
         THEN FALSE
         ELSE INT eeee words = count so far + 1;
              print( ( whole( eeee words, -5 ), ": ", word ) );
              TO 20 - ( UPB word - LWB word ) DO print( ( " " ) ) OD;
              print( ( " ", whole( e count, 0 ) ) );
              print( ( newline ) );
              TRUE
         FI # show eeee word # ;

    IF "unixdict.txt" EACHLINE show eeee word < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    FI

END
