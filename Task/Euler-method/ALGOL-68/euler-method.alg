#
Approximates y(t) in y'(t)=f(t,y) with y(a)=y0 and
t=a..b and the step size h.
#
PROC euler = (PROC(REAL,REAL)REAL f, REAL y0, a, b, h)REAL: (
    REAL y := y0,
         t := a;
    WHILE t < b DO
      printf(($g(-6,3)": "g(-7,3)l$, t, y));
      y +:= h * f(t, y);
      t +:= h
    OD;
    printf($"done"l$);
    y
);

# Example: Newton's cooling law #
PROC newton cooling law = (REAL time, t)REAL: (
    -0.07 * (t - 20)
);

main: (
   euler(newton cooling law, 100, 0, 100,  10)
)
