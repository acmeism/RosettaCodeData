BEGIN # comb sort #
    PR read "rows.incl.a68" PR # include row (array) utilities - SHOW is used to display the array #
    # comb-sorts in-place the array of integers input #
    PROC comb sort = ( REF[]INT input )VOID:
         IF INT  input size = ( UPB input - LWB input ) + 1;
            input size > 1
         THEN # more than one element, so must sort #
            INT  gap     := input size; # initial gap is the whole array size #
            BOOL swapped := TRUE;
            WHILE gap /= 1 OR swapped DO
                # update the gap value for a next comb #
                gap := ENTIER ( gap / 1.25 );
                IF gap < 1 THEN
                    # ensure the gap is at least 1 #
                    gap := 1
                FI;
                INT i := LWB input;
                swapped := FALSE;
                # a single "comb" over the input list #
                FOR i FROM LWB input WHILE i + gap <= UPB input DO
                    INT t     = input[ i ];
                    INT i gap = i + gap;
                    IF t > input[ i gap ] THEN
                        # need to swap out-of-order items #
                        input[ i     ] := input[ i gap ];
                        input[ i gap ] := t;
                        swapped := TRUE # Flag a swap has occurred, so the list is not guaranteed sorted yet #
                    FI
                OD
            OD
         FI # comb sort # ;
    # test #
    [ 1 : 7 ]INT data := ( 9, -4, 0, 2, 3, 77, 1 );  # data to sort #
    SHOW data;
    comb sort( data );
    print( ( " -> " ) );
    SHOW data
END
