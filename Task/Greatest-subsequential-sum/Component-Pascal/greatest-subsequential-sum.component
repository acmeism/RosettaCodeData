MODULE OvctGreatestSubsequentialSum;
IMPORT StdLog, Strings, Args;

PROCEDURE Gss(iseq: ARRAY OF INTEGER;OUT start, end, maxsum: INTEGER);
VAR
	i,j,sum: INTEGER;
BEGIN
	i := 0; maxsum := 0; start := 0; end := -1;
	WHILE i < LEN(iseq) - 1 DO
		sum := 0; j := i;
		WHILE j < LEN(iseq) -1 DO
			INC(sum ,iseq[j]);
			IF sum > maxsum THEN
				maxsum := sum;
				start := i;
				end := j
			END;
			INC(j);
		END;
		INC(i)
	END
END Gss;

PROCEDURE Do*;
VAR
	p: Args.Params;
	iseq: POINTER TO ARRAY OF INTEGER;
	i, res, start, end, sum: INTEGER;
BEGIN
	Args.Get(p); (* Get Params *)
	NEW(iseq,p.argc);
	(* Transform params to INTEGERs *)
	FOR i := 0 TO p.argc - 1 DO
		Strings.StringToInt(p.args[i],iseq[i],res)
	END;
	Gss(iseq,start,end,sum);
	StdLog.String("[");
	FOR i := start TO  end DO
		StdLog.Int(iseq[i]);
		IF i < end THEN StdLog.String(",") END
	END;
	StdLog.String("]=");StdLog.Int(sum);StdLog.Ln;
END Do;

END OvctGreatestSubsequentialSum.
