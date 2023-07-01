PROC analytic fibonacci = (LONG INT n)LONG INT:(
  LONG REAL sqrt 5 = long sqrt(5);
  LONG REAL p = (1 + sqrt 5) / 2;
  LONG REAL q = 1/p;
  ROUND( (p**n + q**n) / sqrt 5 )
);

FOR i FROM 1 TO 30 WHILE
  print(whole(analytic fibonacci(i),0));
# WHILE # i /= 30 DO
  print(", ")
OD;
print(new line)
