begin % Euler's method %
    % Approximates y(t) in y'(t)=f(t,y) with y(a)=y0 and t=a..b and the step size h. %
    real procedure euler ( real procedure f; real value y0, a, b, h ) ;
    begin
        real y, t;
        y := y0;
        t := a;
        while t < b do begin
            write( r_format := "A", r_w := 8, r_d := 4, s_w := 0, t, ": ", y );
            y := y + ( h * f(t, y) );
            t := t + h
        end while_t_lt_b ;
        write( "done" );
        y
    end euler ;

    % Example: Newton's cooling law %
    real procedure newtonCoolingLaw ( real value time, t ) ; -0.07 * (t - 20);

    euler( newtonCoolingLaw, 100, 0, 100, 10 )
end.
