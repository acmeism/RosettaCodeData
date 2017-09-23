BEGIN
    # Show the non-zero Bernoulli numbers B0 to B60                  #
    # as rational numbers                                            #
    # Uses code from the Arithmetic/Rational task modified to use    #
    # LONG LONG INT to allow for the large number of digits requried #

    PR precision 100 PR # sets the precision of LONG LONG INT        #

    # Code from the Arithmetic/Rational task                         #
    # ============================================================== #
    MODE FRAC = STRUCT( LONG LONG INT num #erator#,  den #ominator#);
    PROC gcd = (LONG LONG INT a, b) LONG LONG INT: # greatest common divisor #
       (a = 0 | b |: b = 0 | a |: ABS a > ABS b  | gcd(b, a MOD b) | gcd(a, b MOD a));
     PROC lcm = (LONG LONG INT a, b)LONG LONG INT: # least common multiple #
       a OVER gcd(a, b) * b;
     PRIO // = 9; # higher then the ** operator #
     OP // = (LONG LONG INT num, den)FRAC: ( # initialise and normalise #
       LONG LONG INT common = gcd(num, den);
       IF den < 0 THEN
         ( -num OVER common, -den OVER common)
       ELSE
         ( num OVER common, den OVER common)
       FI
     );
    OP + = (FRAC a, b)FRAC: (
       LONG LONG INT common = lcm(den OF a, den OF b);
       FRAC result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
       num OF result//den OF result
    );
    OP - = (FRAC a, b)FRAC: a + -b,
       * = (FRAC a, b)FRAC: (
           LONG LONG INT num = num OF a * num OF b,
           den = den OF a * den OF b;
           LONG LONG INT common = gcd(num, den);
           (num OVER common) // (den OVER common)
         );
    OP - = (FRAC frac)FRAC: (-num OF frac, den OF frac);
    # ============================================================== #
    # end code from the Arithmetic/Rational task                     #

    # Additional FRACrelated operators                               #
    OP *  = ( INT a, FRAC b )FRAC: ( num OF b * a ) // den OF b;
    OP // = ( INT a, INT  b )FRAC: LONG LONG INT( a ) // LONG LONG INT( b );

    # returns the nth Bernoulli number, n must be >= 0               #
    # Uses the algorithm suggested by the task, so B(1) is +1/2      #
    PROC bernoulli = ( INT n )FRAC:
         IF n < 0
         THEN # n is out of range # 0 // 1
         ELSE # n is valid        #
            [ 0 : n ]FRAC a;
            FOR i FROM LWB a TO UPB a DO a[ i ] := 0 // 1 OD;
            FOR m FROM 0 TO n DO
                a[ m ] := 1 // ( m + 1 );
                FOR j FROM m BY -1 TO 1 DO
                    a[ j - 1 ] := j * ( a[ j - 1 ] - a[ j ] )
                OD
            OD;
            a[ 0 ]
         FI # bernoulli # ;

    FOR n FROM 0 TO 60 DO
        FRAC bn := bernoulli( n );
        IF num OF bn /= 0 THEN
            # have a non-0 Bn #
            print( ( "B(", whole( n, -2 ), ") ", whole( num OF bn, -50 ), " / ", whole( den OF bn, 0 ), newline ) )
        FI
    OD
END
