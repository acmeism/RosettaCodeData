MODULE Arithmetic;
IMPORT StdLog,DevCommanders,TextMappers;

PROCEDURE DoArithmetic(x,y: INTEGER);
BEGIN
        StdLog.String("x + y >");StdLog.Int(x + y);StdLog.Ln;
        StdLog.String("x - y >");StdLog.Int(x - y);StdLog.Ln;
        StdLog.String("x * y >");StdLog.Int(x * y);StdLog.Ln;
        StdLog.String("x / y >");StdLog.Int(x DIV y);StdLog.Ln;
        StdLog.String("x MOD y >");StdLog.Int(x MOD y);StdLog.Ln;
END DoArithmetic;

PROCEDURE Go*;
VAR
                params: DevCommanders.Par;
                s: TextMappers.Scanner;
                p : ARRAY 2 OF INTEGER;
                current: INTEGER;
BEGIN
        current := 0;
        params := DevCommanders.par;
        s.ConnectTo(params.text);
        s.SetPos(params.beg);
        s.Scan;
        WHILE(~s.rider.eot) DO
                IF (s.type = TextMappers.int) THEN
                        p[current] := s.int; INC(current);
                END;
                s.Scan;
        END;
        IF current = 2 THEN DoArithmetic(p[0],p[1]) END;
END Go;
END Arithmetic.
