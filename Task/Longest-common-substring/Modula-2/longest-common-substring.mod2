MODULE LCS;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,Write,ReadChar;

PROCEDURE WriteSubstring(s : ARRAY OF CHAR; b,e : CARDINAL);
VAR i : CARDINAL;
BEGIN
    IF b=e THEN RETURN END;
    IF e>HIGH(s) THEN e := HIGH(s) END;

    FOR i:=b TO e DO
        Write(s[i])
    END
END WriteSubstring;

TYPE
    Pair = RECORD
        a,b : CARDINAL;
    END;

PROCEDURE lcs(sa,sb : ARRAY OF CHAR) : Pair;
VAR
    output : Pair;
    a,b,len : CARDINAL;
BEGIN
    output := Pair{0,0};

    FOR a:=0 TO HIGH(sa) DO
        FOR b:=0 TO HIGH(sb) DO
            IF (sa[a]#0C) AND (sb[b]#0C) AND (sa[a]=sb[b]) THEN
                len := 1;
                WHILE (a+len<HIGH(sa)) AND (b+len<HIGH(sb)) DO
                    IF sa[a+len] = sb[b+len] THEN
                        INC(len)
                    ELSE
                        BREAK
                    END
                END;
                DEC(len);

                IF len>output.b-output.a THEN
                    output := Pair{a,a+len}
                END
            END
        END
    END;

    RETURN output
END lcs;

VAR res : Pair;
BEGIN
    res := lcs("testing123testing", "thisisatest");
    WriteSubstring("testing123testing", res.a, res.b);
    WriteLn;

    ReadChar
END LCS.
