MODULE Fizzbuzz;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE CB = PROCEDURE(INTEGER);

PROCEDURE Fizz(n : INTEGER);
BEGIN
    IF n MOD 3 = 0 THEN
        WriteString("Fizz");
        Buzz(n,Newline)
    ELSE
        Buzz(n,WriteInt)
    END
END Fizz;

PROCEDURE Buzz(n : INTEGER; f : CB);
BEGIN
    IF n MOD 5 = 0 THEN
        WriteString("Buzz");
        WriteLn
    ELSE
        f(n)
    END
END Buzz;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..9] OF CHAR;
BEGIN
    FormatString("%i\n", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE Newline(n : INTEGER);
BEGIN
    WriteLn
END Newline;

VAR i : INTEGER;
BEGIN
    FOR i:=1 TO 30 DO
        Fizz(i)
    END;

    ReadChar
END Fizzbuzz.
