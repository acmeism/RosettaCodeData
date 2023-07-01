PROC mean = (REF[]REAL p)REAL:
# Calculates the mean of qty REALs beginning at p. #
  IF LWB p > UPB p THEN 0.0
  ELSE
    REAL total := 0.0;
    FOR i FROM LWB p TO UPB p DO total +:= p[i] OD;
    total / (UPB p - LWB p + 1)
  FI;

main:(
  [6]REAL test := (1.0, 2.0, 5.0, -5.0, 9.5, 3.14159);
  print((mean(test),new line))
)
