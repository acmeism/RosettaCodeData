BEGIN # show some rows of Faulhaber's triangle                               #

    # utility operators                                                      #
    OP   LENGTH = ( STRING a )INT: ( UPB a - LWB a ) + 1;
    PRIO PAD    = 9;
    OP   PAD    = ( INT width, STRING v )STRING: # left blank pad v to width #
         IF LENGTH v >= width THEN v ELSE ( " " * ( width - LENGTH v ) ) + v FI;

    MODE INTEGER   = LONG LONG INT; # mode for FRAC numberator & denominator #
    OP   TOINTEGER = ( INT n )INTEGER: n;      # force widening n to INTEGER #

    # Code from the Arithmetic/Rational task                                 #

    MODE FRAC = STRUCT( INTEGER num #erator#,  den #ominator#);

    PROC gcd = (INTEGER a, b) INTEGER: # greatest common divisor #
       (a = 0 | b |: b = 0 | a |: ABS a > ABS b  | gcd(b, a MOD b) | gcd(a, b MOD a));

    PROC lcm = (INTEGER a, b)INTEGER: # least common multiple #
       a OVER gcd(a, b) * b;

    PRIO // = 9; # higher then the ** operator #
    OP // = (INTEGER num, den)FRAC: ( # initialise and normalise #
       INTEGER common = gcd(num, den);
       IF den < 0 THEN
         ( -num OVER common, -den OVER common)
       ELSE
         ( num OVER common, den OVER common)
       FI
     );

    OP + = (FRAC a, b)FRAC: (
       INTEGER common = lcm(den OF a, den OF b);
       FRAC result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
       num OF result//den OF result
    );

    OP - = (FRAC a, b)FRAC: a + -b,
       * = (FRAC a, b)FRAC: (
           INTEGER num = num OF a * num OF b,
           den = den OF a * den OF b;
           INTEGER common = gcd(num, den);
           (num OVER common) // (den OVER common)
         );

    OP - = (FRAC frac)FRAC: (-num OF frac, den OF frac);

    # end code from the Arithmetic/Rational task                             #

    # alternative // operator for standard size INT values                   #
    OP // = (INT num, den)FRAC: TOINTEGER num // TOINTEGER den;
    # returns a * b                                                          #
    OP *   = ( INT     a, FRAC b )FRAC: ( num OF b * a ) // den OF b;
    OP *   = ( INTEGER a, FRAC b )FRAC: ( num OF b * a ) // den OF b;
    # sets a to a + b and returns a                                          #
    OP +:= = ( REF FRAC a, FRAC b )FRAC: a := a + b;
    # sets a to - a and returns a                                            #
    OP -=: = ( REF FRAC a )FRAC: BEGIN num OF a := - num OF a; a END;

    # returns the nth Bernoulli number, n must be >= 0                       #
    OP   BERNOULLI = ( INT n )FRAC:
         IF n < 0
         THEN # n is out of range # 0 // 1
         ELSE # n is valid        #
            [ 0 : n ]FRAC a;
            FOR m FROM 0 TO n DO
                a[ m ] := 1 // ( m + 1 );
                FOR j FROM m BY -1 TO 1 DO
                    a[ j - 1 ] := j * ( a[ j - 1 ] - a[ j ] )
                OD
            OD;
            IF n = 1 THEN - a[ 0 ] ELSE a[ 0 ] FI
         FI # BERNOULLI # ;

    # returns n! / k!                                                        #
    PROC factorial over factorial = ( INT n, k )INTEGER:
        IF     k > n THEN 0
        ELIF   k = n THEN 1
        ELSE # k < n #
            INTEGER f := 1;
            FOR i FROM k + 1 TO n DO f *:= i OD;
            f
        FI # factorial over Factorial # ;

    # returns n!                                                             #
    PROC factorial = ( INT n )INTEGER:
         BEGIN
            INTEGER f := 1;
            FOR i FROM 2 TO n DO f *:= i OD;
            f
         END # factorial # ;

    # returns the binomial coefficient of (n k)                              #
    PROC binomial coefficient = ( INT n, k )INTEGER:
         IF n - k > k
         THEN factorial over factorial( n, n - k ) OVER factorial(   k   )
         ELSE factorial over factorial( n,   k   ) OVER factorial( n - k )
         FI # binomial coefficient # ;

    # returns a string representation of a                                   #
    OP   TOSTRING = ( FRAC a )STRING:
         whole( num OF a, 0 ) + IF den OF a = 1 THEN "" ELSE "/" + whole( den OF a, 0 ) FI;

    # returns the pth row of Faulhaber's triangle                            #
    OP   FAULHABER = ( INT p )[]FRAC:
         BEGIN
            FRAC q := -1 // ( p + 1 );
            [ 0 : p ]FRAC coeffs;
            FOR j FROM 0 TO p DO
                coeffs[ p - j ] := binomial coefficient( p + 1, j ) * BERNOULLI j * -=: q
            OD;
            coeffs
         END # faulhaber # ;

    FOR i FROM 0 TO 9 DO               # show the triabngle's first 10 rows #
        []FRAC frow =  FAULHABER i;
        FOR j FROM LWB frow TO UPB frow DO
            print( ( " ", 6 PAD TOSTRING frow[ j ] ) )
        OD;
        print( ( newline ) )
    OD;
    BEGIN # compute the sum of k^17 for k = 1 to 1000 using triangle row 18 #
        []FRAC  frow = FAULHABER 17;
        FRAC    sum := 0 // 1;
        INTEGER kn  := 1;
        FOR j FROM LWB frow TO UPB frow DO
            VOID( sum +:= ( kn *:= 1000 ) * frow[ j ] )
        OD;
        print( ( TOSTRING sum, newline ) )
    END
END
