MODULE RosettaProperDivisor;
IMPORT StdLog;

PROCEDURE Pd*(n: LONGINT;OUT r: ARRAY OF LONGINT):LONGINT;
VAR
	i,j: LONGINT;
BEGIN
	i := 1;j := 0;
	IF n >  1 THEN
		WHILE (i < n) DO
			IF (n MOD i) = 0 THEN
				IF (j < LEN(r)) THEN r[j] := i END; INC(j)
			END;
			INC(i)
		END;
	END;
	RETURN j
END Pd;

PROCEDURE Do*;
VAR
	r: ARRAY 128 OF LONGINT;
	i,j,found,max,idxMx: LONGINT;
	mx: ARRAY 128 OF LONGINT;
BEGIN
	FOR i := 1 TO 10 DO
		found := Pd(i,r);
		IF found > LEN(r) THEN (* Error. more pd than r can admit *) HALT(1) END;
		StdLog.Int(i);StdLog.String("[");StdLog.Int(found);StdLog.String("]:> ");
		FOR j := 0 TO found - 1 DO
			StdLog.Int(r[j]);StdLog.Char(' ');
		END;
		StdLog.Ln
	END;
	
	max := 0;idxMx := 0;
  FOR i := 1 TO 20000 DO
  	found := Pd(i,r);
  	IF found > max THEN
    	idxMx:= 0;mx[idxMx] := i;max := found
	  ELSIF found = max THEN
    	INC(idxMx);mx[idxMx] := i
  	END;
  END;
	StdLog.String("Found: ");StdLog.Int(idxMx + 1);
  StdLog.String(" Numbers with the longest proper divisors [");
	StdLog.Int(max);StdLog.String("]: ");StdLog.Ln;
	FOR i := 0 TO idxMx DO
  	StdLog.Int(mx[i]);StdLog.Ln
	END
END Do;

END RosettaProperDivisor.

^Q RosettaProperDivisor.Do~
