PROC between = (INT a, b)INT :
(
  ENTIER (random * ABS (b-a+1) + (a<b|a|b))
);

PROC knuth shuffle = (REF[]INT a)VOID:
(
  FOR i FROM LWB a TO UPB a DO
    INT j = between(LWB a, UPB a);
    INT t = a[i];
    a[i] := a[j];
    a[j] := t
  OD
);
# main # (
  [20]INT a;
  FOR i FROM 1 TO 20 DO a[i] := i OD;
  knuth shuffle(a);
  print((a, newline))
)
