BEGIN # find the centre and radius of a circle through 3 points                                     #
      # follows the lines of the C++ code at                                                        #
      # https://www.geeksforgeeks.org/equation-of-circle-when-three-points-on-the-circle-are-given/ #

    MODE POINT  = STRUCT( REAL x, y );
    MODE CIRCLE = STRUCT( POINT centre, REAL radius );

    # returns the circle that passes through p1, p2 and p3                                          #
    PROC find circle = ( POINT p1, p2, p3 )CIRCLE:
         BEGIN
            REAL x1 = x OF p1, y1 = y OF p1, x2 = x OF p2, y2 = y OF p2, x3 = x OF p3, y3 = y OF p3;
            REAL x12  = x1 - x2
               , x13  = x1 - x3
               , y12  = y1 - y2
               , y13  = y1 - y3
               , y31  = y3 - y1
               , y21  = y2 - y1
               , x31  = x3 - x1
               , x21  = x2 - x1
               ;
            REAL sx13 = x1^2 - x3^2
               , sy13 = y1^2 - y3^2
               , sx21 = x2^2 - x1^2
               , sy21 = y2^2 - y1^2
               ;
            REAL f = ( ( ( sx13 + sy13 ) * x12 )
                     + ( ( sx21 + sy21 ) * x13 )
                     )
                   / ( 2 * ( ( y31 * x12 ) - ( y21 * x13 ) ) )
               , g = ( ( ( sx13 + sy13 ) * y12 )
                     + ( ( sx21 + sy21 ) * y13 )
                     )
                   / ( 2 * ( ( x31 * y12 ) - ( x21 * y13 ) ) )
               ;
             REAL c = - (x1^2) - (y1^2) - ( 2 * g * x1 ) - ( 2 * f * y1 );

            ( ( -g, -f ), sqrt( g^2 + f^2 - c ) )
         END # find circle # ;

    BEGIN # test                                                                                    #
        CIRCLE c = find circle( ( 22.83, 2.07 ), ( 14.39, 30.24 ), ( 33.65, 17.31 ) );
        print( ( "Centre = ( ",   fixed( x OF centre OF c, -10, 6 ) ) );
        print( ( ", ",            fixed( y OF centre OF c, -10, 6 ) ) );
        print( ( " ), Radius = ", fixed(      radius OF c, -10, 6 ), newline ) )
    END
END
