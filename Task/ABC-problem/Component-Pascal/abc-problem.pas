MODULE ABCProblem;
IMPORT
	StdLog, DevCommanders, TextMappers;
CONST
	notfound = -1;
TYPE	
	String = ARRAY 3 OF CHAR;
VAR
	blocks : ARRAY 20 OF String;
	
PROCEDURE Check(s: ARRAY OF CHAR): BOOLEAN;
VAR
	used: SET;
	i,blockIndex: INTEGER;
	
	PROCEDURE GetBlockFor(c: CHAR): INTEGER;
	VAR
		i: INTEGER;
	BEGIN
		c := CAP(c);
		i := 0;
		WHILE (i < LEN(blocks)) DO
			IF (c = blocks[i][0]) OR (c = blocks[i][1]) THEN
				IF ~(i IN used) THEN RETURN i END
			END;
			INC(i)
		END;
		RETURN notfound
	END GetBlockFor;
	
BEGIN
	used := {};
	FOR i := 0 TO LEN(s$) - 1 DO
		blockIndex := GetBlockFor(s[i]);
		IF blockIndex = notfound THEN
			RETURN FALSE
		ELSE
			INCL(used,blockIndex)
		END
	END;
	RETURN TRUE
END Check;	

PROCEDURE CanMakeWord*;
VAR
	s: TextMappers.Scanner;
BEGIN
	s.ConnectTo(DevCommanders.par.text);
	s.SetPos(DevCommanders.par.beg);
	s.Scan;
	WHILE (~s.rider.eot) DO
		IF (s.type = TextMappers.char) & (s.char = '~') THEN
			RETURN
		ELSIF (s.type = TextMappers.string) THEN
			StdLog.String(s.string);StdLog.String(":> ");
			StdLog.Bool(Check(s.string));StdLog.Ln
		END;
		s.Scan
	END
END CanMakeWord;

BEGIN
	blocks[0] := "BO";
	blocks[1] := "XK";
	blocks[2] := "DQ";
	blocks[3] := "CP";
	blocks[4] := "NA";
	blocks[5] := "GT";
	blocks[6] := "RE";
	blocks[7] := "TG";
	blocks[8] := "QD";
	blocks[9] := "FS";
	blocks[10] := "JW";
	blocks[11] := "HU";
	blocks[12] := "VI";
	blocks[13] := "AN";
	blocks[14] := "OB";
	blocks[15] := "ER";
	blocks[16] := "FS";
	blocks[17] := "LY";
	blocks[18] := "PC";
	blocks[19] := "ZM";
	
END ABCProblem.
