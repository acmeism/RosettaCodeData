MODULE Pernicious;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE IsPrime(x : LONGINT) : BOOLEAN;
VAR i : LONGINT;
BEGIN
    IF x<2 THEN RETURN FALSE END;
    FOR i:=2 TO x-1 DO
        IF x MOD i = 0 THEN RETURN FALSE END
    END;
    RETURN TRUE
END IsPrime;

PROCEDURE BitCount(x : LONGINT) : LONGINT;
VAR count : LONGINT;
BEGIN
    count := 0;
    WHILE x>0 DO
        x := x BAND (x-1);
        INC(count)
    END;
    RETURN count
END BitCount;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i,n : LONGINT;
BEGIN
    i := 1;
    n := 0;
    WHILE n<25 DO
        IF IsPrime(BitCount(i)) THEN
            FormatString("%l ", buf, i);
            WriteString(buf);
            INC(n)
        END;
        INC(i)
    END;
    WriteLn;

    FOR i:=888888877 TO 888888888 DO
        IF IsPrime(BitCount(i)) THEN
            FormatString("%l ", buf, i);
            WriteString(buf)
        END;
    END;

    ReadChar
END Pernicious.
