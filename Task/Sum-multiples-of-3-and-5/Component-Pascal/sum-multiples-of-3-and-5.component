MODULE Sum3_5;
IMPORT StdLog, Strings, Args;

PROCEDURE DoSum(n: INTEGER):INTEGER;
VAR
	i,sum: INTEGER;
BEGIN
	sum := 0;i := 0;
	WHILE (i < n) DO
		IF  (i MOD 3 = 0) OR (i MOD 5 = 0) THEN INC(sum,i) END;
		INC(i)
	END;
	RETURN sum
END DoSum;

PROCEDURE Compute*;
VAR
	params: Args.Params;
	i,n,res: INTEGER;
BEGIN
	Args.Get(params);
	Strings.StringToInt(params.args[0],n,res);
	StdLog.String("Sum: ");StdLog.Int(DoSum(n)); StdLog.Ln
END Compute;

END Sum3_5.
