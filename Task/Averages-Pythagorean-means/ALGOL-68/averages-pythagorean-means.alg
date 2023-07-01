main: (
  INT count:=0;
  LONG REAL f, sum:=0, prod:=1, resum:=0;

  FORMAT real = $g(0,4)$; # preferred real format #

  FILE fbuf; STRING sbuf; associate(fbuf,sbuf);

  BOOL opts := TRUE;

  FOR i TO argc DO
    IF opts THEN # skip args up to the - token #
      opts := argv(i) NE "-"
    ELSE
      rewind(fbuf); sbuf := argv(i); get(fbuf,f);
      count +:= 1;
      sum +:= f;
      prod *:= f;
      resum +:= 1/f
    FI
  OD;
  printf(($"c: "f(real)l"s: "f(real)l"p: "f(real)l"r: "f(real)l$,count,sum,prod,resum));
  printf(($"Arithmetic mean = "f(real)l$,sum/count));
  printf(($"Geometric mean = "f(real)l$,prod**(1/count)));
  printf(($"Harmonic mean = "f(real)l$,count/resum))
)
