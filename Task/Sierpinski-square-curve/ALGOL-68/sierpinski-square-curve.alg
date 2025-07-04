BEGIN # Sierpinski Square Curve in SVG - SVG generation translated from the  #
      # FreeBASIC sample (which is a translation of C++)                     #
      # uses the RC Algol 68 L-System library for the L-System evaluation &  #
      # interpretation                                                       #

    PR read "lsystem.incl.a68" PR               # include L-System utilities #

    PROC sierpinski square curve = ( STRING fname, INT size, length, order )VOID:
         IF FILE svg file;
            BOOL open error := IF open( svg file, fname, stand out channel ) = 0
                               THEN
                                   # opened OK - file already exists and     #
                                   #             will be overwritten         #
                                   FALSE
                               ELSE
                                   # failed to open the file                 #
                                   # - try creating a new file               #
                                   establish( svg file, fname, stand out channel ) /= 0
                               FI;
            open error
         THEN                                      # failed to open the file #
            print( ( "Unable to open ", fname, newline ) );
            stop
         ELSE                                               # file opened OK #

            REAL x     := ( size - length ) / 2;
            REAL y     := length;
            INT  angle := 0;
            put( svg file, ( "<svg xmlns='http://www.w3.org/2000/svg' width='"
                           , whole( size, 0 ), "' height='", whole( size, 0 ), "'>"
                           , newline, "<rect width='100%' height='100%' fill='white'/>"
                           , newline, "<path stroke-width='1' stroke='black' fill='none' d='"
                           , newline, "M", whole( x, 0 ), ",", whole( y, 0 ), newline
                           )
               );

            LSYSTEM ssc = ( "F+XF+F+XF"
                          , ( "X" -> "XF-F+F-XF+F+XF-F+F-X"
                            )
                          );
            STRING curve = ssc EVAL order;
            curve INTERPRET ( ( CHAR c )VOID:
                              IF   c = "F" THEN
                                  x +:= length * cos( angle * pi / 180 );
                                  y +:= length * sin( angle * pi / 180 );
                                  put( svg file, ( " L", whole( x, 0 ), ",", whole( y, 0 ), newline ) )
                              ELIF c = "+" THEN
                                  angle +:= 90 MODAB 360
                              ELIF c = "-" THEN
                                  angle +:= 270 MODAB 360
                              FI
                            );

            put( svg file, ( "'/>", newline, "</svg>", newline ) );
            close( svg file )
         FI # sierpinski square curve # ;

    sierpinski square curve( "sierpinski_square.svg", 635, 5, 5 )

END
