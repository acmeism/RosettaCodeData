BEGIN # sort a disjoint sub-set of a list                                    #

    PR read "sort.incl.a68" PR # include sort utilities, including QUICKSORT #
    PR read "rows.incl.a68" PR     # include array utilities, including SHOW #

    # in-place quicksorts the subset of data specified by indexes            #
    OP   QUICKSORT = ( REF[]INT data, []INT unsorted indexes )VOID:
         BEGIN
            [ LWB unsorted indexes : UPB unsorted indexes ]INT sorted indexes := unsorted indexes;
            QUICKSORT sorted indexes;

            # in-place quicksorts the subset of a defined by                 #
            # indexes[ low : high ]                                          #
            PROC indexed quicksort = ( REF[]INT a, indexes, INT low, high )VOID:
                 IF INT lb = low, ub = high;
                    ub > lb
                 THEN                  # more than one element, so must sort #
                    INT left  := lb;
                    INT right := ub;
                    # use the middle element of the indexes as the pivot     #
                    INT pivot := a[ indexes[ left + ( ( right + 1 ) - left ) OVER 2 ] ];
                    WHILE
                        WHILE IF left  <= ub THEN a[ indexes[ left  ] ] < pivot ELSE FALSE FI
                        DO
                            left  +:= 1
                        OD;
                        WHILE IF right >= lb THEN a[ indexes[ right ] ] > pivot ELSE FALSE FI
                        DO
                            right -:= 1
                        OD;
                        left <= right
                    DO
                        a[ indexes[ left ] ] =:= a[ indexes[ right ] ];
                        left  +:= 1;
                        right -:= 1
                    OD;
                    indexed quicksort( a, indexes, lb,   right );
                    indexed quicksort( a, indexes, left, ub    )
                 FI # indexed quicksort # ;

            indexed quicksort ( data, sorted indexes, LWB sorted indexes, UPB sorted indexes )
         END # QUICKSORT # ;

    BEGIN # task test case                                                   #
        []INT unsorted data = ( 7, 6, 5, 4, 3, 2, 1, 0 );
        [ 0 : UPB unsorted data - LWB unsorted data ]INT sorted data := unsorted data[ AT 0 ];
        []INT indexes       = ( 6, 1, 7 );
        sorted data QUICKSORT indexes;
        SHOW unsorted data; print( ( " -> " ) ); SHOW sorted data
    END

END
