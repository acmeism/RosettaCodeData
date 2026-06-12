BEGIN # find numbers divisible by their digits but not the product of their digits #
    INT max number    = 999;
    INT number count := 0;
    FOR n TO max number DO
        INT digit product        := 1;
        INT v                    := n;
        BOOL divisible by digits := n /= 0;
        WHILE v > 0 AND divisible by digits DO
            INT digit = v MOD 10;
            divisible by digits := IF digit = 0
                                   THEN FALSE
                                   ELSE n MOD digit = 0
                                   FI;
            digit product *:= digit;
            v OVERAB 10
        OD;
        IF divisible by digits THEN
            IF n MOD digit product /= 0 THEN
                # have a number divisible by its digits but not the product of the digits #
                print( ( " ", whole( n, -3 ) ) );
                IF ( number count +:= 1 ) MOD 15 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD
END
