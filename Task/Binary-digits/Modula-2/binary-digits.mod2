MODULE Binary;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT Write,WriteLn,ReadChar;

PROCEDURE PrintByte(b : INTEGER);
VAR v : INTEGER;
BEGIN
    v := 080H;
    WHILE v#0 DO
        IF (b BAND v) # 0 THEN
            Write('1')
        ELSE
            Write('0')
        END;
        v := v SHR 1
    END
END PrintByte;

VAR
    buf : ARRAY[0..15] OF CHAR;
    i : INTEGER;
BEGIN
    FOR i:=0 TO 15 DO
        PrintByte(i);
        WriteLn
    END;

    ReadChar
END Binary.
