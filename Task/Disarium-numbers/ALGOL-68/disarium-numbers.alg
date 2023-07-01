BEGIN # find some Disarium numbers - numbers whose digit position-power sums  #
      # are equal to the number, e.g. 135 = 1^1 + 3^2 + 5^3                   #
    # compute the nth powers of 0-9                                           #
    [ 1 : 9, 0 : 9 ]INT power;
    FOR d FROM 0 TO 9 DO power[ 1, d ] := d OD;
    FOR n FROM 2 TO 9 DO
        power[ n, 0 ] := 0;
        FOR d TO 9 DO
            power[ n, d ] := power[ n - 1, d ] * d
        OD
    OD;
    # print the first few Disarium numbers                                    #
    INT max disarium  = 19;
    INT count        :=  0;
    INT power of ten := 10;
    INT length       :=  1;
    FOR n FROM 0 WHILE count < max disarium DO
        IF n = power of ten THEN
            # the number of digits just increased                             #
            power of ten *:= 10;
            length       +:=  1
        FI;
        # form the digit power sum                                            #
        INT v   := n;
        INT dps := 0;
        FOR p FROM length BY -1 TO 1 DO
            dps +:= power[ p, v MOD 10 ];
            v OVERAB 10
        OD;
        IF dps = n THEN
            # n is Disarium                                                   #
            count +:= 1;
            print( ( " ", whole( n, 0 ) ) )
        FI
    OD
END
