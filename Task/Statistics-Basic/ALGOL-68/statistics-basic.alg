BEGIN # calculate the mean and standard deviation of some data and draw a    #
      # histogram of the data                                                #

    # return the mean of data                                                #
    OP   MEAN = ( []REAL data )REAL:
         IF INT len = ( UPB data - LWB data ) + 1;
            len < 1
         THEN 0
         ELSE REAL sum := 0;
              FOR i FROM LWB data TO UPB data DO
                  sum +:= data[ i ]
              OD;
              sum / len
         FI # MEAN # ;

    # returns the standard deviation of data                                 #
    OP  STDDEV = ( []REAL data )REAL:
         IF INT len = ( UPB data - LWB data ) + 1;
            len < 1
         THEN 0
         ELSE REAL m    = MEAN data;
              REAL sum := 0;
              FOR i FROM LWB data TO UPB data DO
                  sum +:= ( data[ i ] - m ) ^ 2
              OD;
              sqrt( sum / len )
         FI # STDDEV # ;

    # generates a row of n random numbers in the range [0..1)                #
    PROC random row = ( INT n )REF[]REAL:
         BEGIN
            REF[]REAL data = HEAP[ 1 : n ]REAL;
            FOR i TO n DO
                data[ i ] := next random
            OD;
            data
         END # random row # ;

    # returns s right-padded with spaces to at least w characters            #
    PROC right pad = ( STRING s, INT w )STRING:
        IF INT len = ( UPB s - LWB s ) + 1; len >= w THEN s ELSE s + ( " " * ( w - len ) ) FI;

    # prints a histogram of data ( assumed to be in [0..1) ) with n bars     #
    #        scaled to fit in h scale characters                             #
    PROC print histogram = ( []REAL data, INT n, h scale )VOID:
         IF n > 0 AND h scale > 0 THEN
            [ 0 : n - 1 ]INT count;
            FOR i FROM LWB count TO UPB count DO count[ i ] := 0 OD;
            FOR i FROM LWB data TO UPB data DO
                count[ ENTIER ( data[ i ] * n ) ] +:= 1
            OD;
            INT max count := 0;
            FOR i FROM LWB count TO UPB count DO
                IF count[ i ] > max count THEN max count := count[ i ] FI
            OD;
            REAL v     := 0;
            REAL scale  = max count / h scale;
            FOR i FROM LWB count TO UPB count DO
                print( ( fixed( v, -4, 2 ), ": " ) );
                print( ( right pad( "=" * ROUND ( count[ i ] / scale ), h scale ) ) );
                print( ( "   (", whole( count[ i ], 0 ), ")", newline ) );
                v +:= 1 / n
            OD
         FI # print histogram # ;

    # task                                                                   #

    # generate n random data items, calculate the mean and stddev and show   #
    # a histogram of the data                                                #
    PROC show statistics = ( INT n )VOID:
         BEGIN
            []REAL data = random row( n );
            print( ( "Sample size: ", whole( n, -6 ) ) );
            print( ( ", mean: ",   fixed(   MEAN data, -8, 4 ) ) );
            print( ( ", stddev: ", fixed( STDDEV data, -8, 4 ) ) );
            print( ( newline ) );
            print histogram( data, 10, 32 );
            print( ( newline ) )
         END # show statistics # ;

    show statistics(     100 );
    show statistics(   1 000 );
    show statistics(  10 000 );
    show statistics( 100 000 )

END
