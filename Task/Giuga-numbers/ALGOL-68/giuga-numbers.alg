BEGIN # find some Giuga numbers, composites n such that all their distinct   #
      #                        prime factors f exactly divide ( n / f ) - 1  #

    # find the first four Giuga numbers                                      #
    # each prime factor must appear only once, e.g.: for 2:                  #
    # [ ( n / 2 ) - 1 ] mod 2 = 0  => n / 2 is odd => n isn't divisible by 4 #
    # similarly for other primes                                             #
    INT g count := 0;
    FOR n FROM 2 BY 4 WHILE g count < 4 DO # assume the numbers are all even #
        INT  v        := n OVER 2;
        BOOL is giuga := TRUE;
        INT  f count  := 1;
        FOR f FROM 3 BY 2 WHILE f <= v AND is giuga DO
            IF v MOD f = 0 THEN
                # have a prime factor                                        #
                f count +:= 1;
                is giuga := ( ( n OVER f ) - 1 ) MOD f = 0;
                v OVERAB f
            FI
        OD;
        IF is giuga THEN
            # n is still a candidate, check it is not prime                  #
            IF f count > 1 THEN
                g count +:= 1;
                print( ( " ", whole( n, 0 ) ) )
            FI
        FI
    OD
END
