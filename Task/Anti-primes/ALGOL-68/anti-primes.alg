BEGIN # find some anti-primes: numbers with more divisors than the     #
      # previous numbers                                               #
    INT max number   := 10 000;
    INT max divisors := 0;
    # construct a table of the divisor counts                          #
    [ 1 : max number ]INT ndc; FOR i FROM 1 TO UPB ndc DO ndc[ i ] := 1 OD;
    FOR i FROM 2 TO UPB ndc DO
        FOR j FROM i BY i TO UPB ndc DO ndc[ j ] +:= 1 OD
    OD;
    # show the numbers with more divisors than their predecessors      #
    INT a count := 0;
    FOR i TO UPB ndc WHILE a count < 20 DO
        INT divisor count = ndc[ i ];
        IF divisor count > max divisors THEN
            print( ( " ", whole( i, 0 ) ) );
            max divisors := divisor count;
            a count     +:= 1
        FI
    OD;
    print( ( newline ) )
END
