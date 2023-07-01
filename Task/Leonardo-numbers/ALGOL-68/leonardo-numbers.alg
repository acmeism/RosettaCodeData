BEGIN
    # leonardo number parameters #
    MODE LEONARDO = STRUCT( INT l0, l1, add number );
    # default leonardo number parameters #
    LEONARDO leonardo numbers = LEONARDO( 1, 1, 1 );
    # operators to allow us to specify non-default parameters #
    PRIO WITHLZERO = 9, WITHLONE = 9, WITHADDNUMBER = 9;
    OP   WITHLZERO     = ( LEONARDO parameters, INT l0         )LEONARDO:
         LEONARDO( l0, l1 OF parameters, add number OF parameters );
    OP   WITHLONE      = ( LEONARDO parameters, INT l1         )LEONARDO:
         LEONARDO( l0 OF parameters, l1, add number OF parameters );
    OP   WITHADDNUMBER = ( LEONARDO parameters, INT add number )LEONARDO:
         LEONARDO( l0 OF parameters, l1 OF parameters, add number );
    # show the first n Leonardo numbers with the specified parameters #
    PROC show = ( INT n, LEONARDO parameters )VOID:
         IF n > 0 THEN
            INT l0         = l0         OF parameters;
            INT l1         = l1         OF parameters;
            INT add number = add number OF parameters;
            print( ( whole( l0, 0 ), " " ) );
            IF n > 1 THEN
                print( ( whole( l1, 0 ), " " ) );
                INT lp := l0;
                INT ln := l1;
                FROM 2 TO n - 1 DO
                    INT next = ln + lp + add number;
                    lp := ln;
                    ln := next;
                    print( ( whole( ln, 0 ), " " ) )
                OD
            FI
         FI # show # ;

    # first series #
    print( ( "First 25 Leonardo numbers", newline ) );
    show( 25, leonardo numbers );
    print( ( newline ) );
    # second series #
    print( ( "First 25 Leonardo numbers from 0, 1 with add number = 0", newline ) );
    show( 25, leonardo numbers WITHLZERO 0 WITHADDNUMBER 0 );
    print( ( newline ) )
END
