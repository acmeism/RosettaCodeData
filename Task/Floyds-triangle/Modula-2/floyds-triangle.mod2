MODULE FloydTriangle;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..9] OF CHAR;
BEGIN
    FormatString("%4i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE Print(r : INTEGER);
VAR n,i,limit : INTEGER;
BEGIN
    IF r<0 THEN RETURN END;

    n := 1;
    limit := 1;
    WHILE r#0 DO
        FOR i:=1 TO limit DO
            WriteInt(n);
            INC(n)
        END;
        WriteLn;

        DEC(r);
        INC(limit)
    END
END Print;

BEGIN
    Print(5);
    WriteLn;
    Print(14);

    ReadChar
END FloydTriangle.
