BEGIN # orbital elements #

    MODE VECTOR = STRUCT( REAL x, y, z );

    OP +   = ( VECTOR v, w )VECTOR: ( x OF v + x OF w, y OF v + y OF w, z OF v + z OF w );
    OP *   = ( VECTOR v, REAL m )VECTOR: ( x OF v * m, y OF v * m, z OF v * m );
    OP /   = ( VECTOR v, REAL d )VECTOR: v * ( 1 / d );
    OP ABS = ( VECTOR v )REAL: sqrt( x OF v * x OF v + y OF v * y OF v + z OF v * z OF v );

    PROC muladd = ( VECTOR  v1, v2, REAL x1, x2 )VECTOR: ( v1 * x1 ) + ( v2 * x2 );
    PROC set v  = ( REF VECTOR v, w, []VECTOR ps )VOID:
         BEGIN v := ps[ LWB ps ]; w := ps[ UPB ps ] END;
    PROC rotate = ( VECTOR i, j, REAL alpha )[]VECTOR:
         ( muladd( i, j,  cos( alpha ), sin( alpha ) ), muladd( i, j, -sin( alpha ), cos( alpha ) ) );
    PROC orbital state vectors = ( REAL semimajor axis, eccentricity, inclination
                                      , longitude of ascending node, argument of periapsis
                                      , true anomaly
                                 , REF VECTOR position, speed
                                 ) VOID:
         BEGIN
            VECTOR i := ( 1.0, 0.0, 0.0 ), j := ( 0.0, 1.0, 0.0 ), k := ( 0.0, 0.0, 1.0 );
            set v( i, j,          rotate( i, j, longitude of ascending node ) );
            set v( j, LOC VECTOR, rotate( j, k, inclination                 ) );
            set v( i, j,          rotate( i, j, argument of periapsis       ) );
            REAL l = IF eccentricity /= 1 THEN 1 - eccentricity * eccentricity ELSE 2 FI
                   * semimajor axis;
            REAL c       = cos( true anomaly ), s = sin( true anomaly );
            REAL r       = l / ( 1.0 + eccentricity * c );
            REAL rprime  = s * r * r / l;
            position    := muladd( i, j, c, s ) * r;
            speed       := muladd( i, j, rprime * c - r * s, rprime * s + r * c );
            speed       := speed / ABS speed;
            speed       := speed * sqrt( 2 / r - 1 / semimajor axis )
         END # orbital state vectors # ;

    OP   FMT = ( REAL v )STRING:
         BEGIN
            STRING result := fixed( ABS v, 0, 15 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" + result ELSE result FI
         END # FMT # ;
    OP TOSTRING = ( VECTOR v )STRING: "(" + FMT x OF v + ", " + FMT y OF v + ", " + FMT z OF v + ")";

    BEGIN
        REAL longitude = 355 / ( 113 * 6 );
        VECTOR position, speed;
        orbital state vectors( 1.0, 0.1, 0.0, longitude, 0.0, 0.0, position, speed );
        print( ( "Position : ", TOSTRING position, newline ) );
        print( ( "Speed    : ", TOSTRING speed,    newline ) )
    END
END
