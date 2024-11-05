MODE RANGE = STRUCT(INT lwb, upb);

PROC sum = (PROC (INT)LONG REAL f, RANGE range)LONG REAL:(
  LONG REAL ssum := LENG 0.0;
  FOR i FROM lwb OF range TO upb OF range DO
     ssum +:= f(i)
  OD;
  ssum
);

# test # (
  RANGE range = (1,1000);
  PROC f = (INT x)LONG REAL: LENG REAL(1) / LENG REAL(x)**2;
  print(("Sum of f(x) from ", whole(lwb OF range, 0), " to "));
  print((whole(upb OF range, 0)," is ", fixed(SHORTEN sum(f,range),-8,5),".", new line))
)
