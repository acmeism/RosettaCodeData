begin % Chebyshev coefficients %

    procedure chebyshevCoef ( real procedure func
                            ; real     value min, max
                            ; real     array coef     ( * )
                            ; integer  value N
                            ) ;
    begin
        real procedure map  ( real value x, min_x, max_x, min_to, max_to ) ;
             ( x - min_x ) / ( max_x - min_x ) * ( max_to - min_to ) + min_to;

        for i := 0 until N - 1 do begin
            real m, f;
            m := map( cos( PI * ( i + 0.5 ) / N ), -1, 1, min, max );
            f := func( m ) * 2 / N;
            for j := 0 until N - 1 do begin
                coef( j ) := coef( j ) + f * cos( PI * j * ( i + 0.5 ) / N )
            end for_j
        end for_i
    end chebyshevCoef ;

    begin
        integer N;
        N := 10;
        begin
            real array c ( 0 :: N - 1 );
            chebyshevCoef( cos, 0, 1, c, N );
            write( "Coefficients:" );
            for i := 0 until N - 1 do write( r_format := "S", r_w := 14, c( i ) )
        end
    end
end.
