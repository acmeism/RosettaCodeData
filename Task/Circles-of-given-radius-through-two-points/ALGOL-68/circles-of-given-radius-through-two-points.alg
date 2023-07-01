# represents a point                                                 #
MODE POINT = STRUCT( REAL x, REAL y );
# returns TRUE if p1 is the same point as p2, FALSE otherwise        #
OP = = ( POINT p1, POINT p2 )BOOL: x OF p1 = x OF p2 AND y OF p1 = y OF p2;

# represents a circle with centre c and radius r                     #
MODE CIRCLE = STRUCT( POINT c, REAL r );
# returns the difference in x-coordinate of two points               #
PRIO XDIFF = 5;
OP   XDIFF = ( POINT p1, POINT p2 )REAL: x OF p1 - x OF p2;
# returns the difference in y-coordinate of two points               #
PRIO YDIFF = 5;
OP   YDIFF = ( POINT p1, POINT p2 )REAL: y OF p1 - y OF p2;
# returns the distance between two points                            #
OP   -     = ( POINT p1, POINT p2 )REAL:
     BEGIN
        REAL x diff   = p1 XDIFF p2;
        REAL y diff   = p1 YDIFF p2;
        sqrt( ( x diff * xdiff ) + ( y diff * y diff ) )
     END; # - #
# generate a human-readable version of the circle c                  #
OP TOSTRING = ( CIRCLE c )STRING:
       ( "radius:"
       + fixed(      r OF c, -8, 4 )
       + " @("
       + fixed( x OF c OF c, -8, 4 )
       + ", "
       + fixed( y OF c OF c, -8, 4 )
       + ")"
       );

# modes to represent the results of the circles procedure ...        #
# infinite number of circles                                         #
MODE INFINITECIRCLES = STRUCT( STRING t, REAL r );
# two possible circles                                               #
MODE TWOCIRCLES      = STRUCT( CIRCLE a, CIRCLE b );
# one possible circle results in a CIRCLE                            #
# no possible circles                                                #
MODE NOCIRCLES       = STRUCT( STRING reason, POINT p1, POINT p2, REAL r );
# mode returned by the circles procedure                             #
MODE POSSIBLECIRCLES = UNION( INFINITECIRCLES, TWOCIRCLES, CIRCLE, NOCIRCLES );

# returns the circles of radius r that can be drawn through          #
#         points p1 and p2                                           #
PROC circles = ( POINT p1, POINT p2, REAL r )POSSIBLECIRCLES:
     IF r < 0 THEN # negative radius - there are no circles          #
         NOCIRCLES( "negative radius", p1, p2, r )
     ELIF p1 = p2 THEN # coincident points                           #
         IF r = 0.0 THEN
             # only one circle of radius 0 is possible               #
             CIRCLE( p1, 0.0 )
         ELSE
             # an infinite number of circles can be drawn through    #
             # the point                                             #
             INFINITECIRCLES( "infinite", r )
         FI
     ELSE # two possible circles                                     #
         REAL distance = p1 - p2;
         IF   distance > 2 * r THEN
             # the points are too far apart                          #
             NOCIRCLES( "points too far apart", p1, p2, r )
         ELIF distance = 2 * r THEN
             # the points are on the diameter of the circle          #
             CIRCLE( POINT( x OF p1 + ( ( p2 XDIFF p1 ) / 2 )
                          , y OF p1 + ( ( p2 YDIFF p1 ) / 2 )
                          )
                   , r
                   )
         ELSE
             # it is possible to draw two circles through the points #
             REAL half x sum      = ( x OF p1 + x OF p2 ) / 2;
             REAL half y sum      = ( y OF p1 + y OF p2 ) / 2;
             REAL mirror distance = sqrt( ( r * r ) - ( ( distance * distance ) / 4 ) );
             REAL x mirror        = ( mirror distance * ( y OF p1 - y OF p2 ) ) / distance;
             REAL y mirror        = ( mirror distance * ( x OF p2 - x OF p1 ) ) / distance;
             TWOCIRCLES( CIRCLE( POINT( half x sum + y mirror, half y sum + x mirror ), r )
                       , CIRCLE( POINT( half x sum - y mirror, half y sum - x mirror ), r )
                       )
         FI
     FI; # circles #

# test the circles procedure with the examples from the task    #

PROC print circles = ( REAL x1, y1, x2, y2, r )VOID:
     BEGIN
        CASE circles( POINT( x1, y1 ), POINT( x2, y2 ), r )
          IN ( NOCIRCLES       n ): print( ( "No circles : ", reason OF n ) )
           , ( TWOCIRCLES      t ): print( ( "Two circles: "
                                           , TOSTRING a OF t
                                           , ", "
                                           , TOSTRING b OF t
                                           )
                                         )
           , ( CIRCLE          c ): print( ( "One circle : ", TOSTRING c ) )
           , ( INFINITECIRCLES i ): print( ( "Infinite circles" ) )
         OUT BEGIN
                 print( ( "Unexpected circles result", newline ) );
                 stop
             END
        ESAC;
        print( ( newline ) )
     END; # print circles #
print circles( 0.1234, 0.9876,    0.8765, 0.2345,    2.0 );
print circles( 0.0000, 2.0000,    0.0000, 0.0000,    1.0 );
print circles( 0.1234, 0.9876,    0.1234, 0.9876,    2.0 );
print circles( 0.1234, 0.9876,    0.8765, 0.2345,    0.5 );
print circles( 0.1234, 0.9876,    0.1234, 0.9876,    0.0 )
