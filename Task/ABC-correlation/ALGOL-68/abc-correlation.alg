BEGIN # find words that contain equal numbers of "a", "b" and "c" characters #
      # and print those that contain at least 2 of each                      #

    PR read "files.incl.a68" PR                     # include file utilities #

    # returns the couunts of each character in c that is in s                #
    PRIO COUNT = 5;
    OP   COUNT = ( STRING s, c )[]INT:
         BEGIN
            [ LWB c : UPB c ]INT result; FOR i FROM LWB c TO UPB c DO result[ i ] := 0 OD;
            FOR i FROM LWB s TO UPB s DO
                INT c pos := 0;
                IF char in string( s[ i ], c pos, c ) THEN result[ c pos ] +:= 1 FI
            OD;
            result
         END # COUNT # ;
    # returns TRUE if all elements of a are equal, FALSE otherwise           #
    OP   EQUAL = ( []INT a )BOOL:
         IF LWB a >= UPB a THEN TRUE                        # 0 or 1 element #
         ELSE
            INT v = a[ LWB a ];
            BOOL same := TRUE;
            FOR i FROM LWB a + 1 TO UPB a WHILE same := v = a[ i ] DO SKIP OD;
            same
         FI # same # ;

    # prints word if the number of "a", "b" and "c" in it are equal and      #
    # there are at least two of each                                         #
    # returns TRUE if word is such an "abc" word, FALSE otherwise            #
    PROC show abc word = ( STRING word, INT count so far )BOOL:
         IF  []INT abc counts = word COUNT "abc";
             IF abc counts[ LWB abc counts ] < 2 THEN FALSE ELSE EQUAL abc counts FI
         THEN print( ( word, newline ) );
              TRUE
         ELSE FALSE
         FI # show abc word # ;

    IF   INT w count = "words_alpha.txt" EACHLINE show abc word;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE print( ( newline, "found ", whole( w count, 0 ), " words", newline ) )
    FI

END
