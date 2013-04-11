main:(
  MODE LISTREAL = [1:0]REAL;

  OP - = (LISTREAL a,b)LISTREAL: (
    [UPB a]REAL out;
    FOR i TO UPB out DO out[i]:=a[i]-b[i] OD;
    out
  );

  FORMAT real fmt=$zzz-d.d$;
  FORMAT repeat fmt = $n(UPB s-1)(f(real fmt)",")f(real fmt)$;
  FORMAT list fmt = $"("f(UPB s=1|real fmt|repeat fmt)")"$;

  FLEX [1:0] REAL s := (90, 47, 58, 29, 22, 32, 55, 5, 55, 73);

  printf((list fmt,s,$";"l$));
  TO UPB s-1 DO
    s := s[2:] - s[:UPB s-1];
    printf((list fmt,s,$";"l$))
  OD
)
