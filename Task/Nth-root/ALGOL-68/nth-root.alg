REAL default p = 0.001;

PROC nth root = (INT n, LONG REAL a, p)LONG REAL:
(
  [2]LONG REAL x := (a, a/n);

  WHILE ABS(x[2] - x[1]) > p DO
    x := (x[2], ((n-1)*x[2] + a/x[2]**(n-1))/n )
  OD;
  x[2]
);

PRIO ROOT = 8;
OP ROOT = (INT n, LONG REAL a)LONG REAL: nth root(n, a, default p);
OP ROOT = (INT n, INT a)LONG REAL: nth root(n, a, default p);

main:
(
  printf(($2(" "gl)$,
         nth root(10, LONG 7131.5 ** 10, default p),
         nth root(5, 34, default p)));
  printf(($2(" "gl)$,
         10 ROOT ( LONG 7131.5 ** 10 ),
         5 ROOT 34))
)
