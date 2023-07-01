BEGIN # determine whether a point is within a triangle or not #
    # tolerance for the accurate test #
    REAL eps         = 0.001;
    REAL eps squared = eps * eps;
    # mode to hold a point #
    MODE POINT = STRUCT( REAL x, y );
    # returns a readable representation of p #
    OP    TOSTRING = ( POINT p )STRING: "[" + fixed( x OF p, -8, 4 ) + "," + fixed( y OF p, -8, 4 ) + "]";
    # returns 1 if p is to the right of the line ( a, b ), -1 if it is to the left and 0 if it is on it #
    PROC side of line = ( POINT p, a, b )INT:
         SIGN ( ( ( x OF b - x OF a ) * ( y OF p - y OF a ) )
              - ( ( y OF b - y OF a ) * ( x OF p - x OF a ) )
              );
    # returns the minimum of a and b #
    PROC min = ( REAL a, b )REAL: IF a < b THEN a ELSE b FI;
    # returns the maximum of a and b #
    PROC max = ( REAL a, b )REAL: IF a > b THEN a ELSE b FI;
    # returns TRUE if p is within the bounding box of the triangle a, b, c, FALSE otherwise #
    PROC point inside bounding box of triangle = ( POINT p, a, b, c )BOOL:
         BEGIN
            REAL x min = min( x OF a, min( x OF b, x OF c ) );
            REAL y min = min( y OF a, min( y OF b, y OF c ) );
            REAL x max = max( x OF a, max( x OF b, x OF c ) );
            REAL y max = max( y OF a, max( y OF b, y OF c ) );
            x min <= x OF p AND x OF p <= x max AND y min <= y OF p AND y OF p <= y max
         END # point inside bounding box of triangle # ;
    # returns the squared distance between p and the line a, b #
    PROC distance square point to segment = ( POINT p, a, b )REAL:
         IF REAL a b square length = ( ( x OF b - x OF a ) ^ 2 ) + ( ( y OF b - y OF a ) ^ 2 );
            REAL dot product = ( ( ( x OF p - x OF a ) ^ 2 ) + ( ( y OF p - y OF a ) ^ 2 ) ) / a b square length;
            dot product < 0
         THEN ( ( x OF p - x OF a ) ^ 2 ) + ( ( y OF p - y OF a ) ^ 2 )
         ELIF dot product <= 1
         THEN ( ( x OF a - x OF p ) ^ 2 ) + ( ( y OF a - y OF p ) ^ 2 )
            - ( dot product * dot product * a b square length )
         ELSE ( ( x OF p - x OF b ) ^ 2 ) + ( ( y OF p - y OF b ) ^ 2 )
         FI # distance square point to segment # ;
    # returns TRUE if p is within the triangle defined by a, b and c, FALSE otherwise #
    PROC point inside triangle = ( POINT p, a, b, c )BOOL:
         IF NOT point inside bounding box of triangle( p, a, b, c )
         THEN FALSE
         ELIF INT side of ab = side of line( p, a, b );
              INT side of bc = side of line( p, b, c );
              side of ab /= side of bc
         THEN FALSE
         ELIF side of ab = side of line( p, c, a )
         THEN TRUE
         ELIF distance square point to segment( p, a, b ) <= eps squared
         THEN TRUE
         ELIF distance square point to segment( p, b, c ) <= eps squared
         THEN TRUE
         ELSE distance square point to segment( p, c, a ) <= eps squared
         FI # point inside triangle # ;
    # test the point inside triangle procedure #
    PROC test point = ( POINT p, a, b, c )VOID:
         print( ( TOSTRING p, " in ( ", TOSTRING a, ", ", TOSTRING b, ", ", TOSTRING c, ") -> "
                , IF point inside triangle( p, a, b, c ) THEN "true" ELSE "false" FI
                , newline
                )
              );
    # test cases as in Commpn Lisp #
    test point( ( 0, 0 ), ( 1.5, 2.4 ), ( 5.1, -3.1 ), ( -3.8, 1.2 ) );
    test point( ( 0, 1 ), ( 1.5, 2.4 ), ( 5.1, -3.1 ), ( -3.8, 1.2 ) );
    test point( ( 3, 1 ), ( 1.5, 2.4 ), ( 5.1, -3.1 ), ( -3.8, 1.2 ) );
    test point( ( 5.414286, 14.349206 ), ( 0.1, 0.111111 ), ( 12.5, 33.333333 ), (  25.0, 11.111111 ) );
    test point( ( 5.414286, 14.349206 ), ( 0.1, 0.111111 ), ( 12.5, 33.333333 ), ( -12.5, 16.666667 ) );
    # additional Wren test cases #
    test point( ( 5.4142857142857, 14.349206349206 )
              , ( 0.1, 0.11111111111111 ), ( 12.5, 33.333333333333 ), ( 25, 11.111111111111 )
              );
    test point( ( 5.4142857142857, 14.349206349206 )
              , ( 0.1, 0.11111111111111 ), ( 12.5, 33.333333333333 ), ( -12.5, 16.666666666667 )
              )
END
