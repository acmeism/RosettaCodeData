BEGIN # Gosper's Hack - translated from the Pluto sample                #

    PR read "bits.incl.a68" PR   # include bit manipulation utilities   #

    # returns the next highest integer with the same number of set bits #
    PROC gospers hack = ( INT x )INT:             # using Gosper's Hack #
         BEGIN
            INT c = x AND - x;
            INT r = x + c;
            ENTIER ( ENTIER ( ( r XOR x ) / 4 ) / c ) OR r
         END # gospers hack # ;

    FOR n TO 4 DO
        INT x := ( 2 ^ n ) - 1;
        print( ( whole( x, -2 ), ":" ) );
        TO 10 DO
            x := gospers hack( x );
            print( ( " ", whole( x, 0 ) ) )
        OD;
        print( ( newline ) )
    OD
END
