MODE RANGE = STRUCT(INT lwb, upb);

PROC sum = (PROC (INT)LONG REAL f, RANGE range)LONG REAL:(
  LONG REAL sum := LENG 0.0;
  FOR i FROM lwb OF range TO upb OF range DO
     sum := sum + f(i)
  OD;
  sum
);

test:(
  RANGE range = (1,100);
  PROC f = (INT x)LONG REAL: LENG REAL(1) / LENG REAL(x)**2;
  print(("Sum of f(x) from", lwb OF range, " to ",upb OF range," is ", SHORTEN sum(f,range),".", new line))
)
