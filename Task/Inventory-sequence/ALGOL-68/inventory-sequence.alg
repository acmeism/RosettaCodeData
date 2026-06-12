BEGIN # find elements of the inventory sequence                                #

    INT next to show :=  1 000;           # next value to show first element > #
    INT max to show   = 10 000;           # last value to show first element > #

    INT max number    = max to show + 1 000;  # max. element value to consider #
    [ 0 : max number ]INT occurs;         # number of times each number occurs #
    FOR i FROM LWB occurs TO UPB occurs DO occurs[ i ] := 0 OD;
    INT seq pos      := 0;                       # current end of the sequence #
    WHILE next to show <= max to show DO
        INT element := 1;                         # any non-zero value will do #
        FOR n FROM 0 WHILE next to show <= max to show AND element /= 0 DO
            element     := occurs[ n ];
            seq pos    +:= 1;
            IF seq pos <= 100 THEN
                print( ( " ", whole( element, -4 ) ) );
                IF seq pos MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF element > next to show THEN
                print( ( "Element ", whole( seq pos, -8 )
                       , " (", whole( element, -8 )
                       , ") is first > ", whole( next to show, -6 )
                       , newline
                       )
                     );
                next to show +:= 1 000
            FI;
            IF element < max number THEN
                occurs[ element ] +:= 1
            FI
        OD
    OD

END
