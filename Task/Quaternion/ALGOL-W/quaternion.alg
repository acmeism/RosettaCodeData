begin
    % Quaternion record type                                                 %
    record Quaternion ( real a, b, c, d );

    % returns the norm of the specified quaternion                           %
    real procedure normQ ( reference(Quaternion) value q ) ;
        sqrt( (a(q) * a(q)) + (b(q) * b(q)) + (c(q) * c(q)) + (d(q) * d(q)) );

    % returns the negative of the specified quaternion                       %
    reference(Quaternion) procedure negQ ( reference(Quaternion) value q ) ;
        Quaternion( - a(q), - b(q), - c(q), - d(q) );

    % returns the conjugate of the specified quaternion                      %
    reference(Quaternion) procedure conjQ ( reference(Quaternion) value q ) ;
        Quaternion(   a(q), - b(q), - c(q), - d(q) );

    % returns the sum of a real and a quaternion                             %
    reference(Quaternion) procedure addRQ ( real                  value r
                                          ; reference(Quaternion) value q
                                          ) ;
        Quaternion( r + a(q), b(q), c(q), d(q) );

    % returns the sum of a quaternion and a real                             %
    reference(Quaternion) procedure addQR ( reference(Quaternion) value q
                                          ; real                  value r
                                          ) ;
        Quaternion( r + a(q), b(q), c(q), d(q) );

    % returns the sum of the specified quaternions                           %
    reference(Quaternion) procedure addQQ ( reference(Quaternion) value q1
                                          ; reference(Quaternion) value q2
                                          ) ;
        Quaternion( a(q1) + a(q2), b(q1) + b(q2), c(q1) + c(q2), d(q1) + d(q2) );

    % returns the specified quaternion multiplied by a real                  %
    reference(Quaternion) procedure mulQR ( reference(Quaternion) value q
                                          ; real                  value r
                                          ) ;
        Quaternion( r * a(q), r * b(q), r * c(q), r * d(q) );

    % returns a real multiplied by the specified quaternion                  %
    reference(Quaternion) procedure mulRQ ( real                  value r
                                          ; reference(Quaternion) value q
                                          ) ;
        mulQR( q, r );

    % returns the Quaternion product of the specified quaternions            %
    reference(Quaternion) procedure mulQQ( reference(Quaternion) value q1
                                         ; reference(Quaternion) value q2
                                         ) ;
        Quaternion( (a(q1) * a(q2)) - (b(q1) * b(q2)) - (c(q1) * c(q2)) - (d(q1) * d(q2))
                  , (a(q1) * b(q2)) + (b(q1) * a(q2)) + (c(q1) * d(q2)) - (d(q1) * c(q2))
                  , (a(q1) * c(q2)) - (b(q1) * d(q2)) + (c(q1) * a(q2)) + (d(q1) * b(q2))
                  , (a(q1) * d(q2)) + (b(q1) * c(q2)) - (c(q1) * b(q2)) + (d(q1) * a(q2))
                  );

    % returns true if the two quaternions are equal, false otherwise         %
    logical procedure equalQ( reference(Quaternion) value q1
                            ; reference(Quaternion) value q2
                            ) ;
        a(q1) = a(q2) and b(q1) = b(q2) and c(q1) = c(q2) and d(q1) = d(q2);

    % writes a quaternion                                                    %
    procedure writeonQ( reference(Quaternion) value q ) ;
        writeon( "(", a(q), ", ", b(q), ", ", c(q), ", ", d(q), ")" );


    % test q1q2 = q2q1                                                       %
    reference(Quaternion) q, q1, q2;

    q  := Quaternion( 1, 2, 3, 4 );
    q1 := Quaternion( 2, 3, 4, 5 );
    q2 := Quaternion( 3, 4, 5, 6 );

    % set output format                                                      %
    s_w := 0; r_format := "A"; r_w := 5; r_d := 1;

    write( "      q:" );writeonQ( q );
    write( "     q1:" );writeonQ( q1 );
    write( "     q2:" );writeonQ( q2 );
    write( "norm  q:" );writeon( normQ( q ) );
    write( "norm q1:" );writeon( normQ( q1 ) );
    write( "norm q2:" );writeon( normQ( q2 ) );

    write( " conj q:" );writeonQ( conjQ( q ) );
    write( "    - q:" );writeonQ( negQ( q ) );
    write( "  7 + q:" );writeonQ( addRQ( 7, q ) );
    write( "  q + 9:" );writeonQ( addQR( q, 9 ) );
    write( " q + q1:" );writeonQ( addQQ( q, q1 ) );
    write( "  3 * q:" );writeonQ( mulRQ( 3, q ) );
    write( "  q * 4:" );writeonQ( mulQR( q, 4 ) );

    % check that q1q2 not = q2q1                                             %
    if equalQ( mulQQ( q1, q2 ), mulQQ( q2, q1 ) )
    then write( "q1q2 = q2q1 ??" )
    else write( "q1q2 <> q2q1" );

    write( "   q1q2:" );writeonQ( mulQQ( q1, q2 ) );
    write( "   q2q1:" );writeonQ( mulQQ( q2, q1 ) );

end.
