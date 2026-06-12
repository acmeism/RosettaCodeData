BEGIN # Color Difference CIE ΔE2000 #

CO  # the latest ALGOL 68 Genie has hypot and atan2, uncomment these procedures   #
    # if your implementation of Algol 68 doesnt have them                         #
    PROC hypot = ( REAL a, b )REAL: sqrt( a * a + b * b );
    PROC atan2 = ( REAL b, c )REAL: # simulate atan2 - as in FreeBASIC            #
         IF   0 < c THEN atan( b / c )
         ELIF c < 0 THEN REAL h = atan( b / c ) + pi * SIGN b;
                         IF b = 0 THEN h + pi ELSE h FI
         ELSE            pi * 0.5 * SIGN b
         FI # atan2 # ;
CO

    # The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, #
    # and returns their difference.                                               #
    PROC ciede2000 = ( REAL l1, a1, b1, l2, a2, b2 )REAL:
    BEGIN
        # Michel Leonard uses Kotlin with the CIEDE2000 color-difference formula. #
        # kl, kc, kh are parametric factors to be adjusted according to           #
        # different viewing parameters such as textures, backgrounds...           #
        REAL kl = 1.0;
        REAL kc = 1.0;
        REAL kh = 1.0;
        REAL n := ( hypot( a1, b1 ) + hypot( a2, b2 ) ) * 0.5;
        n := n * n * n * n * n * n * n;
        # GitHub Project :                                                        #
        # https://github.com/michel-leonard/ciede2000-color-matching              #
        n := 1.0 + 0.5 * ( 1.0 - sqrt( n / ( n + 6103515625.0 ) ) );
        # hypot calculates the Euclidean distance while avoiding                  #
        # overflow/underflow. A naive version is supplied above, if required      #
        REAL c1  = hypot( a1 * n, b1 );
        REAL c2  = hypot( a2 * n, b2 );
        # atan2 is preferred over atan because it accurately computes the angle   #
        # of a point (x, y) in all quadrants, handling the signs of both          #
        # coordinates. A version is supplied above, if required                   #
        REAL h1 := atan2( b1, a1 * n );
        REAL h2 := atan2( b2, a2 * n );
        IF h1 < 0.0 THEN
            h1 +:= 2.0 * pi
        FI;
        IF h2 < 0.0 THEN
            h2 +:= 2.0 * pi
        FI;
        n := ABS( h2 - h1 );
        # Cross-implementation consistent rounding.                               #
        IF pi - 1e-14 < n AND n < pi + 1e-14 THEN
            n := pi
        FI;
        # When the hue angles lie in different quadrants, the straightforward     #
        # average can produce a mean that incorrectly suggests a hue angle in     #
        # the wrong quadrant, the next lines handle this issue.                   #
        REAL hm := ( h1 + h2 ) * 0.5;
        REAL hd := ( h2 - h1 ) * 0.5;
        IF pi < n THEN
            IF 0.0 < hd THEN
                hd -:= pi
            ELSE
                hd +:= pi;
                hm +:= pi
	    FI
        FI;
        REAL p = 36.0 * hm - 55.0 * pi;
        n := ( c1 + c2 ) * 0.5;
        n := n * n * n * n * n * n * n;
        # The hue rotation correction term is designed to account for the         #
        # non-linear behavior of hue differences in the blue region.              #
        REAL rt = -2.0 * sqrt( n / ( n + 6103515625.0 ) )
                        * sin( pi / 3.0 * exp( ( p * p ) / ( -25.0 * pi * pi ) ) );
        n := ( l1 + l2 ) * 0.5;
        n := ( n - 50.0 ) * ( n - 50.0 );
        # Lightness.                                                              #
        REAL l = ( l2 - l1 ) / ( kl * ( 1.0 + 0.015 * n / sqrt( 20.0 + n ) ) );
        # These coefficients adjust the impact of different harmonic              #
        # components on the hue difference calculation.                           #
        REAL t = 1.0 + 0.24 * sin( 2.0 * hm + pi * 0.5 )
                     + 0.32 * sin( 3.0 * hm + 8.0 * pi / 15.0 )
                     - 0.17 * sin( hm + pi / 3.0 )
                     - 0.20 * sin( 4.0 * hm + 3.0 * pi / 20.0 );
        n := c1 + c2;
        # Hue.                                                                    #
        REAL h = 2.0 * sqrt( c1 * c2 ) * sin( hd ) / ( kh * ( 1.0 + 0.0075 * n * t ) );
        # Chroma.                                                                 #
        REAL c = ( c2 - c1 ) / ( kc * ( 1.0 + 0.0225 * n ) );
        # Returning the square root ensures that the result represents            #
        # the "true" geometric distance in the color space.                       #
        sqrt( l * l + h * h + c * c + c * h * rt )
    END # ciede2000 # ;

    BEGIN # test cases                                                            #
        [,]REAL tests = ( ( 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 )
                        , ( 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 )
                        , ( 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 )
                        , ( 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 )
                        , ( 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 )
                        , ( 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 )
                        , ( 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 )
                        , ( 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 )
                        , ( 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 )
                        , ( 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 )
                        , ( 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 )
                        , ( 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 )
                        , ( 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 )
                        , ( 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 )
                        , ( 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 )
                        );

        print( ( "   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000", newline ) );
        print( ( "------------------------------------------------------------",    newline ) );
        PROC f61 = ( REAL v )STRING: fixed( v, -6, 1 );
        FOR i FROM 1 LWB tests TO 1 UPB tests DO
            []REAL t = tests[ i, : ];
            print( ( f61( t[ 1 ] ), "   ", f61( t[ 2 ] ), "  ", f61( t[ 3 ] ) ) );
            print( (                  " ", f61( t[ 4 ] ),  " ", f61( t[ 5 ] ) ) );
            print( (                 "  ", f61( t[ 6 ] ),  " "                ) );
            print( ( fixed( ciede2000( t[ 1 ], t[ 2 ], t[ 3 ], t[ 4 ], t[ 5 ], t[ 6 ] ), -14, 10 ) ) );
            print( ( newline ) )
        OD
    END
END
