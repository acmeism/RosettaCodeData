BEGIN # find some numbers which are the cube roots of the product of their   #
      #      proper divisors                                                 #
      # the Online Encyclopedia of Integer Sequences states that these       #
      # numbers are 1 and those with eight divisors                          #
      # NB: numbers with 8 divisors have 7 proper divisors                   #
    INT max number = 500 000; # maximum number we will consider              #
    # form a table of proper divisor counts - assume the pdc of 1 is 7       #
    [ 1 : max number ]INT pdc; FOR i TO UPB pdc DO pdc[ i ] := 1 OD;
    pdc[ 1 ] := 7;
    FOR i FROM 2 TO UPB pdc DO
        FOR j FROM i + i BY i TO UPB pdc DO pdc[ j ] +:= 1 OD
    OD;
    # show the numbers which are the cube root of their proper divisor       #
    # product - equivalent to finding the numbers with a proper divisor      #
    # count of 7 ( we have "cheated" and set the pdc of 1 to 7 )             #
    INT next show := 500;
    INT c count   := 0;
    FOR n TO UPB pdc DO
        IF pdc[ n ] = 7 THEN
            # found a suitable number                                        #
            IF ( c count +:= 1 ) <= 50 THEN
                print( ( " ", whole( n, -3 ) ) );
                IF c count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF c count = next show THEN
                print( ( whole( c count, -9 ), "th: ", whole( n, 0 ), newline ) );
                next show *:= 10
            FI
        FI
    OD
END
