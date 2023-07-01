BEGIN # count proper divisors using a sieve-like approach              #
    # find the first/only number in 1 : 20 000 and 1 : 64 000 000 with #
    # the most divisors                                                #
    INT max number            := 20 000;
    TO 2 DO
        INT max divisors      := 0;
        INT has max divisors  := 0;
        INT with max divisors := 0;
        [ 1 : max number ]INT pdc; pdc[ 1 ] := 0; FOR i FROM 2 TO UPB pdc DO pdc[ i ] := 1 OD;
        FOR i FROM 2 TO UPB pdc DO
            FOR j FROM i + i BY i TO UPB pdc DO pdc[ j ] +:= 1 OD
        OD;
        FOR d TO max number DO
            INT divisor count = pdc[ d ];
            IF divisor count > max divisors THEN
                # found a number with more divisors than the previous max  #
                max divisors       := divisor count;
                has max divisors   := d;
                with max divisors  := 1
            ELIF divisor count = max divisors THEN
                # found another number with that many divisors             #
                with max divisors +:= 1
            FI
        OD;
        print( ( whole( has max divisors, 0 )
               , " is the "
               , IF with max divisors < 2 THEN "only" ELSE "first" FI
               , " number upto "
               , whole( max number, 0 )
               , " with "
               , whole( max divisors, 0 )
               , " divisors"
               , newline
               )
             );
        max number := 64 000 000
    OD
END
