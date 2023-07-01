BEGIN # find some Erdos-Nicolas numbers: numbers equal to the sum of their    #
      # first k proper divisors but k is not the count of all their proper    #
      # divisors ( so the numbers aren't perfect )                            #
    INT max number  = 2 000 000;      # largest number we will consider       #
    # construct tables of the divisor counts and divisor sums and check for   #
    # the numbers as we do it - note they will not necessarily be found in    #
    #                                order                                    #
    [ 1 : max number ]INT dsum;   FOR i TO UPB dsum   DO dsum[   i ] := 1 OD;
    [ 1 : max number ]INT dcount; FOR i TO UPB dcount DO dcount[ i ] := 1 OD;
    FOR i FROM 2 TO UPB dsum
        DO FOR j FROM i + i BY i TO UPB dsum DO
            # have another proper divisor                                     #
            IF dsum[ j ] = j THEN
                # the divisor sum is currently equal to the number but is     #
                # about to increase, so we have an Erdos-Nicolas number       #
                print( ( whole( j, -10 ), " equals the sum of its first "
                       , whole( dcount[ j ], 0 ), " divisors"
                       , newline
                       )
                     )
            FI;
            dsum[   j ] +:= i;
            dcount[ j ] +:= 1
        OD
    OD
END
