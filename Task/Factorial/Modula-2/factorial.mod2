MODULE Factorial;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE Factorial(n : CARDINAL) : CARDINAL;
VAR result : CARDINAL;
BEGIN
    result := 1;
    WHILE n#0 DO
        result := result * n;
        DEC(n)
    END;
    RETURN result
END Factorial;

VAR
    buf : ARRAY[0..63] OF CHAR;
    n : CARDINAL;
BEGIN
    FOR n:=0 TO 10 DO
        FormatString("%2c! = %7c\n", buf, n, Factorial(n));
        WriteString(buf)
    END;

    ReadChar
END Factorial.
