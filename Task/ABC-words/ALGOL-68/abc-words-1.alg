BEGIN # find words that have "a", "b" and "C" in order in them               #

    PR read "files.incl.a68" PR                     # include file utilities #

    # prints word if the characters "a", "b" and "c" appear in order in it   #
    # count so far is thw number of preceding "abc" words                    #
    # returns TRUE if word is such an "abc" word, FALSE otherwise            #
    PROC show abc word = ( STRING word, INT count so far )BOOL:
         IF   grep in string( "^[^bc]*a[^c]*b.*c", word, NIL, NIL ) = 0
         THEN INT abc count = count so far + 1;
              print( ( whole( abc count, -5 ), ": ", word, newline ) );
              TRUE
         ELSE FALSE
         FI # show abc word # ;

    IF "unixdict.txt" EACHLINE show abc word < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    FI

END
