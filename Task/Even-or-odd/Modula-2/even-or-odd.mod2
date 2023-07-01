MODULE EvenOrOdd;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i : INTEGER;
BEGIN
    FOR i:=-5 TO 5 DO
        FormatString("%i is even: %b\n", buf, i, i MOD 2 = 0);
        WriteString(buf)
    END;

    ReadChar
END EvenOrOdd.
