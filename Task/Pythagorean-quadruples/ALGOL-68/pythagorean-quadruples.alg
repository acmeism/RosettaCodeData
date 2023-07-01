BEGIN
    # find values of d where d^2 =/= a^2 + b^2 + c^2 for any integers a, b, c #
    # where d in [1..2200], a, b, c =/= 0                                     #
    # max number to check #
    INT max number = 2200;
    INT max square = max number * max number;
    # table of numbers that can be the sum of two squares #
    [ 1 : max square ]BOOL sum of two squares; FOR n TO max square DO sum of two squares[ n ] := FALSE OD;
    FOR a TO max number DO
        INT a2 = a * a;
        FOR b FROM a TO max number WHILE INT sum2 = ( b * b ) + a2;
                                         sum2 <= max square DO
            sum of two squares[ sum2 ] := TRUE
        OD
    OD;
    # now find d such that d^2 - c^2 is in sum of two squares #
    [ 1 : max number ]BOOL solution; FOR n TO max number DO solution[ n ] := FALSE OD;
    FOR d TO max number DO
        INT d2 = d * d;
        FOR c TO d - 1 WHILE NOT solution[ d ] DO
            INT diff2 = d2 - ( c * c );
            IF sum of two squares[ diff2 ] THEN
                solution[ d ] := TRUE
            FI
        OD
    OD;
    # print the numbers whose squares are not the sum of three squares #
    FOR d TO max number DO
        IF NOT solution[ d ] THEN
            print( ( " ", whole( d, 0 ) ) )
        FI
    OD;
    print( ( newline ) )
END
