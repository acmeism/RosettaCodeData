BEGIN # find the product of the of the Pythagorian triplet a, b, c where:    #
      #                            a + b + c = 1000, a2 + b2 = c2, a < b < c #
    INT  perimeter      = 1000;
    INT  half perimeter = perimeter OVER 2;
    INT  max factor    := half perimeter;
    INT  count         := 0;
    FOR m WHILE m < max factor DO
        count +:= 1;
        # using Euclid's formula:                                            #
        # a = m^2 - n^2, b = 2mn, c = m^2 + n^2 for some integer m, n, so    #
        # a + b + c = m^2 - n^2 + 2mn + m^2 + n^2 = 2m( m + n )              #
        # so m and ( m + n ) are factors of half the perimeter               #
        IF half perimeter MOD m = 0 THEN
            # have a factor of half the perimiter                            #
            INT other factor = half perimeter OVER m;
            INT n            = other factor - m;
            INT m2 = m * m, n2 = n * n;
            INT a := IF m > n THEN m2 - n2 ELSE n2 - m2 FI;
            INT b := 2 * m * n;
            INT c  = m2 + n2;
            IF ( a + b + c ) = perimeter THEN
                # have found the required triple                             #
                IF b < a THEN INT t = a; a := b; b := t FI;
                print( ( "a = ", whole( a, 0 ), ", b = ", whole( b, 0 ), ", c = ", whole( c, 0 ) ) );
                print( ( "; a * b * c = ", whole( a * b * c, 0 ), newline ) )
            FI;
            max factor := other factor
        FI
    OD;
    print( ( whole( count, 0 ), " iterations", newline ) )
END
