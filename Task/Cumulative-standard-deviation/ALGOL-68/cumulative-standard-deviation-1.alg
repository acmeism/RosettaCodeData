MODE VALUE = STRUCT(CHAR value),
     STDDEV = STRUCT(CHAR stddev),
     MEAN = STRUCT(CHAR mean),
     VAR = STRUCT(CHAR var),
     COUNT = STRUCT(CHAR count),
     RESET = STRUCT(CHAR reset);

MODE ACTION = UNION ( VALUE, STDDEV, MEAN, VAR, COUNT, RESET );

LONG REAL sum := 0;
LONG REAL sum2 := 0;
INT num := 0;

PROC stat object = (LONG REAL v, ACTION action)LONG REAL:
(

  LONG REAL m;

  CASE action IN
  (VALUE):(
    num +:= 1;
    sum +:= v;
    sum2 +:= v*v;
    stat object(0, LOC STDDEV)
  ),
  (STDDEV):
    long sqrt(stat object(0, LOC VAR)),
  (MEAN):
    IF num>0 THEN sum/LONG REAL(num) ELSE 0 FI,
  (VAR):(
    m := stat object(0, LOC MEAN);
    IF num>0 THEN sum2/LONG REAL(num)-m*m ELSE 0 FI
  ),
  (COUNT):
    num,
  (RESET):
    sum := sum2 := num := 0
  ESAC
);

[]LONG REAL v = ( 2,4,4,4,5,5,7,9 );

main:
(
  LONG REAL sd;

  FOR i FROM LWB v TO UPB v DO
    sd := stat object(v[i], LOC VALUE);
    printf(($"value: "g(0,6)," standard dev := "g(0,6)l$, v[i], sd))
  OD

)
