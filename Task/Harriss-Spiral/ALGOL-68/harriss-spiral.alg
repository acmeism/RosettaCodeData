BEGIN # Harriss Spiral in SVG - translation of EasyLang/Processing samples   #

    PROC hex1    = ( INT d )STRING: IF d < 10 THEN REPR( ABS "0" + d ) ELSE REPR( ABS "a" + ( d - 10 ) ) FI;
    PROC hex     = ( INT v )STRING: hex1( v OVER 16 ) + hex1( v MOD 16 );
    PROC rgb     = ( INT r, g, b )STRING: "#" + hex( r ) + hex( g ) + hex( b );
    OP   SIND    = ( REAL x )REAL: sin( x * pi / 180 );
    OP   COSD    = ( REAL x )REAL: cos( x * pi / 180 );
    PRIO FMT = 9;
    OP   FMT = ( REAL v, INT dp )STRING:
         BEGIN
            STRING result = IF ENTIER v = v
                            THEN whole( v, - dp * 16 )
                            ELSE fixed( v, - dp * 16, ABS dp )
                            FI;
            INT v pos := LWB result;
            WHILE result[ v pos ] = " " DO v pos +:= 1 OD;
            result[ v pos : ]
         END # FMT # ;
    PROC point   = ( REAL x, y )STRING: x FMT 2 + " " + y FMT 2;
    PROC move to = ( REAL x, y )STRING: "M " + point( x, y );
    PROC line to = ( REAL x, y )STRING: "L " + point( x, y );
    PROC start path = ( INT r, g, b, REAL line width, x, y )STRING:
         ( "  <path stroke-width='" + line width FMT 2
         + "' stroke='" + rgb( r, g, b ) + "' fill='none' d='" + move to( x, y ) + " "
         );
    PROC line = ( INT r, g, b, REAL line width, REAL x, y, x end, y end )VOID:
         print( ( start path( r, g, b, line width, x, y ), " ", line to( x end, y end ), "'/>"
                , newline
                )
              );
    PROC arc = ( REAL x centre, y centre, ew, eh, start angle, end angle, INT r, g, b, REAL line width )VOID:
         BEGIN
            REAL rx = ew / 2, ry = ( eh / ew ) * eh / 2;
            REAL x     = x centre + rx * COSD start angle, y     = y centre + ry * SIND start angle;
            REAL x end = x centre + rx * COSD end angle,   y end = y centre + ry * SIND end angle;
            print( ( start path( r, g, b, line width, x, y )
                   , "A ", rx FMT 2, " ", ry FMT 2 , " 0 0 1 ", point( x end, y end )
                   , "'/>", newline
                   )
                 )
         END # arc # ;

    REAL h  = 600;   # scalable (may be any value) #
    REAL hr = 1.325; # Harriss Ratio               #

    PROC spiral section = ( REAL   x, y, angle, lngth
                          , INT    iteration
                          , REAL   line width
                          , BOOL   show lines
                          ) VOID:
         IF iteration > 0 THEN
             REAL start angle = angle + 45;
             REAL end angle   = start angle + 90;
             # Calculate end point of lines #
             REAL x end  = x + lngth * COSD angle;
             REAL y end  = y + lngth * SIND angle;
             REAL radius = 1.414 * lngth;
             spiral section( x end, y end, angle + 90, lngth / hr / hr, iteration - 2, line width, show lines );
             IF show lines THEN
                 line( 255, 255, 255, 1, x, y, x end, y end )
             FI;
             INT sn = 1, ew = 2, ns = 3, we = 4;
             INT heading := sn;
             IF ENTIER y end < ENTIER y THEN heading := sn FI;
             IF ENTIER x end < ENTIER x THEN heading := ew FI;
             IF ENTIER y end > ENTIER y THEN heading := ns FI;
             IF ENTIER x end > ENTIER x THEN heading := we FI;
             REAL l2 = lngth / 2;
             IF   heading = sn THEN
                 arc( x - l2, y - l2, radius, radius, start angle, end angle, 255, 255,   0, line width )
             ELIF heading = ew THEN
                 arc( x - l2, y + l2, radius, radius, start angle, end angle, 255,   0,   0, line width )
             ELIF heading = ns THEN
                 arc( x + l2, y + l2, radius, radius, start angle, end angle,   0,   0, 255, line width )
             ELIF heading = we THEN
                 arc( x + l2, y - l2, radius, radius, start angle, end angle,   0,   0,   0, line width )
             FI;
             spiral section( x end, y end, angle - 90, lngth / hr, iteration - 1, line width, show lines )
         FI # spiral section #;

    PROC generate harriss spiral = ( INT c width, c height )VOID:
         BEGIN
            print( ( "<svg xmlns='http://www.w3.org/2000/svg' width='"
                   , whole( c width, 0 ), "' height='", whole( c height, 0 ), "'>", newline
                   , "  <rect width='100%' height='100%' fill='#7f7f7f'/>", newline
                   )
                 );
            REAL start x = c width / 2 + 50;
            REAL start y = c height - 50;
            REAL init len = h / hr / hr;
            spiral section( start x, start y, -90, init len, 16, 2, FALSE );
            print( ( "</svg>", newline ) )
         END # generate harriss spiral #;

    generate harriss spiral( 1000, 800 )

END
