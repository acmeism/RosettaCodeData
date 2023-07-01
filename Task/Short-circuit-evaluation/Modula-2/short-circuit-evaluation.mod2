MODULE ShortCircuit;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE a(v : BOOLEAN) : BOOLEAN;
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    FormatString("    # Called function a(%b)\n", buf, v);
    WriteString(buf);
    RETURN v
END a;

PROCEDURE b(v : BOOLEAN) : BOOLEAN;
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    FormatString("    # Called function b(%b)\n", buf, v);
    WriteString(buf);
    RETURN v
END b;

PROCEDURE Print(x,y : BOOLEAN);
VAR buf : ARRAY[0..63] OF CHAR;
VAR temp : BOOLEAN;
BEGIN
    FormatString("a(%b) AND b(%b)\n", buf, x, y);
    WriteString(buf);
    temp := a(x) AND b(y);

    FormatString("a(%b) OR b(%b)\n", buf, x, y);
    WriteString(buf);
    temp := a(x) OR b(y);

    WriteLn;
END Print;

BEGIN
    Print(FALSE,FALSE);
    Print(FALSE,TRUE);
    Print(TRUE,TRUE);
    Print(TRUE,FALSE);
    ReadChar
END ShortCircuit.
