BEGIN

    # just generate 0s and 1s without storing them #
    PROC run test = ( REAL p, INT len, runs )REAL:
         BEGIN
            INT  count := 0;
            REAL thresh = p;
            TO runs DO
               INT x := 0;
               FOR i FROM len BY -1 TO 1 DO
                  INT y   = ABS ( random < thresh );
                  count +:= ABS ( x < y );
                  x := y
               OD
            OD;
            count / runs / len
         END # run test # ;

    print( ( "running 1000 tests each:", newline ) );
    print( ( " p          n       K  p(1-p)       diff", newline ) );
    print( ( "----------------------------------------------", newline ) );
    FOR ip BY 2 TO 9 DO
        REAL p = ip / 10;
        REAL p1p = p * (1 - p);
        INT n := 10;
        WHILE ( n *:= 10 ) <= 100000 DO
	    REAL k = run test( p, n, 1000 );
            print( ( fixed( p, -4, 1 ), whole( n, -9 ), fixed( k, -8, 4 )
                   , fixed( p1p, -8, 4 ), fixed( k - p1p, 9, 4 )
                   , " (", fixed( ( k - p1p ) / p1p * 100, 5, 2 ), "%)", newline
                   )
                 )
        OD;
        print( ( newline ) )
    OD
END
