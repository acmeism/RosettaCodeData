BEGIN # draw a pythagoras tree, using SVG                                    #

    MODE POS = REAL;                             # MODE holding a coordinate #

    # operators for formatting                                               #
    OP   BYTETOHEX = ( INT v )CHAR:
         REPR IF v < 10 THEN ABS "0" + v ELSE ABS "A" + ( v - 10 ) FI;
    OP   TOHEX = ( INT v in )STRING:
         IF   v in = 0
         THEN "0"
         ELSE INT    v      := vin;
              STRING result := "";
              WHILE  v > 0 DO
                  BYTETOHEX ( v MOD 16 ) +=: result;
                  v OVERAB 16
              OD;
              result
         FI # TOHEX # ;
    OP   FMT = ( INT v )STRING: whole( v, 0 );
    PRIO FMT = 9;
    OP   FMT = ( REAL v, INT dp )STRING:
         IF   v = ENTIER v OR dp = 0
         THEN whole( v, 0 )
         ELSE STRING result = fixed( v, - dp * 16, ABS dp );
              INT v pos := LWB result;
              WHILE result[ v pos ] = " " DO v pos +:= 1 OD;
              result[ v pos : ]
         FI # FMT # ;

    # draws a polygon, points must have an even number of elements           #
    PROC polygon = ( []POS points, INT fill, stroke, REAL line width )VOID:
         BEGIN
            print( ( "  <polygon points='" ) );
            FOR p FROM LWB points TO UPB points DO
                print( ( " ", points[ p ] FMT 3 ) )
            OD;
            print( ( "'", newline, "           " ) );
            print( ( "style='fill:#", TOHEX fill,  ";"  ) );
            print( ( "stroke:#",      TOHEX stroke, ";" ) );
            print( ( "stroke-width:", line width FMT 2, ";" ) );
            print( ( "stroke-linejoin:round;" ) );
            print( ( "'", newline, "  />", newline ) )
        END # polygon # ;
    PROC square   = ( POS x1, y1, x2, y2, x3, y3, x4, y4
                    , INT fill, stroke
                    , REAL line width
                    ) VOID: polygon( ( x1, y1, x2, y2, x3, y3, x4, y4 ), fill, stroke, line width );
    PROC triangle = ( POS x1, y1, x2, y2, x3, y3
                    , INT fill, stroke
                    , REAL line width
                    ) VOID: polygon( ( x1, y1, x2, y2, x3, y3 ),         fill, stroke, line width );

    PROC draw pythagoras tree = ( INT  height
                                , POS  x1, y1, x2, y2
                                , INT  depth, max depth
                                , REAL line width
                                ) VOID:
         IF depth < max depth THEN
            POS dx     = x2 - x1;
            POS dy     = y1 - y2;
            POS x3     = x2 + dy;
            POS y3     = y2 + dx;
            POS x4     = x1 + dy;
            POS y4     = y1 + dx;
            POS x5     = x4 + 0.5 * ( dx + dy );
            POS y5     = y4 + 0.5 * ( dx - dy );
            INT r      = 255 - ROUND ( 255 * ( 0.01 + ( depth / 10 ) ) );
            INT g      = 255 - ROUND ( 255 * ( 0.01 + ( depth / 20 ) ) );
            INT b      = g OVER 3;
            INT fill   = ( ( ( r * 256 ) + g ) * 256 ) + b;
            INT stroke = ABS 16r 444444;
            # inveret the y-axis, so y=0 is at the bottom                    #
            POS i1 = height - y1, i2 = height - y2, i3 = height - y3;
            POS i4 = height - y4, i5 = height - y5;
            square(   x1, i1, x2, i2, x3, i3, x4, i4, fill, stroke, line width );
            triangle( x3, i3, x4, i4, x5, i5,         fill, stroke, line width );
            draw pythagoras tree( height, x4, y4, x5, y5, depth + 1, max depth, line width );
            draw pythagoras tree( height, x5, y5, x3, y3, depth + 1, max depth, line width )
         FI # draw pythagoras tree # ;

    PROC pythagoras tree = ( INT  width, height
                           , POS  x1, y1, x2, y2
                           , INT  max depth
                           , REAL line width
                           ) VOID:
         BEGIN
            print( ( "<svg xmlns='http://www.w3.org/2000/svg'" ) );
            print( ( " width='", FMT width, "' height='", FMT height, "'>", newline ) );
            draw pythagoras tree( height, x1, y1, x2, y2, 0, max depth, line width );
            print( ( "</svg>", newline ) )
         END # pythagoras tree #;

    pythagoras tree( 120, 90, 51, 10, 69, 10, 10, 0.03 )

END
