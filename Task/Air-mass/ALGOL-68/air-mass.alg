BEGIN # Air mass - translated from the Pluto sample #

    # Constants. #
    INT  re  = 6371000;  # radius of earth in meters #
    REAL dd  = 0.001;    # integrate in this fraction of the distance already covered #
    REAL fin = 1e7;      # integrate only to a height of 10000km, effectively infinity #

    # returns x degrees expressed in radians #
    OP TORADIANS = ( REAL x )REAL: pi * ( x / 180 );

    # returns the maximum of a and b #
    PROC rmax = ( REAL a, b )REAL: IF a > b THEN a ELSE b FI;

    # The density of air as a function of height above sea level. #
    PROC rho = ( REAL a )REAL: exp( -a / 8500 );

    # a = altitude of observer         #
    # z = zenith angle (in degrees)    #
    # d = distance along line of sight #
    PROC height = ( REAL a, z, d )REAL:
         BEGIN
            REAL aa = re + a;
            REAL hh = sqrt( aa * aa + d * d - 2 * d * aa * cos( TORADIANS ( 180 - z ) ) );
            hh - re
         END # height # ;

    # Integrates density along the line of sight. #
    PROC column density = ( REAL a, z )REAL:
         BEGIN
            REAL sum := 0;
            REAL d   := 0;
            WHILE d < fin DO
                REAL delta = rmax( dd, dd * d );  # adaptive step size to avoid it taking forever #
                sum +:= rho( height( a, z, d + 0.5 * delta ) ) * delta;
                d   +:= delta
            OD;
            sum
         END # column density # ;

    PROC  air mass = ( REAL a, z )REAL: column density( a, z ) / column density( a, 0 );

    BEGIN
        print( ( "Angle     0 m              13700 m",   newline ) );
        print( ( "------------------------------------", newline ) );
        FOR z FROM 0 BY 5 TO 90 DO
            print( ( whole( z, -2 ), "      ", fixed( air mass(     0, z ), -11, 8 ) ) );
            print( (                 "      ", fixed( air mass( 13700, z ), -11, 8 ), newline ) )
        OD
    END
END
