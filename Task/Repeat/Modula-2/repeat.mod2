MODULE Repeat;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE F = PROCEDURE;

PROCEDURE Repeat(fun : F; c : INTEGER);
VAR i : INTEGER;
BEGIN
    FOR i:=1 TO c DO
        fun
    END
END Repeat;

PROCEDURE Print;
BEGIN
    WriteString("Hello");
    WriteLn
END Print;

BEGIN
    Repeat(Print, 3);

    ReadChar
END Repeat.
