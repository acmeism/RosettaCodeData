BEGIN
    # returns the length of the arc between the angles a and b on a circle of radius r #
    # the angles should  be specified in degrees                                       #
    PROC major arc length = ( REAL a, b, r )REAL:
         BEGIN
            REAL angle := ABS ( a - b );
            WHILE angle > 360 DO angle -:= 360 OD;
            IF angle < 180 THEN angle := 360 - angle FI;
            ( r * angle * pi ) / 180
         END # majorArcLength # ;
    # task test case                                                                   #
    print( ( fixed( major arc length( 10, 120, 10 ), -10, 4 ), newline ) )
END
