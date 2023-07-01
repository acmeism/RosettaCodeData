begin
    real procedure rk4 ( real procedure f ; real value y, x, dx ) ;
    begin  % Fourth-order Runge-Kutta method %
       real dy1, dy2, dy3, dy4;
       dy1 := dx * f(x, y);
       dy2 := dx * f(x + dx / 2.0, y + dy1 / 2.0);
       dy3 := dx * f(x + dx / 2.0, y + dy2 / 2.0);
       dy4 := dx * f(x + dx, y + dy3);
       y + (dy1 + 2.0 * dy2 + 2.0 * dy3 + dy4) / 6.0
    end rk4;
    real x0, x1, y0, dx;
    integer numPoints;
    x0 := 0; x1 := 10; y0 := 1.0;                                % Boundary conditions. %
    dx := 0.1;                                                   % Step size. %
    numPoints := entier ((x1 - x0) / dx + 0.5);                  % Add 0.5 for rounding errors. %
    begin
        real procedure dyByDx ( real value x, y ) ; x * sqrt(y); % Differential equation. %
        real array y ( 0 :: numPoints); y(0) := y0;              % Grid and starting point. %
        for i := 1 until numPoints do y(i) := rk4 (dyByDx, y(i-1), x0 + dx * (i - 1), dx);
        write( "   x              true y         calc y       relative error" );
        for i := 0 step 10 until numPoints do begin
            real x, trueY;
            x     := x0 + dx * i;
            trueY := (x * x + 4.0) ** 2 / 16.0;
            write( r_format := "A", r_w := 12, r_d := 7, s_w := 3, x, trueY, y( i )
                 , r_format := "S", r_w := 12, y( i ) / trueY - 1
                 )
        end for_i
    end
end.
