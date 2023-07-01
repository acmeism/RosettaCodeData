MODULE ProperDivisors;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE proper_divisors(n : INTEGER; print_flag : BOOLEAN) : INTEGER;
VAR count,i : INTEGER;
BEGIN
    count := 0;
    FOR i:=1 TO n-1 DO
        IF n MOD i = 0 THEN
            INC(count);
            IF print_flag THEN
                WriteInt(i);
                WriteString(" ")
            END
        END
    END;
    IF print_flag THEN WriteLn END;
    RETURN count;
END proper_divisors;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i,max,max_i,v : INTEGER;
BEGIN
    FOR i:=1 TO 10 DO
        WriteInt(i);
        WriteString(": ");
        proper_divisors(i, TRUE)
    END;

    max := 0;
    max_i := 1;

    FOR i:=1 TO 20000 DO
        v := proper_divisors(i, FALSE);
        IF v>= max THEN
            max := v;
            max_i := i
        END
    END;

    FormatString("%i with %i divisors\n", buf, max_i, max);
    WriteString(buf);

    ReadChar
END ProperDivisors.
