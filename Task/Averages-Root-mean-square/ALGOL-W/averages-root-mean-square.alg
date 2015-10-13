begin
    % computes the root-mean-square of an array of numbers with               %
    % the specified lower bound (lb) and upper bound (ub)                     %
    real procedure rms( real    array numbers ( * )
                      ; integer value lb
                      ; integer value ub
                      ) ;
        begin
            real sum;
            sum := 0;
            for i := lb until ub do sum := sum + ( numbers(i) * numbers(i) );
            sqrt( sum / ( ( ub - lb ) + 1 ) )
        end rms ;

    % test the rms procedure with the numbers 1 to 10                         %
    real array testNumbers( 1 :: 10 );
    for i := 1 until 10 do testNumbers(i) := i;
    r_format := "A"; r_w := 10; r_d := 4; % set fixed point output           %
    write( "rms of 1 .. 10: ", rms( testNumbers, 1, 10 ) );

end.
