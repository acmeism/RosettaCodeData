MODULE Pascal;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE PrintLine(n : INTEGER);
VAR
    buf : ARRAY[0..63] OF CHAR;
    m,j : INTEGER;
BEGIN
    IF n<1 THEN RETURN END;
    m := 1;
    WriteString("1 ");
    FOR j:=1 TO n-1 DO
        m := m * (n - j) DIV j;
        FormatString("%i ", buf, m);
        WriteString(buf)
    END;
    WriteLn
END PrintLine;

PROCEDURE Print(n : INTEGER);
VAR i : INTEGER;
BEGIN
    FOR i:=1 TO n DO
        PrintLine(i)
    END
END Print;

BEGIN
    Print(10);

    ReadChar
END Pascal.
