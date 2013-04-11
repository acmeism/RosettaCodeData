MODE F = PROC(LONG REAL)LONG REAL;

###############
## left rect ##
###############

PROC left rect = (F f, LONG REAL a, b, INT n) LONG REAL:
BEGIN
   LONG REAL h= (b - a) / n;
   LONG REAL sum:= 0;
   LONG REAL x:= a;
   WHILE x <= b - h DO
      sum := sum + (h * f(x));
      x +:= h
   OD;
   sum
END # left rect #;

#################
## right rect  ##
#################

PROC right rect = (F f, LONG REAL a, b, INT n) LONG REAL:
BEGIN
   LONG REAL h= (b - a) / n;
   LONG REAL sum:= 0;
   LONG REAL x:= a + h;
   WHILE x <= b DO
      sum := sum + (h * f(x));
      x +:= h
   OD;
   sum
END # right rect #;

###############
## mid rect  ##
###############

PROC mid rect = (F f, LONG REAL a, b, INT n) LONG REAL:
BEGIN
   LONG REAL h= (b - a) / n;
   LONG REAL sum:= 0;
   LONG REAL x:= a;
   WHILE x <= b - h DO
      sum := sum + h * f(x + h / 2);
      x +:= h
   OD;
   sum
END # mid rect #;

###############
## trapezium ##
###############

PROC trapezium = (F f, LONG REAL a, b, INT n) LONG REAL:
BEGIN
   LONG REAL h= (b - a) / n;
   LONG REAL sum:= f(a) + f(b);
   LONG REAL x:= 1;
   WHILE x <= n - 1 DO
      sum := sum + 2 * f(a + x * h );
      x +:= 1
   OD;
   (b - a) / (2 * n) * sum
END # trapezium #;

#############
## simpson ##
#############

PROC simpson = (F f, LONG REAL a, b, INT n) LONG REAL:
BEGIN
   LONG REAL h= (b - a) / n;
   LONG REAL sum1:= 0;
   LONG REAL sum2:= 0;
   INT limit:= n - 1;
   FOR i FROM 0 TO limit DO
      sum1 := sum1 + f(a + h * LONG REAL(i) + h / 2)
   OD;
   FOR i FROM 1 TO limit DO
      sum2 +:= f(a + h * LONG REAL(i))
   OD;
   h / 6 * (f(a) + f(b) + 4 * sum1 + 2 * sum2)
END # simpson #;
SKIP
