BEGIN # Pollard's rho algorithm                                              #

    PR read "primes.incl.a68" PR

    # select a suitable size INT mode for the number of digits required      #
    MODE INTEGER = LONG INT;

    PROC gcd = ( INTEGER x, y )INTEGER:                      # iterative gcd #
         BEGIN
            INTEGER a := x, b := y;
            WHILE b /= 0 DO
               INTEGER next a = b;
               b := a MOD b;
               a := next a
            OD;
            ABS a
         END # gcd # ;

    # returns a prime factor (if possible) of n via Pollard's rho algorithm  #
    PROC pollard rho = ( INTEGER n )INTEGER:
         IF   n < 0
         THEN pollard rho( - n )
         ELIF n < 2
         THEN n
         ELIF NOT ODD n
         THEN 2
         ELSE
            INTEGER d                  := 1;
            INT     number of attempts := 1;
            BOOL    square or prime    := FALSE;
            PROC g = ( INTEGER gx )INTEGER: SHORTEN ( ( ( LENG gx * LENG gx ) + number of attempts ) MOD n );
            WHILE
                INTEGER x := 2, y := 2;
                d := 1;
                WHILE d = 1 DO
                    x := g( x );
                    y := g( g( y ) );
                    d := gcd( ABS( x - y ), n )
                OD;
                d = n AND number of attempts < 20 AND number of attempts < n
                      AND NOT square or prime
            DO
                IF ( number of attempts +:= 1 ) = 3 THEN
                    # second try failed - before we try again, check for a   #
                    # square or prime                                        #
                    LONG REAL root n = long sqrt( n );
                    IF ENTIER root n = root n THEN
                        # n is a square                                      #
                        square or prime := TRUE;
                        d := ENTIER root n
                    ELIF is probably prime( n ) THEN
                        # n is a prime                                       #
                        square or prime := TRUE
                    FI
                FI
            OD;
            d
         FI # pollard rho # ;

    BEGIN # test cases                                                       #
        []INTEGER test = ( 4, 13, 125, 4294967213, 9759463979, 34225158206557151, 763218146048580636353 );
        FOR test pos FROM LWB test TO UPB test DO
            INTEGER n  = test[ test pos ];
            INTEGER d1 = pollard rho( n );
            print( ( whole( n, -24 ), " = ", whole( d1, -12 ), " * ", whole( n OVER d1, 0 ), newline ) )
        OD;
        INT max prime check = 100 000;
        print( ( "Checking for primes up to ", whole( max prime check, 0 ), newline ) );
        FOR i TO max prime check DO
            IF pollard rho( i ) = i
            THEN # pollard's rho couldn't find a factor or i is prime        #
                IF NOT is probably prime( i )
                THEN print( ( " ?", whole( i, 0 ) ) )
                ELSE IF i < 100 THEN print( ( " ", whole( i, 0 ) ) ) FI
                FI
            FI
        OD;
        print( ( newline ) )
    END
END
