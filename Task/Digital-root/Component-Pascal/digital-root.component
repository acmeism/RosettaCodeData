MODULE DigitalRoot;
IMPORT StdLog, Strings, TextMappers, DevCommanders;

PROCEDURE CalcDigitalRoot(x: LONGINT; OUT dr,pers: LONGINT);
VAR
	str: ARRAY 64 OF CHAR;
	i: INTEGER;
BEGIN
	dr := 0;pers := 0;
	LOOP
		Strings.IntToString(x,str);
		IF LEN(str$) = 1 THEN dr := x ;EXIT END;
		i := 0;dr := 0;
		WHILE (i < LEN(str$)) DO
			INC(dr,ORD(str[i]) - ORD('0'));
			INC(i)
		END;
		INC(pers);
		x := dr
	END;
END CalcDigitalRoot;

PROCEDURE Do*;
VAR
	dr,pers: LONGINT;
	s: TextMappers.Scanner;
BEGIN
	s.ConnectTo(DevCommanders.par.text);
	s.SetPos(DevCommanders.par.beg);
	REPEAT
		s.Scan;
		IF (s.type = TextMappers.int) OR (s.type = TextMappers.lint) THEN
			CalcDigitalRoot(s.int,dr,pers);
			StdLog.Int(s.int);
			StdLog.String(" Digital root: ");StdLog.Int(dr);
			StdLog.String(" Persistence: ");StdLog.Int(pers);StdLog.Ln
		END
	UNTIL s.rider.eot;
END Do;
END DigitalRoot.
