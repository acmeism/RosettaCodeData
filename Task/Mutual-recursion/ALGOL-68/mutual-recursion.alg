PROC (INT)INT m; # ONLY required for ELLA ALGOL 68RS - an official subset OF full ALGOL 68 #

PROC f = (INT n)INT:
  IF n = 0 THEN 1
  ELSE n - m(f(n-1)) FI;

m := (INT n)INT:
  IF n = 0 THEN 0
  ELSE n - f(m(n-1)) FI;

main:
(
  FOR i FROM 0 TO 19 DO
    print(whole(f(i),-3))
  OD;
  new line(stand out);
  FOR i FROM 0 TO 19 DO
    print(whole(m(i),-3))
  OD;
  new line(stand out)
)
