PROC horner = ([]REAL c, REAL x)REAL :
(
  REAL res := 0.0;
  FOR i FROM UPB c BY -1 TO LWB c DO
    res := res * x + c[i]
  OD;
  res
);

main:(
  [4]REAL coeffs := (-19.0, 7.0, -4.0, 6.0);
  print( horner(coeffs, 3.0) )
)
