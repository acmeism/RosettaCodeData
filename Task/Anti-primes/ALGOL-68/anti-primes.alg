BEGIN # find some anti-primes: numbers with more divisors than the     #
      # previous numbers                                               #
    HEAP[ 1 : 0 ]INT empty list;
    REF[]INT ndc     := empty list;       # table of divisor counts    #
    INT max divisors := 0;
    INT a count      := 0;
    FOR n WHILE a count < 20 DO
        IF n > UPB ndc THEN
            # need a bigger table of divisor counts                    #
            ndc := HEAP[ 1 : UPB ndc + 5 000 ]INT;
            FOR i FROM 1 TO UPB ndc DO ndc[ i ] := 1 OD;
            FOR i FROM 2 TO UPB ndc DO
                FOR j FROM i BY i TO UPB ndc DO ndc[ j ] +:= 1 OD
            OD
        FI;
        IF ndc[ n ] > max divisors THEN
            print( ( " ", whole( n, 0 ) ) );
            max divisors := ndc[ n ];
            a count     +:= 1
        FI
    OD;
    print( ( newline ) )
END
