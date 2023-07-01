BEGIN # Steffenses's method - translated from the ATS sample #

    MODE OPTIONALREAL = UNION( VOID, REAL );

    # Aitken's extrapolation #
    PROC aitken = ( PROC(REAL)REAL f   # function double to double #
                  , REAL           p0  # initial fixed point estimate #
                  ) REAL:
         BEGIN
            REAL p1   = f( p0 );
            REAL p2   = f( p1 );
            REAL p1m0 = p1 - p0;
            p0 - ( p1m0 * p1m0 ) / ( p2 - ( 2 * p1 ) + p0 )
         END;

    # finds fixed point p such that f(p) = p #
    PROC steffensen aitken = ( PROC(REAL)REAL f # function double to double #
                             , REAL pinit       # initial estimate #
                             , REAL tol         # tolerance #
                             , INT  maxiter     # maximum number of iterations #
                             ) OPTIONALREAL:    # return a REAL, IF tolerance is met #
         BEGIN
            REAL p0  := pinit;
            REAL p   := aitken( f, p0 );        # first iteration #
            TO max iter - 1 WHILE ABS ( p - p0 ) > tol DO
                p0   := p;
                p    := aitken( f, p0 )
            OD;
            IF ABS ( p - p0 ) > tol THEN EMPTY ELSE p FI
         END;

    PROC de casteljau = ( REAL c0      # control point coordinates (one axis) #
                        , REAL c1
                        , REAL c2
                        , REAL t       # the independent parameter #
                        ) REAL:        # value of x(t) or y(t) #
         BEGIN
            REAL s   = 1 - t;
            REAL c01 = ( s * c0 ) + ( t * c1 );
            REAL c12 = ( s * c1 ) + ( t * c2 );
            ( s * c01 ) + ( t * c12 )
         END;

    PROC x convex left parabola = ( REAL t )REAL: de casteljau( 2, -8, 2, t );
    PROC y convex left parabola = ( REAL t )REAL: de casteljau( 1, 2, 3, t );

    PROC implicit equation = ( REAL x, y )REAL: ( 5 * x * x ) + y - 5;

    PROC f = ( REAL t )REAL: # find fixed points of this function #
         BEGIN
            REAL x = x convex left parabola( t );
            REAL y = y convex left parabola( t );
            implicit equation( x, y ) + t
         END;

    # returns v formatted with 1 digit before thw point and 6 after, with a leading sign only if negative #
    OP FMT = ( REAL v )STRING: fixed( v, IF v < 0 THEN -9 ELSE -8 FI, 6 );

    BEGIN
        REAL t0 := 0;
        TO 11 DO
            print( ( "t0 = ", FMT t0, " : " ) );
            CASE steffensen aitken( f, t0, 0.00000001, 1000 )
              IN ( VOID   ): print( ( "no answer", newline) )
               , ( REAL t ):
                     IF REAL x = x convex left parabola( t )
                           , y = y convex left parabola( t )
                           ;
                        ABS implicit equation( x, y ) <= 0.000001
                     THEN
                         print( ( "intersection at (", FMT x, ", ", FMT y, ")", newline ) )
                     ELSE
                         print( ( "spurious solution", newline ) )
                     FI
            ESAC;
            t0 +:= 0.1
        OD
    END

END
