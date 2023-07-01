PRIO MINLWB = 8, MAXUPB = 8;
OP MINLWB = ([]INT a,b)INT: (LWB a<LWB b|LWB a|LWB b),
   MAXUPB = ([]INT a,b)INT: (UPB a>UPB b|UPB a|UPB b);

OP + = ([]INT a,b)[]INT:(
  [a MINLWB b:a MAXUPB b]INT out; FOR i FROM LWB out TO UPB out DO out[i]:= 0 OD;
  out[LWB a:UPB a] := a; FOR i FROM LWB b TO UPB b DO out[i]+:= b[i] OD;
  out
);

INT width = 4, stop = 9;
FORMAT centre = $n((stop-UPB row+1)*width OVER 2)(q)$;

FLEX[1]INT row := 1; # example of rowing #
FOR i WHILE
  printf((centre, $g(-width)$, row, $l$));
# WHILE # i < stop DO
  row := row[AT 1] + row[AT 2]
OD
