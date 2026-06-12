BEGIN # find some Dividuus Numbers: numbers divisible by their digit sum, digit product, #
      # digital root and multiplicative root                                             #

    OP   ISDIVIDUUS = ( INT n )BOOL:
         BEGIN
            INT abs n = ABS n;
            INT v := abs n, sum := 0, product := 1;
            WHILE v > 0 AND product > 0 DO
                INT d = v MOD 10;
                v    OVERAB 10;
                sum     +:= d;
                product *:= d
            OD;
            BOOL dividuus := sum /= 0 AND product /= 0;
            IF dividuus THEN
                dividuus := abs n MOD sum = 0 AND abs n MOD product = 0
            FI;
            IF dividuus THEN
                INT mr := product;
                WHILE mr > 9 DO
                    INT x := mr;
                    mr    := 1;
                    WHILE x > 0 AND mr > 0 DO
                        mr   *:= x MOD 10;
                        x OVERAB 10
                    OD
                OD;
                IF dividuus := mr /= 0 THEN dividuus := abs n MOD mr = 0 FI
            FI;
            IF dividuus THEN
                INT dr := sum;
                WHILE dr > 9 DO
                    INT x := dr;
                    dr    := 0;
                    WHILE x > 0 DO
                        dr   +:= x MOD 10;
                        x OVERAB 10
                    OD
                OD;
                IF dividuus := dr /= 0 THEN dividuus := abs n MOD dr = 0 FI
            FI;
            dividuus
         END # ISDIVIDUUS # ;

    BEGIN # task #
        print( ( "First 50 Dividuus Numbers:", newline ) );
        INT d count := 0;
        FOR n WHILE d count < 50 DO
            IF ISDIVIDUUS n THEN
                print( ( whole( n, -6 ) ) );
                IF ( d count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        OD;
        INT lo = 990 000 000, hi = 1 000 000 000;
        print( ( newline, "Dividuus Numbers between ", whole( lo, 0 ), " and ", whole( hi, 0 ), ": " ) );
        FOR n FROM lo TO hi DO
            IF ISDIVIDUUS n THEN print( ( whole( n, -12 ) ) ) FI
        OD;
        print( ( newline ) )
    END
END
