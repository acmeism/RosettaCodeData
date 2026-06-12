BEGIN # find Apéry's constant: the sum of the positive cubes' reciprocals     #
      # (this is the value of the Riemann zeta function applied to 3)         #

    PR precision 1000 PR                    # set precision of LONG LONG REAL #

    # returns a string representation of z, truncated to 100 decimals         #
    PROC truncate100 = ( LONG LONG REAL z )STRING:
         BEGIN
             STRING result = fixed( z, 0, 101 );  # format with 101 decimals  #
             result[ : UPB result - 1 ]             # remove the final digit  #
         END # truncate100 # ;

    # methind 1 - sum the reciprocols of the cubes - 1000 terms from 1        #
    BEGIN
        LONG LONG REAL zeta3 := 0;
        FOR k TO 1000 DO
            LONG LONG INT llk = LENG LENG k;
            zeta3 +:= 1 / ( llk * llk * llk )
        OD;
        print( ( truncate100( zeta3 ), newline ) )
    END;

    # method 2 - Markov's alternative representaton, 158 terms from 1         #
    #     5/2 * sum [ (-1)^(k-1)( k!^2 / (2k!)k^2 ) ] from 1                  #
    BEGIN
        LONG LONG INT fk := 1, f2k := 1;
        LONG LONG REAL zeta3 := 0;
        FOR k TO 158 DO
            LONG LONG INT llk  = k;
            LONG LONG INT ll2k = llk * 2;
            fk  *:= llk;
            f2k *:= ( ll2k - 1 ) *:= ll2k;
            LONG LONG REAL this term = ( fk * fk ) / ( f2k * llk * llk * llk );
            IF ODD k THEN
                zeta3 +:= this term
            ELSE
                zeta3 -:= this term
            FI
        OD;
        zeta3 *:= 5 / 2;
        print( ( truncate100( zeta3 ), newline ) )
    END;

    # method 3 - Wedeniwski representation - 20 terms from 0                  #
    #    1/24 * sum [ (-1)^k (2k+1)!^3(2k)!^3(k!)^3                           #
    #               * ( 126392k^5 + 412708k^4 + 531578k^3                     #
    #                 + 336367k^2 + 104000k   + 12463                         #
    #                 ) / (3k+2)! (4k + 3)!^3                                 #
    #               ] from 0                                                  #
    BEGIN
        []INT w coefficients = ( 126392, 412708, 531578, 336367, 104000, 12463 );
        LONG LONG INT fk := 1, f2k := 1, f3k := 1, f4k := 1;
        # ensure the divisor is a LONG LONG INT so the LHS is calculated as a #
        # LONG LONG REAL value and not a REAL which is then widened           #
        LONG LONG REAL zeta3 := w coefficients[ UPB w coefficients ]
                             / LENG LENG ( 2 * 6 * 6 * 6 );
        FOR k TO 19 DO
            LONG LONG INT llk  = k;
            LONG LONG INT ll2k = llk  + llk;
            LONG LONG INT ll3k = ll2k + llk;
            LONG LONG INT ll4k = ll3k + llk;
            fk  *:= llk;
            f2k *:=                               ( ll2k - 1 ) * ll2k;
            f3k *:=                ( ll3k - 2 ) * ( ll3k - 1 ) * ll3k;
            f4k *:= ( ll4k - 3 ) * ( ll4k - 2 ) * ( ll4k - 1 ) * ll4k;
            LONG LONG INT f2k1  = f2k * ( ll2k + 1 );
            LONG LONG INT f3k2  = f3k * ( ll3k + 1 ) * ( ll3k + 2 );
            LONG LONG INT f4k3  = f4k * ( ll4k + 1 ) * ( ll4k + 2 ) * ( ll4k + 3 );
            LONG LONG REAL this term := 0;
            FOR c TO UPB w coefficients DO
                this term *:= llk +:= w coefficients[ c ]
            OD;
            LONG LONG INT fp = f2k1 * f2k * fk;
            this term *:= fp * fp * fp /:= f3k2 * f4k3 * f4k3 * f4k3;
            IF ODD k THEN
                zeta3 -:= this term
            ELSE
                zeta3 +:= this term
            FI
        OD;
        zeta3 /:= 24;
        print( ( truncate100( zeta3 ), newline ) )
    END

END
