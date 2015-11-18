begin
    % computes factorial n iteratively                                       %
    integer procedure factorial( integer value n ) ;
        if n < 2
        then 1
        else begin
            integer f;
            f := 2;
            for i := 3 until n do f := f * i;
            f
        end factorial ;

    for t := 0 until 10 do write( "factorial: ", t, factorial( t ) );

end.
