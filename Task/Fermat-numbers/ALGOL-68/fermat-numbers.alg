BEGIN # find and factorise some Fermat numbers: F(n) = 2^(2^n) + 1            #

    PR read "primes.incl.a68" PR                    # include prime utilities #
    PR precision 256 PR                  # set the precision of LONG LONG INT #

    PROC gcd = ( LONG LONG INT x, y )LONG LONG INT:           # iterative gcd #
         BEGIN
            LONG LONG INT a := x, b := y;
            WHILE b /= 0 DO
               LONG LONG INT next a = b;
               b := a MOD b;
               a := next a
            OD;
            ABS a
         END # gcd # ;

    # returns a prime factor (if possible) of n, if n is prime, n is returned #
    PROC pollard rho = ( LONG LONG INT n )LONG LONG INT:
         IF   is probably prime( n )
         THEN n
         ELIF LONG LONG INT x := 2, y := 2, d := 1;
              PROC g = ( LONG LONG INT x )LONG LONG INT: ( ( x * x ) + 1 ) MOD n;
              WHILE d = 1 DO
                  x := g( x );
                  y := g( g( y ) );
                  d := gcd( ABS( x - y ), n )
              OD;
              d = n
         THEN print( ( "pollard rho found non probably prime n for: ", n, newline ) );
              n
         ELIF LONG LONG INT other d = n OVER d;
              d > other d
         THEN other d
         ELSE d
         FI # pollard rho # ;

    # returns the lowest prime factor of n, or n if n is prime                #
    PROC prime factor = ( LONG LONG INT n )LONG LONG INT:
         IF   LONG LONG INT d := pollard rho( n );
              d = n
         THEN d
         ELSE # check for a lower factor                                      #
              LONG LONG INT other d := n OVER d;
              LONG LONG INT d1      := pollard rho( other d );
              WHILE d1 < d DO
                  d       := d1;
                  other d := other d OVER d;
                  d1      := pollard rho( other d )
              OD;
              IF d1 < d THEN d1 ELSE d FI
         FI # prime factor # ;

    # task                                                                    #
    INT p2 := 1;
    FOR i FROM 0 TO 9 DO
        LONG LONG INT fn = 1 + ( LONG LONG 2 )^p2;
        print( ( "F(", whole( i, 0 ), "): ", whole( fn, 0 ) ) );
        IF i < 7 THEN
            print( ( ", " ) );
            LONG LONG INT pf = prime factor( fn );
            IF pf = fn THEN
                print( ( "prime" ) )
            ELSE
                print( ( whole( pf, 0 ), " x ", whole( fn OVER pf, 0 ) ) )
            FI
        FI;
        print( ( newline ) );
        p2 *:= 2
    OD

END
