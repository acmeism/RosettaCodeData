BEGIN # angle difference between 2 bearings - translated from the 11l sample #

    PROC wrap = (REAL v, l1, l2 )REAL:
         BEGIN
            REAL result := v;
            WHILE result < l1 DO result +:= 2 * l2 OD;
            WHILE result > l2 DO result +:= 2 * l1 OD;
            result
         END # wrap # ;

    PROC get_difference = ( REAL b1, b2 )REAL: wrap( b2 - b1, -180.0, 180.0 );

    OP   FMT = ( REAL v )STRING:
         BEGIN
            STRING result := fixed( ABS v, 0, 3 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" ELSE " " FI + result
         END # FMT # ;

    print( ( FMT get_difference(  20.0,  45.0 ),       newline ) );
    print( ( FMT get_difference( -45.0,  45.0 ),       newline ) );
    print( ( FMT get_difference( -85.0,  90.0 ),       newline ) );
    print( ( FMT get_difference( -95.0,  90.0 ),       newline ) );
    print( ( FMT get_difference( -45.0, 125.0 ),       newline ) );
    print( ( FMT get_difference( -45.0, 145.0 ),       newline ) );
    print( ( FMT get_difference( -45.0, 125.0 ),       newline ) );
    print( ( FMT get_difference( -45.0, 145.0 ),       newline ) );
    print( ( FMT get_difference(  29.4803, -88.6381 ), newline ) );
    print( ( FMT get_difference( -78.3251, -159.036 ), newline ) );
    print( ( newline ) );
    print( ( FMT get_difference(  -70099.74233810938,     29840.67437876723 ), newline ) );
    print( ( FMT get_difference( -165313.6666297357,      33693.9894517456  ), newline ) );
    print( ( FMT get_difference(    1174.8380510598456, -154146.66490124757 ), newline ) );
    print( ( FMT get_difference(   60175.77306795546,     42213.07192354373 ), newline ) )

END
