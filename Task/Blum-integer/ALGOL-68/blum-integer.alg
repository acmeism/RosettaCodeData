BEGIN # find Blum integers, semi-primes where both factors are 3 mod 4       #
      #                                   and the factors are distinct       #
    INT max number = 10 000 000;   # maximum possible Blum we will consider  #
    [ 1 : max number ]INT upfc;    # table of unique prime factor counts     #
    [ 1 : max number ]INT lpf;     # table of last prime factors             #
    FOR i TO UPB upfc DO upfc[ i ] := 0; lpf[ i ] := 1 OD;
    FOR i FROM 2 TO UPB upfc OVER 2 DO
        IF upfc[ i ] = 0 THEN
            FOR j FROM i + i BY i TO UPB upfc DO
                upfc[ j ] +:= 1;
                lpf[  j ]  := i
            OD
        FI
    OD;
    # returns TRUE if n is a Blum integer, FALSE otherwise                  #
    PROC is blum = ( INT n )BOOL:
         IF n < 21 THEN FALSE # the lowest primes modulo 4 that are 3 are   #
                              # 3 & 7, so 21 is the lowest possible number  #
         ELIF NOT ODD n THEN FALSE
         ELSE
            INT  v       :=  n;
            INT  f count :=  0;
            INT  f       :=  3;
            WHILE f <= v AND f count < 3 DO
                IF v MOD f = 0 THEN
                    IF f MOD 4 /= 3 THEN
                        f count  := 9 # the prime factor mod 4 isn't 3      #
                    ELSE
                        v OVERAB f;
                        f count +:= 1
                    FI;
                    IF v MOD f = 0 THEN
                        f count := 9 # f is not a distinct factor of n      #
                    FI
                FI;
                f +:= 2
            OD;
            f count = 2
        FI # is blum # ;

    # show various Blum integers                                            #
    print( ( "The first 50 Blum integers:", newline ) );
    INT b count := 0;
    [ 0 : 9 ]INT last count := []INT( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )[ AT 0 ];
    FOR i FROM 21 BY 4 WHILE b count < 400 000 DO
        # Blum integers must be 1 modulo 4                                  #
        IF b count < 50 THEN
            IF is blum( i ) THEN
                b count +:= 1;
                last count[ i MOD 10 ] +:= 1;
                print( ( whole( i, -4 ) ) );
                IF b count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        ELIF upfc[ i ] = 2 THEN
            # two prime factors - could be a Blum integer                    #
            IF lpf[ i ] MOD 4 = 3 THEN
                # the last prime factor mod 4 is three                       #
                IF upfc[ i OVER lpf[ i ] ] = 0 THEN
                    # and the other prime factor is unique (e.g. not 3^3)    #
                    b count +:= 1;
                    last count[ i MOD 10 ] +:= 1;
                    IF b count =  26 828
                    OR b count = 100 000
                    OR b count = 200 000
                    OR b count = 300 000
                    OR b count = 400 000
                    THEN
                        print( ( "The ", whole( b count, -6 )
                               , "th Blum integer is ", whole( i, -11 )
                               , newline
                               )
                             )
                    FI
                FI
            FI
        FI
    OD;
    # show some statistics of the last digits                                #
    print( ( "For Blum integers up to ", whole( b count, 0 ), ":", newline ) );
    FOR i FROM LWB last count TO UPB last count DO
        IF last count[ i ] /= 0 THEN
            print( ( "    ", fixed( ( last count[ i ] * 100 ) / b count, -8, 3 )
                   , "% end with ", whole( i, 0 )
                   , newline
                   )
                 )
        FI
    OD

END
