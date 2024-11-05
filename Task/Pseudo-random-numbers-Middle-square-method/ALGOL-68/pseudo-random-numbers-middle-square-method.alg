BEGIN # generate random numbers by the middle-square method #
    INT seed := 675248;
    # returns the next middle-square random number #
    PROC ms random = INT:
         seed := SHORTEN( ( ( LONG INT( seed ) * LONG INT( seed ) ) OVER 1000 ) MOD 1 000 000 );
    # test the ms random procedure #
    TO 5 DO
        print( ( " ", whole( ms random, 0 ) ) )
    OD;
    print( ( newline ) )
END
