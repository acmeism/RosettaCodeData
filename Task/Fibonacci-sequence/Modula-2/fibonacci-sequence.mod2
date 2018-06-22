MODULE Fibonacci;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Fibonacci(n : LONGINT) : LONGINT;
VAR
    a,b,c : LONGINT;
BEGIN
    IF n<0 THEN RETURN 0 END;

    a:=1;
    b:=1;

    WHILE n>0 DO
        c := a + b;
        a := b;
        b := c;
        DEC(n)
    END;

    RETURN a
END Fibonacci;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i : INTEGER;
    r : LONGINT;
BEGIN
    FOR i:=0 TO 10 DO
        r := Fibonacci(i);

        FormatString("%l\n", buf, r);
        WriteString(buf);
    END;

    ReadChar
END Fibonacci.
