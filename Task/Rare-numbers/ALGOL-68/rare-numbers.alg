BEGIN # Rare numbers - translation of EasyLang with the MOD 1089/121 test from FreeBASIC #

    MODE RINT = LONG INT;    # 5 rare numbers needs more than 32 bits #

    PROC rev = ( RINT n )RINT:
         BEGIN
            RINT h := n, r := 0;
            WHILE h > 0 DO
                r := r * 10 + h MOD 10;
                h OVERAB 10
            OD;
            r
         END # rev # ;

    # returns the integer square root of x; x must be >= 0                   #
    PROC isqrt = ( RINT x )RINT:
         IF   x < 0 THEN print( ( "Negative number in isqrt", newline ) );stop
         ELIF x < 2 THEN x
         ELSE
            # x is greater than 1                                            #
            # find a power of 4 that's greater than x                        #
            RINT q := 1;
            WHILE q <= x DO q *:= 4 OD;
            # find the root                                                  #
            RINT z := x;
            RINT r := 0;
            WHILE q > 1 DO
                q OVERAB 4;
                RINT t = z - r - q;
                r OVERAB 2;
                IF t >= 0 THEN
                    z  := t;
                    r +:= q
                FI
            OD;
            r
         FI; # isqrt #

    PROC issqr = ( RINT n )BOOL:
         BEGIN
             RINT h = isqrt( n );
             h * h = n
         END # issqr # ;

    RINT po         := 1;
    BOOL odd digits := TRUE;
    RINT lim        := 1;
    RINT a          := 0;
    RINT count      := 0;
    RINT n          := 0;
    WHILE count < 5 DO
        n +:= 1;
        IF n = lim THEN
            a +:= 2;
            IF a = 10 THEN
                a          := 2;
                po        *:= 10;
                odd digits := NOT odd digits
            FI;
            n   := a * po;
            lim := n + po
        FI;
        RINT q = n MOD 10;
        IF a /= 2 OR q = 2 THEN
            IF a /= 4 OR q = 0 THEN
                IF a /= 6 OR q = 0 OR q = 5 THEN
                    RINT s9 = ( n MOD 9 * 2 ) MOD 9;
                    IF s9 <= 1 OR s9 = 4 OR s9 = 7 THEN
                        IF q /= 1 AND q /= 4 AND q /= 6 AND q /= 9 THEN
                            RINT h = a - q;
                            IF h <= 1 OR h >= 4 AND h <= 6 THEN
                                RINT nrev = rev( n );
                                IF n > nrev THEN
                                    RINT s = n + nrev, d = n - nrev;
                                    IF  IF   odd digits
                                        THEN d MOD 1089 = 0
                                        ELSE s MOD  121 = 0
                                        FI
                                    THEN
                                        IF issqr( s ) THEN
                                            IF issqr( d ) THEN
                                                print( ( " ", whole( n, 0 ) ) );
                                                count +:= 1
                                            FI
                                        FI
                                    FI
                                FI
                            FI
                        FI
                    FI
                FI
            FI
        FI
    OD
END
