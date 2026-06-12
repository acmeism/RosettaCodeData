BEGIN # find 6 (or more) character words with the same 3 first and last letters
      #

    PR read "files.incl.a68" PR                      # include file utilities #

    # prints word if it is 6 or more characters long and has the same first   #
    # and last three characters and returns TRUE if printed, FALSE ptherwise  #
    # count so far holds the number of matching words detected so far         #
    PROC show same 3 start and end = ( STRING word, INT count so far )BOOL:
         IF   INT w len = ( UPB word + 1 ) - LWB word;
              w len < 6
         THEN FALSE
         ELIF word[ 1 : 3 ] /= word[ w len - 2 : ]
         THEN FALSE
         ELSE print( ( word, " " ) );
              IF ( count so far + 1 ) MOD 5 = 0
              THEN print( ( newline ) )
              ELSE FROM w len + 1 TO 14 DO print( ( " " ) ) OD
              FI;
              TRUE
         FI # show same 3 start and end # ;

    IF  INT count = "unixdict.txt" EACHLINE show same 3 start and end;
        count < 0
    THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    ELSE
        print( ( newline, "found ", whole( count, 0 ) ) );
        print( ( " words with the same first and last 3 characters" ) );
        print( ( newline ) )
    FI

END
