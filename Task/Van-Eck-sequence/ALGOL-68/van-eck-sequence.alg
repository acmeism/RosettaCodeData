BEGIN # find elements of the Van Eck Sequence - first term is 0, following  #
      # terms are 0 if the previous was the first appearance of the element #
      #        or how far back in the sequence the last element appeared    #
    # returns the first n elements of the Van Eck sequence                  #
    OP VANECK = ( INT n )[]INT:
       BEGIN
            [ 1 : IF n < 0 THEN 0 ELSE n FI ]INT result; FOR i TO n DO result[ i ] := 0 OD;
            [ 0 : UPB result ]INT pos;  FOR i FROM 0 TO n DO pos[ i ] := 0 OD;
            FOR i FROM 2 TO n DO
                INT j    = i - 1;
                INT prev = result[ j ];
                IF pos[ prev ] /= 0 THEN
                    # not a new element                                     #
                    result[ i ] := j - pos[ prev ]
                FI;
                pos[ prev ] := j
            OD;
            result
       END # VANECK # ;
    # construct the first 1000 terms of the sequence                        #
    []INT seq = VANECK 1000;
    # show the first and last 10 elements                                   #
    FOR i TO 10 DO print( ( " ", whole( seq[ i ], 0 ) ) ) OD;
    print( ( newline ) );
    FOR i FROM UPB seq - 9 TO UPB seq DO print( ( " ", whole( seq[ i ], 0 ) ) ) OD;
    print( ( newline ) )
END
