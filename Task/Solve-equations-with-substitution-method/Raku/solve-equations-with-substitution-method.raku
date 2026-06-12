sub solve-system-of-two-linear-equations ( [ \a1, \b1, \c1 ], [ \a2, \b2, \c2 ] ) {
    my \X = ( b2 * c1   -   b1 * c2 )
          / ( b2 * a1   -   b1 * a2 );

    my \Y = ( a1 * X    -   c1 ) / -b1;

    return X, Y;
}
say solve-system-of-two-linear-equations( (3,1,-1), (2,-3,-19) );
