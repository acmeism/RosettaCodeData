BEGIN # show the minimum prime >= the maximum elements of three lists #
    PR read "primes.incl.a68" PR
    []INT numbers1 = (  5, 45, 23, 21, 67 );
    []INT numbers2 = ( 43, 22, 78, 46, 38 );
    []INT numbers3 = (  9, 98, 12, 54, 53 );
    [ 1 : UPB numbers1 ]INT prime list;
    INT max element := numbers1[ 1 ];
    FOR i TO UPB numbers1 DO
        INT m := numbers1[ i ];
        IF numbers2[ i ] > m THEN m := numbers2[ i ] FI;
        IF numbers3[ i ] > m THEN m := numbers3[ i ] FI;
        IF m > max element THEN max element := m FI;
        prime list[ i ] := m
    OD;
    # construct a sieve of primes big enough for the maximum element #
    []BOOL prime = PRIMESIEVE ( max element * 2 );
    # replace the elements of prime list wih the smallest prime >= the element #
    FOR i TO UPB prime list DO
        INT m := prime list[ i ];
        # find the next prime >= m #
        IF   m <= 2 THEN m := 2
        ELSE
            IF NOT ODD m THEN m +:= 1 FI;
            WHILE NOT prime[ m ] DO m +:= 2 OD
        FI;
        prime list[ i ] := m
    OD;
    print( ( "[" ) );
    FOR i TO UPB prime list DO print( ( " ", whole( prime list[ i ], 0 ) ) ) OD;
    print( ( " ]" ) )
END
