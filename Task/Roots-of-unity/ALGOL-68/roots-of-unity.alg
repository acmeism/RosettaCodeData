FORMAT complex fmt=$g(-6,4)"⊥"g(-6,4)$;
FOR root FROM 2 TO 10 DO
  printf(($g(4)$,root));
  FOR n FROM 0 TO root-1 DO
    printf(($xf(complex fmt)$,complex exp( 0 I 2*pi*n/root)))
  OD;
  printf($l$)
OD
