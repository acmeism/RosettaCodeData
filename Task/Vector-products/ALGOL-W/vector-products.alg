begin
    % define the Vector record type                                          %
    record Vector( integer X, Y, Z );

    % calculates the dot product of two Vectors                              %
    integer procedure dotProduct( reference(Vector) value A, B ) ;
        ( X(A) * X(B) ) + ( Y(A) * Y(B) ) + ( Z(A) * Z(B) );

    % calculates the cross product or two Vectors                            %
    reference(Vector) procedure crossProduct( reference(Vector) value A, B ) ;
        Vector( ( Y(A) * Z(B) ) - ( Z(A) * Y(B) )
              , ( Z(A) * X(B) ) - ( X(A) * Z(B) )
              , ( X(A) * Y(B) ) - ( Y(A) * X(B) )
              );

    % calculates the scaler triple product of two vectors                    %
    integer procedure scalerTripleProduct( reference(Vector) value A, B, C ) ;
        dotProduct( A, crossProduct( B, C ) );

    % calculates the vector triple product of two vectors                    %
    reference(Vector) procedure vectorTripleProduct( reference(Vector) value A, B, C ) ;
        crossProduct( A, crossProduct( B, C ) );

    % test the Vector routines                                               %
    begin
        procedure writeonVector( reference(Vector) value v ) ;
            writeon( "(", X(v), ", ", Y(v), ", ", Z(v), ")" );

        Reference(Vector) a, b, c;

        a := Vector(  3,   4,   5 );
        b := Vector(  4,   3,   5 );
        c := Vector( -5, -12, -13 );

        i_w := 1; s_w := 0; % set output formatting                          %

        write( "            a: " ); writeonVector( a );
        write( "            b: " ); writeonVector( b );
        write( "            c: " ); writeonVector( c );
        write( "        a . b: ", dotProduct( a, b ) );
        write( "        a x b: " ); writeonVector( crossProduct( a, b ) );
        write( "a . ( b x c ): ", scalerTripleProduct( a, b, c ) );
        write( "a x ( b x c ): " ); writeonVector( vectorTripleProduct( a, b, c ) )
    end
end.
