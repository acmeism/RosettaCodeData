MODULE Sequence;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i : CARDINAL;
BEGIN
    i := 1;
    WHILE i>0 DO
        FormatString("%c ", buf, i);
        WriteString(buf);
        INC(i)
    END;
    ReadChar
END Sequence.
