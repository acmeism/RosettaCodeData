BEGIN
   PROC rk4 = (PROC (REAL, REAL) REAL f, REAL y, x, dx) REAL :
   BEGIN  CO Fourth-order Runge-Kutta method CO
      REAL dy1 = dx * f(x, y);
      REAL dy2 = dx * f(x + dx / 2.0, y + dy1 / 2.0);
      REAL dy3 = dx * f(x + dx / 2.0, y + dy2 / 2.0);
      REAL dy4 = dx * f(x + dx, y + dy3);
      y + (dy1 + 2.0 * dy2 + 2.0 * dy3 + dy4) / 6.0
   END;
   REAL x0 = 0, x1 = 10, y0 = 1.0;			CO Boundary conditions. CO
   REAL dx = 0.1;					CO Step size. CO
   INT num points = ENTIER ((x1 - x0) / dx + 0.5);	CO Add 0.5 for rounding errors. CO
   [0:num points]REAL y;   y[0] := y0;			CO Grid and starting point.CO
   PROC dy by dx = (REAL x, y) REAL : x * sqrt(y);	CO Differential equation. CO
   FOR i TO num points
   DO
      y[i] := rk4 (dy by dx, y[i-1], x0 + dx * (i - 1), dx)
   OD;
   print (("   x              true y         calc y       relative error", newline));
   FOR i FROM 0 BY 10 TO  num points
   DO
      REAL x = x0 + dx * i;
      REAL true y = (x * x + 4.0) ^ 2 / 16.0;
      printf (($3(-zzd.7dxxx), -d.4de-ddl$, x, true y, y[i], y[i] / true y - 1.0))
   OD
END
