PROC is perfect = (INT candidate)BOOL: (
  INT sum :=1;
  FOR f1 FROM 2 TO ENTIER ( sqrt(candidate)*(1+2*small real) ) WHILE
    IF candidate MOD f1 = 0 THEN
      sum +:= f1;
      INT f2 = candidate OVER f1;
      IF f2 > f1 THEN
        sum +:= f2
      FI
    FI;
# WHILE # sum <= candidate DO
    SKIP
  OD;
  sum=candidate
);

test:(
  FOR i FROM 2 TO 33550336 DO
    IF is perfect(i) THEN print((i, new line)) FI
  OD
)
