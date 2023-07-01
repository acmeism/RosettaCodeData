[]REAL data = (3, 1, 4, 1, 5, 9);

PROC map = ( PROC(REAL)REAL func, []REAL argv)REAL:
    ( REAL out:=0; FOR i FROM LWB argv TO UPB argv DO out:=func(argv[i]) OD; out);

test:(
  REAL sum := 0;
  printf(($xg(0)l$, map ( ((REAL argv)REAL: sum +:= argv ** 2), data) ));

  PRIO MAP = 5; # the same priority as the operators <, =<, >=, & > maybe... #
  OP MAP = ( PROC(REAL)REAL func, []REAL argv)REAL:
    ( REAL out:=0; FOR i FROM LWB argv TO UPB argv DO out:=func(argv[i]) OD; out);

  sum := 0;
  printf(($g(0)l$, ((REAL argv)REAL: sum +:= argv ** 2) MAP data ))
)
