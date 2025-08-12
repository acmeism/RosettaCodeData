BEGIN # calculate the mean of the proportions of 0 digits out of the total   #
      # digits in factorials - translated from the Phix sample via FreeBASIC #

    [ 1 : 999 ]INT zc;                      # zc[ n ] = number of zeros in n #
    FOR x TO 999 DO zc[ x ] := 0 OD;
    FOR x TO 9 DO
        zc[       x ] := 2;             # 00x #
        zc[  10 * x ] := 2;             # 0x0 #
        zc[ 100 * x ] := 2;             # x00 #
        FOR y FROM 10 BY 10 TO 90 DO
            zc[        y + x   ] := 1;  # 0yx #
            zc[ 10 *   y + x   ] := 1;  # y0x #
            zc[ 10 * ( y + x ) ] := 1   # yx0 #
        OD
    OD;

    INT  trail := 1, first := 0;
    REAL total := 0.0;
    [ 1 : 100 000 ]INT rfs; # reverse factorial in base 1000; allow for up to 300 000 digits #
    INT rfs len := 1;
    rfs[ rfs len ] := 1;

    FOR f FROM 2 TO 50 000 DO
        INT carry   := 0;
        INT j       := trail;
        INT d999;
        INT zeroes  := ( trail - 1 ) * 3;

        WHILE j <= rfs len OR carry > 0 DO
            IF j <= rfs len THEN carry +:= rfs[ j ] * f FI;

            d999 := carry MOD 1000;
            rfs[ j ] := d999;
            IF j > rfs len THEN
                rfs len := j
            FI;

            zeroes +:= IF d999 = 0 THEN 3 ELSE zc[ d999 ] FI;

            carry OVERAB 1000;
            j +:= 1
        OD;

        WHILE IF trail > rfs len THEN FALSE ELSE rfs[ trail ] = 0 FI DO
            trail +:= 1
        OD;

        # d999 := Quick correction for length and zeroes #
        d999 := rfs[ rfs len ];
        INT leading zeroes = IF d999 < 10 THEN 2 ELIF d999 < 100 THEN 1 ELSE 0 FI;
        IF leading zeroes > 0 THEN
            zeroes -:= leading zeroes
        FI;
        INT digits   = rfs len * 3 - leading zeroes;
        total      +:= zeroes / digits;
        REAL  ratio  = total / f;

        IF ratio >= 0.16 THEN
            first := 0
        ELIF first = 0 THEN
            first := f
        FI;

        IF f = 100 OR f = 1 000 OR f MOD 10 000 = 0 THEN
            print( ( "Mean proportion of zero digits in factorials to ", whole( f, -5 ) ) );
            print( ( " is ", fixed( ratio, -12, 10 ), ", factorial has ", whole( digits, 0 ) ) );
            print( ( " digits", newline ) )
        FI
    OD;

    print( ( newline, "The mean proportion dips permanently below 0.16 at ", whole( first, -5 ), newline ) )
END
