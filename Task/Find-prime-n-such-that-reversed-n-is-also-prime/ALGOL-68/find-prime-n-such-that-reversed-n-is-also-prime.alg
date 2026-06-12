BEGIN # find primes whose reversed digits are also prime         #
    INT max number = 500;   # largest prime we will reverse      #
    INT max prime  = 1 000; # enough primes to handle reversing  #
                            # max number                         #
    [ 1 : max prime ]BOOL p; FOR n TO UPB p DO p[ n ] := ODD n OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB p ) DO
        IF p[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB p DO p[ s ] := FALSE OD
        FI
    OD;
    p[ 1 ] := FALSE; p[ 2 ] := TRUE;
    INT count := 0;
    FOR n TO max number DO
        IF p[ n ] THEN
            INT r := n MOD 10;
            INT v := n;
            WHILE ( v OVERAB 10 ) > 0 DO
                r *:= 10 +:= v MOD 10
            OD;
            IF p[ r ] THEN
                print( ( " ", whole( n, -3 ) ) );
                IF ( count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( count, 0 ) ) );
    print( ( " reversable primes up to ", whole( max number, 0 ), newline ) )
END
