BEGIN # find 12 character (or more) words that contain "the"                  #

    PR read "files.incl.a68" PR                      # include file utilities #

    # prints word if it contains "the", returns TRUE if it dows, FALSE if not #
    PROC show the word = ( STRING word, INT count so far )BOOL:
         IF INT w len = ( UPB word + 1 ) - LWB word;
            w len < 12
         THEN FALSE
         ELIF NOT string in string( "the", NIL, word )
         THEN FALSE
         ELSE print( ( word, " " ) );
              IF ( count so far + 1 ) MOD 6 = 0
              THEN print( ( newline ) )
              ELSE FROM w len + 1 TO 18 DO print( ( " " ) ) OD
              FI;
              TRUE
         FI # show the word # ;

    IF   INT count = "unixdict.txt" EACHLINE show the word;
         count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE print( ( newline, "found ", whole( count, 0 ) ) );
         print( ( " ""the"" words", newline ) )
    FI
END
