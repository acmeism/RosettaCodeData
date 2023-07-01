MODULE BabbageProblem;
IMPORT StdLog;

PROCEDURE Do*;
VAR
	i: LONGINT;
BEGIN
	i := 2;
	WHILE (i * i MOD 1000000) # 269696 DO
		IF i MOD 10 = 4 THEN INC(i,2) ELSE INC(i,8) END
	END;
	StdLog.Int(i)
END Do;

END BabbageProblem.
