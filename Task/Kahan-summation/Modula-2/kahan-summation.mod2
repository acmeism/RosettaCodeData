MODULE KahanSummation;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteReal(num : REAL);
VAR
    buf : ARRAY[0..64] OF CHAR;
BEGIN
    RealToStr(num,buf);
    WriteString(buf);
END WriteReal;

PROCEDURE KahanSum(fa : ARRAY OF REAL) : REAL;
VAR
    sum,c,y,t : REAL;
    i : CARDINAL;
    buf : ARRAY[0..64] OF CHAR;
BEGIN
    sum := 0.0;
    c := 0.0;
    FOR i:=0 TO HIGH(fa) DO
        y := fa[i] - c;
        t := sum + y;
        c := (t - sum) - y;
        sum := t;
    END;
    RETURN sum;
END KahanSum;

PROCEDURE Epsilon() : REAL;
VAR
    eps : REAL;
BEGIN
    eps := 1.0;
    WHILE 1.0 + eps # 1.0 DO
        eps := eps / 2.0;
    END;
    RETURN eps;
END Epsilon;

VAR
    fa : ARRAY[0..2] OF REAL;
    a,b,c : REAL;
BEGIN
    a := 1.0;
    b := Epsilon();
    c := -b;
    WriteString("Epsilon      = ");
    WriteReal(b);
    WriteLn;
    WriteString("(a + b) + c  = ");
    WriteReal((a + b) + c);
    WriteLn;

    fa[0] := a;
    fa[1] := b;
    fa[2] := c;
    WriteString("Kahan sum    = ");
    WriteReal(KahanSum(fa));
    WriteLn;

    ReadChar;
END KahanSummation.
