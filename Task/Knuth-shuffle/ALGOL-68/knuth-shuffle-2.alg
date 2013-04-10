main:(
  [20]INT a;
  FOR i FROM 1 TO 20 DO a[i] := i OD;
  knuth shuffle(a);
  print(a)
)
