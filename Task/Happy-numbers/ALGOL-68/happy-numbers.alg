INT base10 = 10, num happy = 8;

PROC next = (INT in n)INT: (
  INT n := in n;
  INT out := 0;
  WHILE n NE 0 DO
    out +:= ( n MOD base10 ) ** 2;
    n := n OVER base10
  OD;
  out
);

PROC is happy = (INT in n)BOOL: (
  INT n := in n;
  FOR i WHILE n NE 1 AND n NE 4 DO n := next(n) OD;
  n=1
);

INT count := 0;
FOR i WHILE count NE num happy DO
  IF is happy(i) THEN
    count +:= 1;
    print((i, new line))
  FI
OD
