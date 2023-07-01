LONG REAL sum, sum2;
INT n;

PROC sd = (LONG REAL x)LONG REAL:(
    sum  +:= x;
    sum2 +:= x*x;
    n    +:= 1;
    IF n = 0 THEN 0 ELSE long sqrt(sum2/n - sum*sum/n/n) FI
);

sum := sum2 := n := 0;
[]LONG REAL values = (2,4,4,4,5,5,7,9);
FOR i TO UPB values DO
    LONG REAL value = values[i];
    printf(($2(xg(0,6))l$, value, sd(value)))
OD
