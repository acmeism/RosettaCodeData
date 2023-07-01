BEGIN # calculate Lah numbers upto L( 12, 12 )                                      #
    PR precision 400 PR # set the precision for LONG LONG INT                       #
    # returns Lah Number L( n, k ), f must be a table of factorials to at least n   #
    PROC lah = ( INT n, k, []LONG LONG INT f )LONG LONG INT:
         IF   n = k          THEN 1
         ELIF n = 0 OR k = 0 THEN 0
         ELIF k = 1          THEN f[ n ]
         ELIF k > n          THEN 0
         ELSE
            # general case: ( n! * ( n - 1 )! ) / ( k! * ( k - 1 )! ) / ( n - k )!  #
            # we re-arrange the above to:                                           #
            #   (    n!      /    k! )      -- t1                                   #
            # * ( ( n - 1 )! / ( k - 1 )! ) -- t2                                   #
            # / ( n - k )!                                                          #
            LONG LONG INT t1 = f[ n     ] OVER f[ k     ];
            LONG LONG INT t2 = f[ n - 1 ] OVER f[ k - 1 ];
            ( t1 * t2 ) OVER f[ n - k ]
         FI # lah # ;
    INT max n       = 100; # max n for Lah Numbers                                  #
    INT max display =  12; # max n to display L( n, k ) values                      #
    # table of factorials up to max n                                               #
    [ 1 : max n ]LONG LONG INT factorial;
    BEGIN
        LONG LONG INT f := 1;
        FOR i TO UPB factorial DO factorial[ i ] := f *:= i OD
    END;
    # show the Lah numbers                                                          #
    print( ( "Unsigned Lah numbers", newline ) );
    print( ( "n/k  0" ) );
    FOR i FROM 1 TO max display DO print( ( whole( i, -11 ) ) ) OD;
    print( ( newline ) );
    FOR n FROM 0 TO max display DO
        print( ( whole( n, -2 ) ) );
        print( ( whole( lah( n, 0, factorial ), -4 ) ) );
        FOR k FROM 1 TO n DO
            print( ( whole( lah( n, k, factorial ), -11 ) ) )
        OD;
        print( ( newline ) )
    OD;
    # maximum value of a Lah number for n = 100                                     #
    LONG LONG INT max 100 := 0;
    FOR k FROM 0 TO 100 DO
        LONG LONG INT lah n k = lah( 100, k, factorial );
        IF lah n k > max 100 THEN max 100 := lah n k FI
    OD;
    print( ( "maximum Lah number for n = 100: ", whole( max 100, 0 ), newline ) )
END
