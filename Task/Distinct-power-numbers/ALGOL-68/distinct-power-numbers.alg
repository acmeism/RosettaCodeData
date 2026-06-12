BEGIN # show in order, distinct values of a^b where 2 <= a <= b <= 5        #
    INT max number = 5;
    INT min number = 2;
    # construct a table of a ^ b                                            #
    INT length     = ( max number + 1 ) - min number;
    [ 1 : length * length ]INT a to b;
    INT pos := 0;
    FOR i FROM min number TO max number DO
        a to b[ pos +:= 1 ] := i * i;
        FROM min number + 1 TO max number DO
            INT prev = pos;
            a to b[ pos +:= 1 ] := a to b[ prev ] * i
        OD
    OD;
    # sort the table                                                        #
    # it is small and nearly sorted so a bubble sort should suffice         #
    FOR u FROM UPB a to b - 1 BY -1 TO LWB a to b
    WHILE BOOL sorted := TRUE;
          FOR p FROM LWB a to b BY 1 TO u DO
              IF a to b[ p ] > a to b[ p + 1 ] THEN
                  INT t            = a to b[ p     ];
                  a to b[ p     ] := a to b[ p + 1 ];
                  a to b[ p + 1 ] := t;
                  sorted := FALSE
              FI
          OD;
          NOT sorted
    DO SKIP OD;
    # print the table, excluding duplicates                                 #
    INT last := -1;
    FOR i TO UPB a to b DO
        INT next = a to b[ i ];
        IF next /= last THEN print( ( " ", whole( next, 0 ) ) ) FI;
        last := next
    OD;
    print( ( newline ) )
END
