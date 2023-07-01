BEGIN # find arithmetic numbers - numbers whose average divisor is an integer #
      # i.e. sum of divisors MOD count of divisors = 0                        #
    INT max number            = 500 000;    # maximum number we will consider #
    [ 1 : max number ]INT d sum;
    [ 1 : max number ]INT d count;
    # all positive integers are divisible by 1 and so have at least 1 divisor #
    FOR i TO max number DO d sum[ i ] := d count[ i ] := 1 OD;
    # construct the divisor sums and counts                                   #
    FOR i FROM 2 TO max number DO
        FOR j FROM i BY i TO max number DO
            d count[ j ] +:= 1;
            d sum[   j ] +:= i
        OD
    OD;
    # count arithmetic numbers, and show the first 100, the 1 000th, 10 000th #
    # and the 100 000th and show how many are composite                       #
    INT max arithmetic = 100 000;
    INT a count       := 0;
    INT c count       := 0;
    FOR i TO max number WHILE a count < max arithmetic DO
        IF d sum[ i ] MOD d count[ i ] = 0 THEN
            # have an arithmetic number                                       #
            IF d count[ i ] > 2 THEN
                # the number is composite                                     #
                c count +:= 1
            FI;
            a count +:= 1;
            IF a count <= 100 THEN
                print( ( " ", whole( i, -3 ) ) );
                IF a count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF a count =   1 000
              OR a count =  10 000
              OR a count = 100 000
            THEN
                print( ( newline ) );
                print( ( "The ", whole( a count, 0 )
                       , "th arithmetic number is: ", whole( i, 0 )
                       , newline
                       )
                     );
                print( ( "    There are ", whole( c count, 0 )
                       , " composite arithmetic numbers up to ", whole( i, 0 )
                       , newline
                       )
                     )
            FI
        FI
    OD
END
