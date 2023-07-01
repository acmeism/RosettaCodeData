MODULE DotProduct;
IMPORT StdLog;
	
PROCEDURE Calculate*(x,y: ARRAY OF INTEGER): INTEGER;
VAR
	i,sum: INTEGER;
BEGIN
	sum := 0;
	FOR i:= 0 TO LEN(x) - 1 DO
		INC(sum,x[i] * y[i]);
	END;
	RETURN sum
END Calculate;

PROCEDURE Test*;
VAR
	i,sum: INTEGER;
	v1,v2: ARRAY 3 OF INTEGER;
BEGIN
	v1[0] := 1;v1[1] := 3;v1[2] := -5;
	v2[0] := 4;v2[1] := -2;v2[2] := -1;
	
	StdLog.Int(Calculate(v1,v2));StdLog.Ln
END Test;

END DotProduct.
