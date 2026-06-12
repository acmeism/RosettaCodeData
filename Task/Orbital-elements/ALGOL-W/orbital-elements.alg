begin
    % compute orbital elements                                               %
    % 3-element vector                                                       %
    record Vector( real x, y, z );
    % prints the components of the vector v                                  %
    procedure writeOnVector( reference(Vector) value v ) ;
        writeon( r_format := "A", r_w := 10, r_d := 6, s_w := 0, "( ", x(v), ", ", y(v), ", ", z(v), " )" );
    % returns a vector whose elements are the sum of the elements of v & w   %
    reference(Vector) procedure add( reference(Vector) value v, w ) ;
        Vector( x(v) + x(w), y(v) + y(w), z(v) + z(w) );
    % returns a vector whose elements are those of v multiplied by m         %
    reference(Vector) procedure mul( reference(Vector) value v
                                   ; real              value m
                                   ) ;
        Vector( x(v) * m, y(v) * m, z(v) * m );
    % returns a vector whose elements are those of v divided by d            %
    reference(Vector) procedure divVR( reference(Vector) value v
                                     ; real              value d
                                     ) ;
        mul( v, 1 / d );
    % returns the norm of the vector v                                       %
    real procedure vabs( reference(Vector) value v ) ;
        sqrt( ( x(v) * x(v) ) + y(v) * y(v) + z(v) * z(v) );
    % returns the sum of v1 * x1 and v2 * x2                                 %
    reference(Vector) procedure mulAdd( reference(Vector) value v1, v2
                                      ; real              value x1, x2
                                      ) ;
        add( mul( v1, x1 ), mul( v2, x2 ) );
    % sets ps to rotations of i and j by alpha                               %
    procedure rotate( reference(Vector) value i, j
                    ; real              value alpha
                    ; reference(Vector) array ps ( * )
                    ) ;
    begin
        ps( 0 ) := mulAdd( i, j,  cos( alpha ), sin( alpha ) );
        ps( 1 ) := mulAdd( i, j, -sin( alpha ), cos( alpha ) )
    end rotate ;
    % sets position and speed vectors from the supplied elements             %
    procedure orbitalStateVectors( real              value  semimajorAxis
                                 ,                          eccentricity
                                 ,                          inclination
                                 ,                          longitudeOfAscendingNode
                                 ,                          argumentOfPeriapsis
                                 ,                          trueAnomaly
                                 ; reference(Vector) result position
                                 ,                          speed
                                 ) ;
    begin
        reference(Vector) i, j, k;
        reference(Vector) array qs ( 0 :: 1 );
        real              L, c, s, r, rprime;
        i        := Vector( 1.0, 0.0, 0.0 );
        j        := Vector( 0.0, 1.0, 0.0 );
        k        := Vector( 0.0, 0.0, 1.0 );
        L        := 2.0;
        rotate( i, j, longitudeOfAscendingNode, qs );
        i        := qs( 0 );
        j        := qs( 1 );
        rotate( j, k, inclination, qs );
        j        := qs( 0 );
        rotate( i, j, argumentOfPeriapsis, qs );
        i        := qs( 0 );
        j        := qs( 1 );
        if eccentricity not = 1 then L := 1 - eccentricity * eccentricity;
        l        := L * semimajorAxis;
        c        := cos( trueAnomaly );
        s        := sin( trueAnomaly );
        r        := L / ( 1.0 + eccentricity * c );
        rprime   := s * r * r / L;
        position := mulAdd( i, j, c, s );
        position := mul( position, r ) ;
        speed    := mulAdd( i, j, rprime * c - r * s, rprime * s + r * c );
        speed    := divVR( speed, vabs( speed ) );
        speed    := mul( speed, sqrt( 2 / r - 1 / semimajorAxis ) );
    end orbitalStateVectors ;
    % test the orbitalStateVectors routine                                   %
    begin
        real longitude;
        reference(Vector) position, speed;
        longitude := 355.0 / ( 113.0 * 6.0 );
        orbitalStateVectors( 1.0, 0.1, 0.0, longitude, 0.0, 0.0, position, speed );
        write( "Position : " ); writeOnVector( position );
        write( "Speed    : " ); writeOnVector( speed    )
    end
end.
