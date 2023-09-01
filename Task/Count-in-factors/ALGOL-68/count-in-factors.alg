OP +:= = (REF FLEX []INT a, INT b) VOID:
   BEGIN
      [UPB a + 1] INT c;
      c[:UPB a] := a;
      c[UPB a+1:] := b;
      a := c
   END;


PROC factorize = (INT nn) []INT:
   BEGIN
      IF nn = 1 THEN (1)
      ELSE
	  INT k := 2, n := nn;
	  FLEX[0]INT result;
	  WHILE n > 1 DO
	      WHILE n MOD k = 0 DO
		  result +:= k;
		  n := n % k
	      OD;
	      k +:= 1
	  OD;
	  result
      FI
   END;

FLEX[0]INT factors;
FOR i TO 22 DO
    factors := factorize (i);
    print ((whole (i, 0), " = "));
    FOR j TO UPB factors DO
       (j /= 1 | print (" × "));
	print ((whole (factors[j], 0)))
    OD;
    print ((new line))
OD
