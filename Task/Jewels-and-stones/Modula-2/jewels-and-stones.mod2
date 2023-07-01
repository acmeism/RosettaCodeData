MODULE Jewels;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE CountJewels(s,j : ARRAY OF CHAR) : INTEGER;
VAR c,i,k : CARDINAL;
BEGIN
    c :=0;

    FOR i:=0 TO HIGH(s) DO
        FOR k:=0 TO HIGH(j) DO
            IF (j[k]#0C) AND (s[i]#0C) AND (j[k]=s[i]) THEN
                INC(c);
                BREAK
            END
        END
    END;

    RETURN c
END CountJewels;

BEGIN
    WriteInt(CountJewels("aAAbbbb", "aA"));
    WriteLn;
    WriteInt(CountJewels("ZZ", "z"));
    WriteLn;

    ReadChar
END Jewels.
