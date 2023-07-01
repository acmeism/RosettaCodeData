BEGIN # generate random latin squares #

    # Knuth Shuffle routine from the Knuth Shuffle Task  #
    #       modified to shufflw a row of a [,]CHAR array #
    PROC knuth shuffle = (REF[,]CHAR a, INT row)VOID:
    (
      PROC between = (INT a, b)INT :
      (
        ENTIER (random * ABS (b-a+1) + (a<b|a|b))
      );
      FOR i FROM LWB a TO UPB a DO
        INT  j = between(LWB a, UPB a);
        CHAR t = a[row, i];
        a[row, i] := a[row, j];
        a[row, j] := t
      OD
    );

    # generates a random latin square #
    PROC latin square = ( INT n )[,]CHAR:
         BEGIN
            [ 1 : n ]CHAR letters;
            [ 1 : n, 1 : n ]CHAR result;
            FOR col TO n DO
                letters[ col ] := REPR ( ABS "A" + ( col - 1 ) )
            OD;
            FOR row TO n DO
                result[ row, : ] := letters
            OD;
            knuth shuffle( result, 1 );
            FOR row FROM 2 TO n - 1 DO
                BOOL ok := FALSE;
                WHILE
                    knuth shuffle( result, row );
                    BOOL all different := TRUE;
                    FOR prev TO row - 1 WHILE all different DO
                        FOR col TO n
                        WHILE all different :=
                                result[ row, col ] /= result[ prev, col ]
                        DO SKIP OD
                    OD;
                    NOT all different
                DO SKIP OD
            OD;
            # the final row, there is only one possibility for each column #
            FOR col TO n DO
                [ 1 : n ]CHAR free := letters;
                FOR row TO n - 1 DO
                    free[ ( ABS result[ row, col ] - ABS "A" ) + 1 ] := REPR 0
                OD;
                BOOL found := FALSE;
                FOR row FROM 1 LWB result TO 1 UPB result WHILE NOT found DO
                    IF free[ row ] /= REPR 0 THEN
                        found := TRUE;
                        result[ n, col ] := free[ row ]
                    FI
                OD
            OD;
            result
         END # latin suare # ;

    # prints a latin square #
    PROC print square = ( [,]CHAR square )VOID:
         FOR row FROM 1 LWB square TO 1 UPB square DO
             IF 2 LWB square <= 2 UPB square THEN
                 print( ( square[ row, 2 LWB square ] ) );
                 FOR col FROM 2 LWB square + 1 TO 2 UPB square DO
                     print( ( " ", square[ row, col ] ) )
                 OD;
                 print( ( newline ) )
             FI
         OD # print square # ;

    next random;
    print square( latin square(  5 ) );
    print( ( newline ) );
    print square( latin square(  5 ) );
    print( ( newline ) );
    print square( latin square( 10 ) )

END
