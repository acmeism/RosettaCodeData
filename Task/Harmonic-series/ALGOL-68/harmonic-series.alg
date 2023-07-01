BEGIN # find some harmonic numbers, Hn is the sum if the reciprocals of 1..n #
    # returns the first n Harmonic numbers #
    OP   HARMONIC = ( INT n )[]REAL:
         BEGIN
            [ 1 : n ]REAL h;
            h[ 1 ] := 1;
            FOR i FROM 2 TO n DO
                h[ i ] := h[ i - 1 ] + ( 1 / i )
            OD;
            h
         END # HARMONIC # ;
    # find the first 20 000 harmonic numbers #
    []REAL h = HARMONIC 20 000;
    # show the first 20 harmonic numbers #
    FOR i TO 20 DO
        print( ( whole( i, -2 ), ":", fixed( h[ i ], -14, 8 ), newline ) )
    OD;
    # find the positions of the first harmonic number > n where n in 1... #
    INT  rqd int  := 1;
    REAL rqd real := 1;
    FOR i TO UPB h DO
        IF h[ i ] > rqd real THEN
            # found the first harmonic number greater than rqd real #
            print( ( "Position of the first harmonic number > ", whole( rqd int, -2 ), ": ", whole( i, 0 ), newline ) );
            rqd int  +:= 1;
            rqd real +:= 1
        FI
    OD
END
