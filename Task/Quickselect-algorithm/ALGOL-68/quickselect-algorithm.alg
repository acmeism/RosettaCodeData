BEGIN
    # returns the kth lowest element of list using the quick select algorithm #
    PRIO QSELECT = 1;
    OP   QSELECT = ( INT k, REF[]INT list )INT:
         IF LWB list > UPB list THEN
             # empty list #
             0
         ELSE
             # non-empty list #
             # partitions the subset of list from left to right #
             PROC partition = ( REF[]INT plist, INT pleft, pright, pivot index )INT:
                  BEGIN
                      # swaps elements a and b in list #
                      PROC swap = ( REF[]INT slist, INT a, b )VOID:
                           BEGIN
                               INT t       = slist[ a ];
                               slist[ a ] := slist[ b ];
                               slist[ b ] := t
                           END # swap # ;
                      INT pivot value = plist[ pivot index ];
                      swap( plist, pivot index, pright );
                      INT store index := pleft;
                      FOR i FROM pleft TO pright - 1 DO
                          IF plist[ i ] < pivot value THEN
                              swap( plist, store index, i );
                              store index +:= 1
                          FI
                      OD;
                      swap( plist, pright, store index );
                      store index
                  END # partition # ;
             INT  left  := LWB list, right := UPB list, result := 0;
             BOOL found := FALSE;
             WHILE NOT found DO
                 IF left = right THEN
                     result := list[ left ];
                     found := TRUE
                 ELSE
                     INT pivot index
                       = partition( list, left, right
                                  , left + ENTIER ( ( random * ( right - left ) + 1 ) )
                                  );
                     IF k = pivot index THEN
                         result := list[ k ];
                         found := TRUE
                     ELIF k < pivot index THEN
                         right := pivot index - 1
                     ELSE
                         left  := pivot index + 1
                     FI
                 FI
             OD;
             result
         FI # QSELECT # ;
    # test cases #
    FOR i TO 10 DO
        [ 1 : 10 ]INT test := []INT( 9, 8, 7, 6, 5, 0, 1, 2, 3, 4 );
        print( ( whole( i, -2 ), ": ", whole( i QSELECT test, -3 ), newline ) )
    OD
END
