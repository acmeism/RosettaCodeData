MODULE MDR;
IMPORT StdLog, Strings, TextMappers, DevCommanders;

PROCEDURE CalcMDR(x: LONGINT; OUT mdr, mp: LONGINT);
VAR
	str: ARRAY 64 OF CHAR;
	i: INTEGER;
BEGIN
	mdr := 1; mp := 0;
	LOOP
		Strings.IntToString(x,str);
		IF LEN(str$) = 1 THEN mdr := x; EXIT END;
		i := 0;mdr := 1;
		WHILE i < LEN(str$) DO
			mdr := mdr * (ORD(str[i]) - ORD('0'));
			INC(i)
		END;
		INC(mp);
		x := mdr
	END
END CalcMDR;

PROCEDURE Do*;
VAR
	mdr,mp: LONGINT;
	s: TextMappers.Scanner;
BEGIN
	s.ConnectTo(DevCommanders.par.text);
	s.SetPos(DevCommanders.par.beg);
	REPEAT
		s.Scan;
		IF (s.type = TextMappers.int) OR (s.type = TextMappers.lint) THEN
			CalcMDR(s.int,mdr,mp);
			StdLog.Int(s.int);
			StdLog.String(" MDR: ");StdLog.Int(mdr);
			StdLog.String(" MP: ");StdLog.Int(mp);StdLog.Ln
		END
	UNTIL s.rider.eot;
END Do;

PROCEDURE Show(i: INTEGER; x: ARRAY OF LONGINT);
VAR
	k: INTEGER;
BEGIN
	StdLog.Int(i);StdLog.String(": ");
	FOR k := 0 TO LEN(x) - 1 DO
		StdLog.Int(x[k])
	END;
	StdLog.Ln
END Show;

PROCEDURE FirstFive*;
VAR
	i,j: INTEGER;
	five: ARRAY 5 OF LONGINT;
	x,mdr,mp: LONGINT;
BEGIN
	FOR i := 0 TO 9 DO
		j := 0;x := 0;
		WHILE (j < LEN(five)) DO
			CalcMDR(x,mdr,mp);
			IF mdr = i THEN five[j] := x; INC(j) END;
			INC(x)
		END;
		Show(i,five)
	END
END FirstFive;

END MDR.
