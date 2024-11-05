BEGIN # find some gapful numbers - numbers divisible by f*10 + b #
      # where f is the first digit and b is the final digit      #
    # unary GAPFUL operator - returns TRUE  if n is gapful       #
    #                                 FALSE otherwise            #
    OP   GAPFUL = ( INT n )BOOL:
         BEGIN
            INT abs n  = ABS n;
            INT back   = abs n MOD 10; # final digit             #
            INT front := abs n OVER 10;
            WHILE front > 9 DO front OVERAB 10 OD;
            abs n MOD ( ( front * 10 ) + back ) = 0
         END; # GAPFUL #
    # dyadic GAPFUL operator - returns an array of n gapful      #
    # numbers starting from first                                #
    PRIO GAPFUL = 9;
    OP   GAPFUL = ( INT n, INT first )[]INT:
         BEGIN
            [ 1 : n ]INT result;
            INT g pos := 0;
            FOR i FROM first WHILE g pos < n DO
                IF GAPFUL i THEN result[ g pos +:= 1 ] := i FI
            OD;
            result
         END; # GAPFUL #
    # prints a sequence of gapful numbers                        #
    PROC print gapful = ( []INT seq, INT nstart )VOID:
         BEGIN
            print( ( "First ", whole( ( UPB seq + 1 ) - LWB seq, 0 )
                   , " gapful numbers starting from ", whole( nstart, 0 )
                   , ":", newline
                   )
                 );
            FOR i FROM LWB seq TO UPB seq DO print( ( " ", whole( seq[ i ], 0 ) ) ) OD;
            print( ( newline ) )
         END; # print gapful #
    print gapful( 30 GAPFUL            100,           100 );
    print gapful( 15 GAPFUL      1 000 000,     1 000 000 );
    print gapful( 10 GAPFUL  1 000 000 000, 1 000 000 000 )
END
