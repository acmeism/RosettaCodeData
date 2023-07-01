begin
    % returns the arithmetic mean of the elements of n from lo to hi %
    real procedure arithmeticMean ( real array n ( * ); integer value lo, hi ) ;
    begin
        real sum;
        sum := 0;
        for i := lo until hi do sum := sum + n( i );
        sum / ( 1 + ( hi - lo ) )
    end arithmeticMean ;
    % returns the geometric mean of the elements of n from lo to hi %
    real procedure geometricMean ( real array n ( * ); integer value lo, hi ) ;
    begin
        real product;
        product := 1;
        for i := lo until hi do product := product * n( i );
        exp( ln( product ) / ( 1 + ( hi - lo ) ) )
    end geometricMean ;
    % returns the harminic mean of the elements of n from lo to hi %
    real procedure harmonicMean ( real array n ( * ); integer value lo, hi ) ;
    begin
        real sum;
        sum := 0;
        for i := lo until hi do sum := sum + ( 1 / n( i ) );
        ( 1 + ( hi - lo ) ) / sum
    end harmonicMean ;

    real array v ( 1 :: 10 );
    for i := 1 until 10 do v( i ) := i;

    r_w := 10; r_d := 5; r_format := "A"; s_w := 0; % set output format %

    write( "Arithmetic mean: ", arithmeticMean( v, 1, 10 ) );
    write( "Geometric  mean: ",  geometricMean( v, 1, 10 ) );
    write( "Harmonic   mean: ",   harmonicMean( v, 1, 10 ) )

end.
