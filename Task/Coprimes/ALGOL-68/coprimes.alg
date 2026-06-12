BEGIN # test the coprime-ness of some number pairs #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
         END # gcd # ;
    # pairs numbers to test #
    [,]INT pq = ( ( 21, 15 ), ( 17, 23 ), ( 36, 12 ), ( 18, 29 ), ( 60, 15 ) );
    INT p pos = 2 LWB pq;
    INT q pos = 2 UPB pq;
    # test the pairs #
    FOR i FROM LWB pq TO UPB pq DO
        IF gcd( pq[ i, p pos ], pq[ i, q pos ] ) = 1 THEN
            # have a coprime pair #
            print( ( whole( pq[ i, p pos ], 0 ), " ", whole( pq[ i, q pos ], 0 ), newline ) )
        FI
    OD
END
