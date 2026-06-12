BEGIN
    # returns s with the characters sorted into lexicographic order          #
    OP   LSORT = ( STRING s )STRING:
         BEGIN
            [ 1 : UPB s[ @ 1 ] ]CHAR c := s[ @ 1 ];
            FOR u FROM UPB c - 1 BY -1 TO LWB c
            WHILE
                BOOL sorted := TRUE;
                FOR p FROM LWB c BY 1 TO u DO
                    IF c[ p ] > c[ p + 1 ] THEN
                        CHAR t := c[ p ];
                        c[ p     ] := c[ p + 1 ];
                        c[ p + 1 ] := t;
                        sorted := FALSE
                    FI
                OD;
                NOT sorted
            DO SKIP OD;
            c
         END; # SORT #
    print( ( LSORT "The quick brown fox jumps over the lazy dog, apparently", newline ) );
    print( ( LSORT "Now is the time for all good men to come to the aid of their country.", newline ) )
END
