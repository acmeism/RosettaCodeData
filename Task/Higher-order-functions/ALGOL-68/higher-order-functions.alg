PROC first = (PROC(LONG REAL)LONG REAL f) LONG REAL:
(
  f(1) + 2
);

PROC second = (LONG REAL x)LONG REAL:
(
  x/2
);

main: (
  printf(($xg(5,2)l$,first(second)))
)
