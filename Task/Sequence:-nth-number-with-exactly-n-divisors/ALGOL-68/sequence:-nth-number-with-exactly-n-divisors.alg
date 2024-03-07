BEGIN
    INT max number = 500 000; # maximum number we will count the divisors of #
    # form a table of proper divisor counts                                  #
    [ 1 : max number ]INT pdc; FOR i TO UPB pdc DO pdc[ i ] := 1 OD;
    pdc[ 1 ] := 0;
    FOR i FROM 2 TO UPB pdc DO
        FOR j FROM i + i BY i TO UPB pdc DO pdc[ j ] +:= 1 OD
    OD;
    # find the first few primes                                              #
    [ 1 : 30 ]INT prime;
    INT p count := 0;
    FOR i WHILE p count < UPB prime DO
        IF pdc[ i ] = 1 THEN prime[ p count +:= 1 ] := i FI
    OD;
    # show the nth number with n divisors                                    #
    INT w = -43;  # width to print the numbers (negative means no leading +) #
    print( ( " 1: ", whole( 1, w ), " | 1", newline ) );
    FOR i FROM 2 TO 23 DO
        print( ( whole( i, -2 ), ": " ) );
        IF pdc( i ) = 1 THEN
            print( ( whole( LENG LENG prime[ i ] ^ ( i - 1 ), w ), newline ) )
        ELSE
            INT c := 0;
            FOR j TO UPB pdc WHILE c < i DO
                IF pdc[ j ] = i - 1 THEN
                    c +:= 1;
                    IF c = i THEN
                        print( ( whole( j, w ), " | 1" ) );
                        FOR d FROM 2 TO j OVER 2 DO
                            IF j MOD d = 0 THEN print( ( " ", whole( d, 0 ) ) ) FI
                        OD;
                        print( ( " ", whole( j, 0 ), newline ) )
                    FI
                FI
            OD
        FI
    OD

END
