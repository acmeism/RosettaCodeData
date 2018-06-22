MODULE ReverseStr;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE ReverseStr(in : ARRAY OF CHAR; VAR out : ARRAY OF CHAR);
VAR ip,op : INTEGER;
BEGIN
    ip := 0;
    op := 0;
    WHILE in[ip] # 0C DO
        INC(ip)
    END;
    DEC(ip);
    WHILE ip>=0 DO
        out[op] := in[ip];
        INC(op);
        DEC(ip)
    END
END ReverseStr;

TYPE A = ARRAY[0..63] OF CHAR;
VAR is,os : A;
BEGIN
    is := "Hello World";
    ReverseStr(is, os);

    WriteString(is);
    WriteLn;
    WriteString(os);
    WriteLn;

    ReadChar
END ReverseStr.
