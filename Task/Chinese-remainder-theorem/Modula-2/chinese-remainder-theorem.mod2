MODULE CRT;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE MulInv(a,b : INTEGER) : INTEGER;
VAR
    b0,x0,x1,q,amb,xqx : INTEGER;
BEGIN
    b0 := b;
    x0 := 0;
    x1 := 1;

    IF b=1 THEN
        RETURN 1
    END;

    WHILE a>1 DO
        q := a DIV b;
        amb := a MOD b;
        a := b;
        b := amb;
        xqx := x1 - q * x0;
        x1 := x0;
        x0 := xqx
    END;

    IF x1<0 THEN
        x1 := x1 + b0
    END;

    RETURN x1
END MulInv;

PROCEDURE ChineseRemainder(n,a : ARRAY OF INTEGER) : INTEGER;
VAR
    i : CARDINAL;
    prod,p,sm : INTEGER;
BEGIN
    prod := n[0];
    FOR i:=1 TO HIGH(n) DO
        prod := prod * n[i]
    END;

    sm := 0;
    FOR i:=0 TO HIGH(n) DO
        p := prod DIV n[i];
        sm := sm + a[i] * MulInv(p, n[i]) * p
    END;

    RETURN sm MOD prod
END ChineseRemainder;

TYPE TA = ARRAY[0..2] OF INTEGER;
VAR n,a : TA;
BEGIN
    n := TA{3, 5, 7};
    a := TA{2, 3, 2};
    WriteInt(ChineseRemainder(n, a));
    WriteLn;

    ReadChar
END CRT.
