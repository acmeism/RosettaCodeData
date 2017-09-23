MODULE PascalTriangle;
IMPORT StdLog, DevCommanders, TextMappers;

TYPE
	Expansion* = POINTER TO ARRAY OF LONGINT;

PROCEDURE Show*(e: Expansion);
VAR
	i: INTEGER;
BEGIN
	i := 0;
	WHILE (i < LEN(e)) & (e[i] # 0) DO
		StdLog.Int(e[i]);
		INC(i)
	END;
	StdLog.Ln
END Show;

PROCEDURE GenFor*(p: LONGINT): Expansion;
VAR
	expA,expB: Expansion;
	i,j: LONGINT;
	
	PROCEDURE Swap(VAR x,y: Expansion);
	VAR
		swap: Expansion;
	BEGIN
		swap := x; x := y; y := swap
	END Swap;
	
BEGIN
	ASSERT(p >= 0);
	NEW(expA,p + 2);NEW(expB,p + 2);
	FOR i := 0 TO p DO
		IF i = 0 THEN expA[0] := 1
		ELSE
			FOR j := 0 TO i DO
				IF j = 0 THEN
					expB[j] := expA[j]
				ELSE
					expB[j] := expA[j - 1] + expA[j]
				END
			END;
			Swap(expA,expB)
		END;
	END;
	expB := NIL; (* for the GC *)
	RETURN expA
END GenFor;


PROCEDURE Do*;
VAR
	s: TextMappers.Scanner;
	exp: Expansion;
BEGIN
	s.ConnectTo(DevCommanders.par.text);
	s.SetPos(DevCommanders.par.beg);
	s.Scan;
	WHILE (~s.rider.eot) DO
		IF (s.type = TextMappers.char) & (s.char = '~') THEN
			RETURN
		ELSIF (s.type = TextMappers.int) THEN
			exp := GenFor(s.int);
			Show(exp)
		END;
		s.Scan
	END
END Do;

END PascalTriangle.
