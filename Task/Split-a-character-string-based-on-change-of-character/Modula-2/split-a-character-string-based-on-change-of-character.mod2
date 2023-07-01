MODULE CharacterChange;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;

PROCEDURE Split(str : ARRAY OF CHAR);
VAR
    i : CARDINAL;
    c : CHAR;
BEGIN
    FOR i:=0 TO HIGH(str) DO
        IF i=0 THEN
            c := str[i]
        ELSIF str[i]#c THEN
            c := str[i];
            WriteLn;
        END;
        Write(c)
    END
END Split;

CONST EX = "gHHH5YY++///\";
BEGIN
    Split(EX);

    ReadChar
END CharacterChange.
