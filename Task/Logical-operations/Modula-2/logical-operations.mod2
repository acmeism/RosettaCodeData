MODULE LogicalOps;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Print(a,b : BOOLEAN);
VAR buf : ARRAY[0..31] OF CHAR;
BEGIN
    FormatString("a and b is %b\n", buf, a AND b);
    WriteString(buf);
    FormatString("a or b is %b\n", buf, a OR b);
    WriteString(buf);
    FormatString("not a is %b\n", buf, NOT a);
    WriteString(buf);
    WriteLn
END Print;

BEGIN
    Print(FALSE, FALSE);
    Print(FALSE, TRUE);
    Print(TRUE, TRUE);
    Print(TRUE, FALSE);

    ReadChar
END LogicalOps.
