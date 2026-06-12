BEGIN # Rodrigues' Rotation Formula #
    MODE VECTOR = [ 3 ]REAL;
    MODE MATRIX = [ 3 ]VECTOR;
    PROC norm = ( VECTOR v )REAL: sqrt( ( v[1] * v[1] ) + ( v[2] * v[2] ) + ( v[3] * v[3] ) );
    PROC normalize = ( VECTOR v )VECTOR:
         BEGIN
            REAL length = norm( v );
            ( v[1] / length, v[2] / length, v[3] / length )
         END # normalize # ;
    PROC dot product = ( VECTOR v1, v2 )REAL: ( v1[1] * v2[1] ) + ( v1[2] * v2[2] ) + ( v1[3] * v2[3] );
    PROC cross product = ( VECTOR v1, v2 )VECTOR: ( ( v1[2] * v2[3] ) - ( v1[3] * v2[2] )
                                                  , ( v1[3] * v2[1] ) - ( v1[1] * v2[3] )
                                                  , ( v1[1] * v2[2] ) - ( v1[2] * v2[1] )
                                                  );
    PROC get angle = ( VECTOR v1, v2 )REAL: acos( dot product( v1, v2 ) / ( norm( v1 ) * norm( v2 ) ) );
    PROC matrix multiply = ( MATRIX m, VECTOR v )VECTOR: ( dot product( m[1], v )
                                                         , dot product( m[2], v )
                                                         , dot product( m[3], v )
                                                         );
    PROC a rotate = ( VECTOR p, v, REAL a )VECTOR:
         BEGIN
            REAL ca = cos( a ), sa = sin( a ), t = 1 - ca, x = v[1],  y = v[2], z = v[3];
            MATRIX r = ( ( ca + ( x*x*t ), ( x*y*t ) - ( z*sa ), ( x*z*t )  + ( y*sa ) )
                       , ( ( x*y*t ) + ( z*sa ), ca + ( y*y*t ), ( y*z*t ) - ( x*sa ) )
                       , ( ( z*x*t ) - ( y*sa ), ( z*y*t ) + ( x*sa ), ca + ( z*z*t ) )
                       );
            matrix multiply( r, p )
         END # a rotate # ;
    BEGIN
        VECTOR v1  = ( 5, -6, 4 );
        VECTOR v2  = ( 8, 5, -30 );
        REAL   a   = get angle( v1, v2 );
        VECTOR cp  = cross product( v1, v2 );
        VECTOR ncp = normalize( cp );
        VECTOR np  = a rotate( v1, ncp, a );
        print( ( "( ", fixed( np[ 1 ], -10, 6 )
               , ", ", fixed( np[ 2 ], -10, 6 )
               , ", ", fixed( np[ 3 ], -10, 6 )
               , " )", newline
               )
             )
    END
END
