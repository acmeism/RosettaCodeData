BEGIN # Logistic curve fitting in epidemiology - translation of Java #

    REAL k  = 7.8e9;
    INT  n0 = 27;

    []REAL actual
        = (     27.0,     27.0,     27.0,      44.0,      44.0,      59.0,      59.0
          ,     59.0,     59.0,     59.0,      59.0,      59.0,      59.0,      60.0
          ,     60.0,     61.0,     61.0,      66.0,      83.0,     219.0,     239.0
          ,    392.0,    534.0,    631.0,     897.0,    1350.0,    2023.0,    2820.0
          ,   4587.0,   6067.0,   7823.0,    9826.0,   11946.0,   14554.0,   17372.0
          ,  20615.0,  24522.0,  28273.0,   31491.0,   34933.0,   37552.0,   40540.0
          ,  43105.0,  45177.0,  60328.0,   64543.0,   67103.0,   69265.0,   71332.0
          ,  73327.0,  75191.0,  75723.0,   76719.0,   77804.0,   78812.0,   79339.0
          ,  80132.0,  80995.0,  82101.0,   83365.0,   85203.0,   87024.0,   89068.0
          ,  90664.0,  93077.0,  95316.0,   98172.0,  102133.0,  105824.0,  109695.0
          , 114232.0, 118610.0, 125497.0,  133852.0,  143227.0,  151367.0,  167418.0
          , 180096.0, 194836.0, 213150.0,  242364.0,  271106.0,  305117.0,  338133.0
          , 377918.0, 416845.0, 468049.0,  527767.0,  591704.0,  656866.0,  715353.0
          , 777796.0, 851308.0, 928436.0, 1000249.0, 1082054.0, 1174652.0
          );

        PROC f = ( REAL r )REAL:
             BEGIN
                REAL sq := 0;
                INT  i0 := 0; # note, in Java arrays have lower bound 0 #
                FOR i FROM LWB actual TO UPB actual DO
                    REAL eri   = exp( r * i0 );
                    REAL guess = ( n0 * eri ) / ( 1 + n0 * ( eri - 1 ) / k );
                    REAL diff  = guess - actual[ i ];
                    sq +:= diff * diff;
                    i0 +:= 1
                OD;
                sq
             END # f # ;

    PROC solve = ( PROC(REAL)REAL fn, REAL initial guess, epsilon )REAL:
         BEGIN
            REAL guess  := initial guess;
            REAL delta  := IF guess /= 0 THEN guess ELSE 1 FI;
            REAL f0     := fn( guess );
            REAL factor := 2;
            WHILE delta > epsilon AND guess /= guess - delta DO
                REAL nf := fn( guess - delta );
                IF nf < f0 THEN
                    f0     := nf;
                    guess -:= delta
                ELSE
                    nf := fn( guess + delta );
                    IF nf < f0 THEN
                        f0     := nf;
                        guess +:= delta
                    ELSE
                        factor := 0.5
                    FI
                FI;
                delta *:= factor
            OD;
            guess
         END # solve # ;

    BEGIN
        REAL r  = solve( f, 0.5, 0.0 );
        print( ( "r = ", fixed( r, -11, 8 ), ", R0 = ", fixed( exp( 12 * r ), -11, 8 ), newline ) )
    END
END
