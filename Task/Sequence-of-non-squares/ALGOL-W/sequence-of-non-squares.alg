begin
    % check values of the function: f(n) = n + floor(1/2 + sqrt(n))    %
    % are not squares                                                  %

    integer procedure f ( integer value n ) ;
        begin
            n + entier( 0.5 + sqrt( n ) )
        end f ;

    logical noSquares;

    % first 22 values of f                                             %
    for n := 1 until 22 do writeon( i_w := 1, f( n ) );

    % check f(n) does not produce a square for n in 1..1 000 000       %
    noSquares := true;
    for n := 1 until 1000000 do begin
        integer fn, rn;
        fn := f( n );
        rn := round( sqrt( fn ) );
        if ( rn * rn ) = fn then begin
            write( "Found square at: ", n );
            noSquares := false
        end if_fn_is_a_square
    end for_n ;

    if noSquares then write( "f(n) did not produce a square in 1 .. 1 000 000" )
                 else write( "f(n) produced a square" )

end.
