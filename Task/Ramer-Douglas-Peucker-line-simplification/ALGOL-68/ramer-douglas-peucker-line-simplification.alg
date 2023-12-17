BEGIN # Ramer Douglas Peucker algotithm - translated from the Go sample      #

    MODE POINT = STRUCT( REAL x, y );

    PRIO APPEND = 1;
    OP   APPEND = ( []POINT a, b )[]POINT:        # append two POINT  arrays #
         BEGIN
             INT len a = ( UPB a - LWB a ) + 1;
             INT len b = ( UPB b - LWB b ) + 1;
             [ 1 : lena + len b ]POINT result;
             result[           : len a ] := a;
             result[ len a + 1 :       ] := b;
             result
         END # APPEND # ;

    PROC rdp = ( []POINT l, REAL epsilon )[]POINT:   # Ramer Douglas Peucker #
         BEGIN                                                   # algorithm #
            INT   x     := 0;
            REAL  d max := -1;
            POINT p1     = l[ LWB l ];
            POINT p2     = l[ UPB l ];
            REAL  x21    = x OF p2 - x OF p1;
            REAL  y21    = y OF p2 - y OF p1;
            REAL  p2xp1y = x OF p2 * y OF p1;
            REAL  p2yp1x = y OF p2 * x OF p1;
            FOR i FROM LWB l TO UPB l DO
                POINT p = l[ i ];
                IF REAL d := ABS ( y21 * x OF p - x21 * y OF p + p2xp1y - p2yp1x); d > d max
                THEN
                    x     := i;
                    d max := d
                FI
            OD;
            IF d max > epsilon THEN
                rdp( l[ : x ], epsilon ) APPEND rdp( l[ x + 1 : ],     epsilon )
            ELSE
                []POINT( l[ LWB l ], l[ UPB l ] )
            FI
         END # rdp # ;

    OP   FMT = ( REAL v )STRING:           # formsts v with up to 2 decimals #
         BEGIN
            STRING result := fixed( ABS v, 0, 2 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" + result ELSE result FI
         END # FMT # ;
    OP   SHOW = ( []POINT a )VOID:               # prints an array of points #
         BEGIN
            print( ( "[" ) );
            FOR i FROM LWB a TO UPB a DO
                print( ( " ( ", FMT x OF a[ i ], ", ",  FMT y OF a[ i ], " )" ) )
            OD;
            print( ( " ]" ) )
         END # SHOW # ;

    SHOW rdp( ( ( 0, 0 ), ( 1, 0.1 ), ( 2, -0.1 ), ( 3, 5 ), ( 4, 6 )
              , ( 5, 7 ), ( 6, 8.1 ), ( 7,  9   ), ( 8, 9 ), ( 9, 9 )
              )
            , 1
            )
END
