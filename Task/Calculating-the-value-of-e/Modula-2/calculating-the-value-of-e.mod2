MODULE CalculateE;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

CONST EPSILON = 1.0E-15;

PROCEDURE abs(n : REAL) : REAL;
BEGIN
    IF n < 0.0 THEN
        RETURN -n
    END;
    RETURN n
END abs;

VAR
    buf : ARRAY[0..31] OF CHAR;
    fact,n : LONGCARD;
    e,e0 : LONGREAL;
BEGIN
    fact := 1;
    e := 2.0;
    n := 2;

    REPEAT
        e0 := e;
        fact := fact * n;
        INC(n);
        e := e + 1.0 / LFLOAT(fact)
    UNTIL abs(e - e0) < EPSILON;

    WriteString("e = ");
    RealToStr(e, buf);
    WriteString(buf);
    WriteLn;

    ReadChar
END CalculateE.
