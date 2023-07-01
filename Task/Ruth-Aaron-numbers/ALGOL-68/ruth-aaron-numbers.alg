BEGIN # find Ruth-Aaron pairs - pairs of consecutive integers where the sum #
      # of the prime factors or divisors are equal                          #
    INT max number = 99 000 000; # max number we will consider #
    # construct a sieve of primes up to max number #
    [ 1 : max number ]BOOL prime;
    prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # construct the sums of prime divisors up to max number #
    [ 1 : max number ]INT ps; FOR n TO max number DO ps[ n ] := 0 OD;
    FOR n TO max number DO
        IF prime[ n ] THEN
            FOR j FROM n BY n TO max number DO ps[ j ] PLUSAB n OD
        FI
    OD;
    INT max count = 30;
    # first max count Ruth-Aaron (divisors) numbers #
    [ 1 : max count ]INT dra;
    INT count    := 0;
    INT prev sum := 0;
    FOR n FROM 2 WHILE count < max count DO
        INT this sum = ps[ n ];
        IF prev sum = this sum THEN
            # found another Ruth-Aaron number #
            count PLUSAB 1;
            IF count <= max count THEN dra[ count ] := n - 1 FI
        FI;
        prev sum := this sum
    OD;
    # first triple #
    INT dra3      := 0;
    INT pprev sum := ps[ 1 ];
    prev sum      := ps[ 2 ];
    FOR n FROM 3 WHILE dra3 = 0 DO
        INT this sum = ps[ n ];
        IF prev sum = this sum THEN
            IF pprev sum = this sum THEN
                # found a Ruth-Aaron triple #
                dra3 := n - 2
            FI
        FI;
        pprev sum := prev sum;
        prev sum  := this sum
    OD;
    # replace ps with the prime factor count #
    INT root max number = ENTIER sqrt( max number );
    FOR n FROM 2 TO root max number DO
        IF prime[ n ] THEN
            INT p := n * n;
            WHILE p < root max number DO
                FOR j FROM p BY p TO max number DO ps[ j ] PLUSAB n OD;
                p TIMESAB n
            OD
        FI
    OD;
    # first max count Ruth-Aaron (factors) numbers #
    [ 1 : max count ]INT fra;
    prev sum := ps[ 1 ];
    count    := 0;
    FOR n FROM 2 WHILE count < 30 DO
        INT this sum = ps[ n ];
        IF prev sum = this sum THEN
            # found another Ruth-Aaron number #
            count PLUSAB 1;
            fra[ count ] := n - 1
        FI;
        prev sum := this sum
    OD;
    # first triple #
    prev sum := 0;
    count    := 0;
    INT fra3 := 0;
    FOR n FROM 2 WHILE fra3 = 0 DO
        INT this sum = ps[ n ];
        IF prev sum = this sum AND pprev sum = this sum THEN
            # found a Ruth-Aaron triple #
            fra3 := n - 2
        FI;
        pprev sum := prev sum;
        prev sum  := this sum
    OD;
    # show the numbers #
    print( ( "The first ", whole( max count, 0 ), " Ruth-Aaron numbers (factors):", newline ) );
    FOR n TO max count DO
        print( ( whole( fra[ n ], - 6 ) ) );
        IF n MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    # divisors #
    print( ( "The first ", whole( max count, 0 ), " Ruth-Aaron numbers (divisors):", newline ) );
    FOR n TO max count DO
        print( ( whole( dra[ n ], - 6 ) ) );
        IF n MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    # triples #
    print( ( newline, "First Ruth-Aaron triple (factors):  ", whole( fra3, 0 ) ) );
    print( ( newline, "First Ruth-Aaron triple (divisors): ", whole( dra3, 0 ) ) )
END
