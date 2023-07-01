[]UNION(CHAR,INT) x=("a","b","c"), y=("A","B","C"),
z=(1,2,3);
FOR i TO UPB x DO
  printf(($ggd$, x[i], y[i], z[i], $l$))
OD
