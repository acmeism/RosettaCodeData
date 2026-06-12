BEGIN # construct a list of the squares from some other lists                 #
    # lists are represented by arrays in this sample                          #
    PR read "rows.incl.a68" PR               # incldue row printing utilities #
    PR read "sort.incl.a68" PR               # include row sorting  utilities #

    # construct the lists of numbers required by the task #
    [][]INT list = ( (  3,   4, 34,  25,  9, 12, 36, 56, 36 )
                   , (  2,   8, 81, 169, 34, 55, 76, 49,  7 )
                   , ( 75, 121, 75, 144, 35, 16, 46, 35     )
                   );
    # find the elements of the lists that are squares                         #
    INT r pos   := 0;
    HEAP[ 1 : 0 ]INT empty list;
    REF[]INT squares := empty list;
    FOR i FROM LWB list TO UPB list DO
        FOR j FROM LWB list[ i ] TO UPB list[ i ] DO
            IF   INT  n    = list[ i ][ j ];
                 REAL root = sqrt( n );
                 root = ENTIER root
            THEN # have a square #
                 r pos +:= 1;
                 IF r pos > UPB squares THEN
                     # the squares array isn't big enough - make a larger one #
                     HEAP[ 1 : UPB squares + 10 ]INT new squares;
                     new squares[ 1 : UPB squares ] := squares;
                     squares                        := new squares
                 FI;
                 squares[ r pos ] := n
            FI
        OD
    OD;
    squares QUICKSORT ELEMENTS( 1, r pos );
    SHOW squares[ 1 : r pos ]; print( ( newline ) )
END
