BEGIN
    # find all integer sided 90, 60 and 120 degree triangles by finding integer solutions for #
    #    a^2 + b^2 = c^2, a^2 + b^2 - ab = c^2, a^2 + b^2 + ab = c^2 where a, b, c in 1 .. 13 #
    INT max side   = 13;                  # max triangle side to consider                     #
    INT max square = max side * max side; # max triangle side squared to consider             #
    [ 1 : max square ]INT root;           # table of square roots                             #
    FOR s TO UPB root DO root[ s     ] := 0 OD;
    FOR s TO max side DO root[ s * s ] := s OD;
    INT tcount := 0;
    [ 1 : max square ]INT ta, tb, tc, tangle;
    # prints solutions for the specified angle                                                #
    PROC print triangles = ( INT angle )VOID:
    BEGIN
        INT scount := 0;
        FOR t TO tcount DO IF tangle[ t ] = angle THEN scount +:= 1 FI OD;
        print( ( whole( scount, -4 ), " ", whole( angle, -3 ), " degree triangles:", newline ) );
        FOR t TO tcount DO
            IF tangle[ t ] = angle THEN
                print( ( "    ", whole( ta[ t ], -3 ), whole( tb[ t ], -3 ), whole( tc[ t ], -3 ), newline ) )
            FI
        OD
    END # print triangles # ;
    # stores the triangle with sides a, b, root[ c2 ] and the specified angle,                #
    # if it is a solution                                                                     #
    PROC try triangle = ( INT a, b, c2, angle )VOID:
        IF  c2 <= max square THEN
            # the third side is small enough                                                  #
            INT c = root[ c2 ];
            IF  c /= 0 THEN
                # the third side is the square of an integer                                  #
                tcount +:= 1;
                ta[     tcount ] := a; tb[ tcount ] := b; tc[ tcount ] := root[ c2 ];
                tangle[ tcount ] := angle
            FI
        FI # try triangle # ;
    # find all triangles                                                                      #
    FOR a TO max side DO
        FOR b FROM a TO max side DO
            try triangle( a, b, ( a * a ) + ( b * b ) - ( a * b ),  60 );
            try triangle( a, b, ( a * a ) + ( b * b ),              90 );
            try triangle( a, b, ( a * a ) + ( b * b ) + ( a * b ), 120 )
        OD
    OD;
    # print the solutions                                                                     #
    print triangles(  60 );
    print triangles(  90 );
    print triangles( 120 )
END
