MODULE Josephus;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Josephus(n,k : INTEGER) : INTEGER;
VAR a,m : INTEGER;
BEGIN
    m := 0;
    FOR a:=1 TO n DO
        m := (m + k) MOD a;
    END;
    RETURN m
END Josephus;

VAR
    buf : ARRAY[0..63] OF CHAR;
    n,k,i : INTEGER;
    nl,kl,il : LONGCARD;
BEGIN
    n := 41;
    k := 3;
    FormatString("n = %i, k = %i, final survivor: %i\n", buf, n, k, Josephus(n, k));
    WriteString(buf);

    ReadChar
END Josephus.
