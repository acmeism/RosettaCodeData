BEGIN # generate SVG to show the word RAINBOW in the colours of the spectrum #
    PROC max = ( INT a, b )INT: IF a < b THEN b ELSE a FI;
    STRING text = "RAINBOW";
    []STRING colour = ( "red", "orange", "yellow", "green", "blue", "indigo", "violet" );
    INT      c len  = ( UPB colour - LWB colour ) + 1;   # number of colours #
    INT      x     := 30;
    INT      y      = 30;
    print( ( "<svg xmlns='http://www.w3.org/2000/svg' width='"
           , whole( ( c len * 20 ) + 60, 0 ), "' "
           , "height='50' style='font:bold 30px monospace'>", newline
           , "  <rect width='100%' height='100%' fill='grey'/>", newline
           )
         );
    FOR i FROM LWB text TO UPB text DO
        STRING c name = colour[ max( 1, i MOD ( c len + 1 ) ) ];
        print( ( "  <text x='", whole( x, 0 ), "' y='", whole( y, 0 ), "' " ) );
        print( ( "fill='", c name, "' stroke='", c name, "'>", text[ i ], "</text>", newline ) );
        x +:= 20
    OD;
    print( ( "</svg>", newline ) )
END
