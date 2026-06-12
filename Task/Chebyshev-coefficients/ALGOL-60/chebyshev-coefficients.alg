begin comment Chebyshev coefficients ;

    real PI;

    procedure chebyshevCoef( func, min, max, coef, N )
                           ; value min, max,       N
                           ; real procedure func
                           ; real           min, max
                           ; real     array coef
                           ; integer        N
                           ;
    begin
        real procedure map(       x, min x, max x, min to, max to )
                          ; value x, min x, max x, min to, max to
                          ; real  x, min x, max x, min to, max to
                          ;
        begin
            map := ( x - min x ) / ( max x - min x ) * ( max to - min to ) + min to
        end map ;

        integer i, j;
        for i := 0 step 1 until N - 1 do begin
            real m, f;
            m := map( cos( PI * ( i + 0.5 ) / N ), -1, 1, min, max );
            f := func( m ) * 2 / N;
            for j := 0 step 1 until N - 1 do begin
                coef[ j ] := coef[ j ] + f * cos( PI * j * ( i + 0.5 ) / N )
            end j
        end i
    end chebyshevCoef ;

    PI := arctan( 1 ) * 4;
    begin
        integer N;
        N := 10;
        begin
            real array c [ 0 : N - 1 ];
            integer i;
            chebyshevCoef( cos, 0, 1, c, N );
            outstring( 1, "Coefficients:\n" );
            for i := 0 step 1 until N - 1 do begin
                if c[ i ] >= 0 then outstring( 1, " " );
                outstring( 1, "  " );outreal( 1, c[ i ] );outstring( 1, "\n" )
            end i
        end
    end
end
