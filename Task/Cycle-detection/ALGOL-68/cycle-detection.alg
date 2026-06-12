BEGIN # Brent's cycle detection algorithm - translated from Kotlin            #

    PR read "rows.incl.a68" PR         # include row utilities including SHOW #

    MODE INTTOINT = PROC(INT)INT;
    MODE CYCLE    = STRUCT( INT lam, mu );

    PROC brent = ( INTTOINT f, INT x0 )CYCLE:
         BEGIN
            # main phase: search successive powers of two                     #
            INT power    := 1;
            INT lam      := 1;
            INT tortoise := x0;
            INT hare     := f( x0 ); # f(x0) is the element/node next to x0.  #
            WHILE tortoise /= hare DO
                IF power = lam THEN  # time to start a new power of two?      #
                    tortoise := hare;
                    power   *:= 2;
                    lam      := 0
                FI;
                hare := f( hare );
                lam +:= 1
            OD;

            # Find the position of the first repetition of length 'lam'       #
            INT mu   :=  0;
            tortoise := x0;
            hare     := x0;
            TO lam DO hare := f( hare ) OD;

            # The distance between the hare and tortoise is now 'lam'.        #
            # Next, the hare and tortoise move at same speed until they agree #
            WHILE tortoise /= hare DO
                tortoise := f( tortoise );
                hare     := f( hare );
                mu      +:= 1
            OD;
            ( lam, mu )
         END # brent # ;

    BEGIN
        INTTOINT f = ( INT v )INT: ( v * v + 1 ) MOD 255;
        # generate first 41 terms of the sequence starting from 3             #
        INT x0 = 3;
        INT x := x0;
        [ 1 : 41 ]INT seq;
        seq[ LWB seq ] := x;
        FOR it FROM LWB seq + 1 TO UPB seq DO seq[ it ] := x := f( x ) OD;
        SHOW seq; print( ( newline ) );
        CYCLE b = brent( f, x0 );
        print( ( "Cycle length = ", whole( lam OF b, 0 ), newline ) );
        print( ( "Start index  = ", whole(  mu OF b, 0 ), newline ) );
        []INT cycle = seq[ mu OF b : ( mu OF b + lam OF b ) - 1 ];
        print( ( "Cycle        = " ) ); SHOW cycle; print( ( newline ) )
    END
END
