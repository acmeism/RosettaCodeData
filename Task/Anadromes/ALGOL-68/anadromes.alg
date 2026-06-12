BEGIN # find some anadromes: words that when reversed are also words         #
    # in-place quick sort an array of strings                                #
    PROC s quicksort = ( REF[]STRING a, INT lb, ub )VOID:
         IF ub > lb
         THEN
            # more than one element, so must sort                            #
            INT  left  := lb;
            INT  right := ub;
            # choosing the middle element of the array as the pivot          #
            STRING pivot := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
            WHILE
                WHILE IF left  <= ub THEN a[ left  ] < pivot ELSE FALSE FI
                DO
                    left  +:= 1
                OD;
                WHILE IF right >= lb THEN a[ right ] > pivot ELSE FALSE FI
                DO
                    right -:= 1
                OD;
                left <= right
            DO
                STRING t   := a[ left  ];
                a[ left  ] := a[ right ];
                a[ right ] := t;
                left      +:= 1;
                right     -:= 1
            OD;
            s quicksort( a, lb,   right );
            s quicksort( a, left, ub    )
         FI # s quicksort # ;
    # returns TRUE if item is in list, FALSE otherwise                       #
    # - based on the iterative routine in the binary search task             #
    PROC contains = ( []STRING list, STRING item, INT lb, ub )BOOL:
         BEGIN
            INT  low  := lb,
            INT  high := ub;
            WHILE low < high DO
                INT mid =  ( low + high ) OVER 2;
                IF   list[ mid ] > item THEN high := mid - 1
                ELIF list[ mid ] < item THEN low  := mid + 1
                ELSE low := high := mid
                FI
            OD;
            list[ low ] = item
         END # contains # ;

    # set the end of file handler for stand in                               #
    on logical file end( stand in, ( REF FILE f )BOOL: at eof := TRUE );

    [ 1 : 500 000 ]STRING words;
    INT   t count    := 0;
    INT   w count    := 0;
    INT   max length := 0;
    BOOL  at eof     := FALSE;
    WHILE
        STRING word;
        read( ( word, newline ) );
        NOT at eof
    DO
        t count +:= 1;
        INT w length := 1 + ( UPB word - LWB word );
        IF w length > 6 THEN
            w count +:= 1;
            words[ w count ] := word;
            IF w length > max length THEN max length := w length FI
        FI
    OD;
    print( ( "read ", whole( t count, 0 ), " words, "
           , "the longest is ", whole( max length, 0 ), " characters"
           , newline
           , "     ", whole( w count, 0 ), " words are longer than 6 characters"
           , newline, newline
           )
         );
    s quicksort( words, 1, w count ); # sort the words for binary search      #
    print( ( "The following anadromes are present:", newline, newline ) );
    INT a count := 0;
    FOR i TO w count DO
        STRING word = words[ i ];
        STRING reverse word := "";
        FOR w pos FROM LWB word TO UPB word DO word[ w pos ] +=: reverse word OD;
        IF word < reverse word THEN
            IF contains( words, reverse word, 1, w count ) THEN
                # have an anadromic pair                                      #
                INT w length = 1 + ( UPB words[ i ] - LWB words[ i ] );
                TO 10 - w length DO print( ( " " ) ) OD;
                print( ( words[ i ], " :: ", reverse word, newline ) );
                a count +:= 1
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( a count, 0 ), " anadromes", newline ) )
END
