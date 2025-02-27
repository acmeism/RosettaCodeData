BEGIN # draw a pentagram, using SVG                                      #

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

    PROC draw gram = ( INT width, height, vertices, REAL side, start x, start y, line width )VOID:
         BEGIN
            REAL angle = 360 / vertices;
            print( ( "<svg xmlns='http://www.w3.org/2000/svg' width='"
                   , whole( width, 0 ), "' height='", whole( height, 0 ), "'>", newline
                   )
                 );
            REAL x := start x, y := start y;
            print( ( "  <polygon points='", point( x, y ) ) );
            REAL heading := angle;
            TO vertices DO
                x +:= side * COSD heading;
                y +:= side * SIND heading;
                print( ( " ", point( x, y ) ) );
                heading -:= 180 -:= angle / 2
            OD;
            print( ( "'",   newline ) );
            print( ( "            style='fill:#55cccc;stroke:#5555cc;stroke-width:" ) );
            print( ( whole( line width, 0 ), "'/>", newline ) );
            print( ( "</svg>", newline ) )
         END # draw gram #;

    draw gram( 500, 300, 5, 240, 150, 50, 3 )

END
