BEGIN # solve the problem of Apollonius - find circles tangential to 3 others #
      # translation of the Java sample                                        #

    OP   FMT = ( REAL v )STRING:
         BEGIN
            STRING result := fixed( v, -12, 2 );
            INT    start  := LWB result;
            WHILE IF start >= UPB result THEN FALSE ELSE result[ start ] = " " FI DO start +:= 1 OD;
            result[ start : ]
         END # FMT # ;

    MODE CIRCLE = STRUCT( REAL x, y, radius );
    OP   TOSTRING = ( CIRCLE c )STRING:
         "Circle[x=" + FMT x OF c + ",y=" + FMT y OF c + ",r=" + FMT radius OF c + "]";

    ### Solves the Problem of Apollonius (finding a circle tangential to three other
      * circles in the plane). The method uses approximately 68 heavy operations
      * (multiplication, division, square-roots).
      * @param c1 One of the circles in the problem
      * @param c2 One of the circles in the problem
      * @param c3 One of the circles in the problem
      * @param s1 An indication if the solution should be externally or internally
      *           tangent (+1/-1) to c1
      * @param s2 An indication if the solution should be externally or internally
      *           tangent (+1/-1) to c2
      * @param s3 An indication if the solution should be externally or internally
      *           tangent (+1/-1) to c3
      * @return The circle that is tangent to c1, c2 and c3.
      #
    PROC solve apollonius = ( CIRCLE c1, c2, c3, INT s1, s2, s3 )CIRCLE:
         BEGIN
            REAL x1 = x OF c1;
            REAL y1 = y OF c1;
            REAL r1 = radius OF c1;
            REAL x2 = x OF c2;
            REAL y2 = y OF c2;
            REAL r2 = radius OF c2;
            REAL x3 = x OF c3;
            REAL y3 = y OF c3;
            REAL r3 = radius OF c3;

            REAL v11 = 2*x2 - 2*x1;
            REAL v12 = 2*y2 - 2*y1;
            REAL v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2;
            REAL v14 = 2*s2*r2 - 2*s1*r1;

            REAL v21 = 2*x3 - 2*x2;
            REAL v22 = 2*y3 - 2*y2;
            REAL v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3;
            REAL v24 = 2*s3*r3 - 2*s2*r2;

            REAL w12 = v12/v11;
            REAL w13 = v13/v11;
            REAL w14 = v14/v11;

            REAL w22 = v22/v21-w12;
            REAL w23 = v23/v21-w13;
            REAL w24 = v24/v21-w14;

            REAL p = -w23/w22;
            REAL q = w24/w22;
            REAL m = -w12*p-w13;
            REAL n = w14 - w12*q;

            REAL a = n*n + q*q - 1;
            REAL b = 2*m*n - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1;
            REAL c = x1*x1 + m*m - 2*m*x1 + p*p + y1*y1 - 2*p*y1 - r1*r1;

            # Find a root of a quadratic equation. This requires the circle centers not #
            # to be e.g. colinear                                                       #
            REAL d  = b*b-4*a*c;
            REAL rs = (-b-sqrt(d))/(2*a);
            REAL xs = m + n * rs;
            REAL ys = p + q * rs;

            ( xs, ys, rs )
         END # solve apollonius # ;

    CIRCLE c1 = ( 0, 0, 1 );
    CIRCLE c2 = ( 4, 0, 1 );
    CIRCLE c3 = ( 2, 4, 2 );

    # should output "Circle[x=2.00,y=2.10,r=3.90]" (green circle in image) #
    print( ( TOSTRING solve apollonius( c1, c2, c3,  1,  1, 1 ), newline ) );
    # should output "Circle[x=2.00,y=0.83,r=1.17]" (red circle in image)   #
    print( ( TOSTRING solve apollonius( c1, c2, c3, -1, -1,-1 ), newline ) )

END
