MODULE AryLen;
IMPORT StdLog;

TYPE
	String = POINTER TO ARRAY OF CHAR;
VAR
	a: ARRAY 16 OF String;
	
PROCEDURE NewString(s: ARRAY OF CHAR): String;
VAR
	str: String;
BEGIN
	NEW(str,LEN(s$) + 1);str^ := s$; RETURN str
END NewString;

PROCEDURE Length(a: ARRAY OF String): INTEGER;
VAR
	i: INTEGER;
BEGIN
	i := 0;
	WHILE a[i] # NIL DO INC(i) END;
	RETURN i
END Length;

PROCEDURE Do*;
BEGIN
	a[0] := NewString("Apple");
	a[1] := NewString("Orange");
	StdLog.String("Length:> ");StdLog.Int(Length(a));StdLog.Ln
END Do;

END AryLen.
