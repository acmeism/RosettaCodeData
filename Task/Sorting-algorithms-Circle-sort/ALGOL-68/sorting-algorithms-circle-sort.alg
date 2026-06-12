BEGIN # circlesort                                                           #

    # swaps a and b                                                          #
    PRIO =:= = 9;
    OP   =:= = ( REF INT a, b )VOID: BEGIN INT t = a; a := b; b := t END;

    # sorts data in-place and returns a reference to data                    #
    OP   CIRCLESORT = ( REF[]INT data to sort )REF[]INT:
         BEGIN
            PROC circlesort = ( REF[]INT data, INT low, high, swaps so far )INT:
                 IF low >= high THEN swaps so far
                 ELSE
                    INT swaps := swaps so far;
                    INT hi    := high;
                    INT lo    := low;
                    INT mid    = ( hi - lo ) OVER 2;
                    WHILE lo < hi DO
                        IF  data[ lo ] > data[ hi ] THEN
                            data[ lo ] =:= data[ hi ];
                            swaps      +:= 1
                        FI;
                        lo +:= 1;
                        hi -:= 1
                    OD;
                    IF lo = hi AND hi < UPB data THEN
                        IF data[ lo ] > data[ hi + 1 ] THEN
                            data[ lo ] =:= data[ hi + 1 ];
                            swaps      +:= 1
                        FI
                    FI;
                    swaps := circlesort( data, low, low + mid,      swaps );
                    swaps := circlesort( data, low + mid + 1, high, swaps )
                 FI # circlesort # ;

            WHILE circlesort( data to sort, LWB data to sort, UPB data to sort, 0 ) > 0 DO SKIP OD;
            data to sort
         END # CIRCLESORT # ;

    # prints the elements of an array of integers separated by spaces         #
    OP   SHOW = ( []INT list )VOID:
         FOR i FROM LWB list TO UPB list DO
            print( ( " ", whole( list[ i ], 0 ) ) )
         OD # SHOW # ;

    # tests the CIRCLESORT operator                                          #
    PROC test circle sort = ( []INT unsorted )VOID:
         BEGIN
             [ LWB unsorted : UPB unsorted ]INT data := unsorted;
             print( ( "[" ) );
             SHOW unsorted;
             print( ( " ]", newline, "    -> [" ) );
             SHOW CIRCLESORT data;
             print( ( " ]", newline ) )
         END # test circle sort # ;

    # task test case                                                         #
    test circle sort( ( 6, 7, 8, 9, 2, 5, 3, 4, 1 ) );
    # test cases from the Action! sample                                     #
    test circle sort( ( 1, 4, -1, 0, 3, 7, 4, 8, 20, -6 ) );
    test circle sort( ( 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10 ) );
    test circle sort( ( 101, 102, 103, 104, 105, 106, 107, 108 ) );
    test circle sort( ( 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1 ) );
    # additional tests                                                       #
    test circle sort( ( ) );
    test circle sort( ( 1 ) )

END
