PROC sum of squares = ([]REAL argv)REAL:(
  REAL sum := 0;
  FOR i FROM LWB argv TO UPB argv DO
    sum +:= argv[i]**2
  OD;
  sum
);
test:(
  printf(($g(0)l$,sum of squares([]REAL(3, 1, 4, 1, 5, 9))));
)
