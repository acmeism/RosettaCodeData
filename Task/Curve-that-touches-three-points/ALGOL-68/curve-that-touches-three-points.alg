BEGIN # draw a curve that passes through 3 points - translated from the Ada  #
      # sample - finds the centre and radius of a circle through the points  #

    REAL x1 = 10;                    # Point P1                              #
    REAL y1 = 10;

    REAL x2 = 100                    # Point P2                              #;
    REAL y2 = 200;

    REAL x3 = 200;                   # Point P3                              #
    REAL y3 =  10;

    REAL x4 = ( x1 + x2 ) / 2;       # Point P4 - midpoint between P1 and P2 #
    REAL y4 = ( y1 + y2 ) / 2;
    REAL s4 = ( y2 - y1 ) / ( x2 - x1 );                   # Slope P1-P2     #
    REAL a4 = -1 / s4;                                     # Slope P4-Centre #
    # Y4 = A4 * X4 + B4  <=>  B4 = Y4 - A4 * X4                              #
    REAL b4 = y4 - a4 * x4;

    REAL x5 = ( x2 + x3 ) / 2;       # Point P5 - midpoint between P2 and P3 #
    REAL y5 = ( y2 + y3 ) / 2;
    REAL s5 = ( y3 - y2 ) / ( x3 - x2 );                   # Slope P2-P3     #
    REAL a5 = -1.0 / s5;                                   # Slope P5-Centre #
    # Y5 = A5 * X5 + B5  <=>  B5 = Y5 - A5 * X5                              #
    REAL b5 = y5 - a5 * x5;

    # Find centre                                                            #
    # Y = A4 * X + B4     -- Line 1                                          #
    # Y = A5 * X + B5     -- Line 2                                          #
    # Solve for X:                                                           #
    # A4 * X + B4 = A5 * X + B5                                              #
    # A4 * X - A5 * X = B5 - B4                                              #
    # X * (A4 - A5) = B5 - B4                                                #
    # X = (B5 - B4) / (A4 - A5)                                              #
    REAL xc = ( b5 - b4 ) / ( a4 - a5 );
    REAL yc = a4 * xc + b4;
    # Radius                                                                 #
    REAL r = sqrt( ( x1 - xc ) ^ 2 + ( y1 - yc ) ^ 2 );

    print( ( "Centre : (", fixed( xc, -6, 1 ), ", ", fixed( yc, -6, 1 ), " )", newline ) );
    print( ( "Radius : ",  fixed( r, -6, 1 ), newline ) )

END
