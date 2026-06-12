BEGIN # N Body Problem - translated from the Python sample #

    MODE VECTOR = STRUCT( REAL x, y, z );

    OP   + = ( VECTOR self, other )VECTOR:
         ( x OF self + x OF other, y OF self + y OF other, z OF self + z OF other);

    OP   - = ( VECTOR self, other )VECTOR:
         ( x OF self - x OF other, y OF self - y OF other, z OF self - z OF other );

    OP   * = ( VECTOR self, REAL other )VECTOR:
         ( x OF self * other, y OF self * other, z OF self * other );

    OP   = = ( VECTOR self, other )BOOL:
         x OF self = x OF other AND y OF self = y OF other AND z OF self = z OF other;

    OP   TOSTRING = ( INT v )STRING: whole( v, 0 );
    OP   TOSTRING = ( REAL v )STRING: fixed( v, -9, 6 );
    OP   TOSTRING = ( VECTOR self )STRING:
         TOSTRING x OF self + "  " + TOSTRING y OF self + "  " + TOSTRING z OF self;

    OP   ABS = ( VECTOR self )REAL:
         sqrt( ( x OF self * x OF self ) + ( y OF self * y OF self ) + ( z OF self * z OF self ) );

    OP   +:= = ( REF VECTOR self, VECTOR other )REF VECTOR: self := self + other;

    VECTOR origin = ( 0, 0, 0 );

    MODE NBODY = STRUCT( REAL        gc
                       , INT         bodies
                       , INT         time steps
                       , REF[]REAL   masses
                       , REF[]VECTOR positions, velocities, accelerations
                       );

    PRIO INIT = 1;
    OP   INIT = ( REF NBODY self, STRING filename )VOID:
         IF FILE data;
            open( data, filename, stand back channel ) /= 0
         THEN
            print( ( "Unable to open ", filename, newline ) );
            stop
         ELSE
            get( data, ( gc OF self, bodies OF self, time steps OF self, newline ) );
            masses OF self        := HEAP[ 1 : bodies OF self ]REAL;
            positions OF self     := HEAP[ 1 : bodies OF self ]VECTOR;
            velocities OF self    := HEAP[ 1 : bodies OF self ]VECTOR;
            accelerations OF self := HEAP[ 1 : bodies OF self ]VECTOR;
            FOR i TO bodies OF self DO
               get( data, ( ( masses OF self )[ i ], newline ) );
               get( data, ( x OF ( positions OF self )[ i ]
                          , y OF ( positions OF self )[ i ]
                          , z OF ( positions OF self )[ i ]
                          , newline
                          )
                  );
               get( data, ( x OF ( velocities OF self )[ i ]
                          , y OF ( velocities OF self )[ i ]
                          , z OF ( velocities OF self )[ i ]
                          , newline
                          )
                  );
               ( accelerations OF self )[ i ] := origin
            OD;
            close( data );
            print( ( "Contents of ", filename, newline ) );
            print( ( TOSTRING gc OF self, " ", TOSTRING bodies OF self, " " ) );
            print( ( TOSTRING time steps OF self, newline ) );
            FOR i TO bodies OF self DO
                print( ( TOSTRING ( masses OF self     )[ i ], newline ) );
                print( ( TOSTRING ( positions OF self  )[ i ], newline ) );
                print( ( TOSTRING ( velocities OF self )[ i ], newline ) )
            OD;
            print( ( newline ) );
            print( ( "Body   :      x          y          z    |" ) );
            print( ( "     vx         vy         vz", newline ) )
         FI # INIT # ;

    OP   COMPUTEACCELERATIONS = ( REF NBODY self )VOID:
         FOR i TO bodies OF self DO
            ( accelerations OF self )[ i ] := origin;
            FOR j TO bodies OF self DO
                IF i /= j THEN
                    REAL temp = ( gc OF self * ( masses OF self )[ j ] )
                              / ( ABS ( ( positions OF self )[ i ] - ( positions OF self )[ j ] ) ^ 3 );
                    ( accelerations OF self )[ i ]
                        +:= ( ( positions OF self )[ j ] - ( positions OF self )[ i ] ) * temp
                FI
            OD
         OD # COMPUTEACCELERATIONS # ;

    OP   COMPUTEPOSITIONS = ( REF NBODY self )VOID:
         FOR i TO bodies OF self DO
            ( positions OF self )[ i ] +:= ( velocities OF self )[ i ] + ( accelerations OF self )[ i ] * 0.5
         OD # COMPUTEPOSITIONS # ;

    OP   COMPUTEVELOCITIES = ( REF NBODY self )VOID:
         FOR i TO bodies OF self DO
            ( velocities OF self )[ i ] +:= ( accelerations OF self )[ i ]
         OD # COMPUTEVELOCITES # ;

    OP   RESOLVECOLLISIONS = ( REF NBODY self )VOID:
         FOR i TO bodies OF self DO
            FOR j TO bodies OF self DO
                IF ( positions OF self )[ i ] = ( positions OF self )[ j ] THEN
                    VECTOR vj                    = ( velocities OF self )[ j ];
                    ( velocities OF self )[ j ] := ( velocities OF self )[ i ];
                    ( velocities OF self )[ i ] := vj
                FI
            OD
         OD # RESOLVECOLLISIONS # ;

    OP   SIMULATE = ( REF NBODY self )VOID:
         BEGIN
            COMPUTEACCELERATIONS self;
            COMPUTEPOSITIONS     self;
            COMPUTEVELOCITIES    self;
            RESOLVECOLLISIONS    self
         END # SIMULATE # ;

    NBODY nb;
    nb INIT "nbody.txt";
    FOR t TO time steps OF nb DO
        print( ( newline, "Cycle ", TOSTRING t, newline ) );
        SIMULATE nb;
        FOR i TO bodies OF nb DO
            print( ( "Body ", TOSTRING i
                   , " : ",   TOSTRING (  positions OF nb )[ i ]
                   , " | ",   TOSTRING ( velocities OF nb )[ i ]
                   , newline
                   )
                 )
        OD
    OD

END
