MODULE AlmostPrime;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE KPrime(n,k : INTEGER) : BOOLEAN;
VAR p,f : INTEGER;
BEGIN
    f := 0;
    p := 2;
    WHILE (f<k) AND (p*p<=n) DO
        WHILE n MOD p = 0 DO
            n := n DIV p;
            INC(f)
        END;
        INC(p)
    END;
    IF n>1 THEN
        RETURN f+1 = k
    END;
    RETURN f = k
END KPrime;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i,c,k : INTEGER;
BEGIN
    FOR k:=1 TO 5 DO
        FormatString("k = %i:", buf, k);
        WriteString(buf);

        i:=2;
        c:=0;
        WHILE c<10 DO
            IF KPrime(i,k) THEN
                FormatString(" %i", buf, i);
                WriteString(buf);
                INC(c)
            END;
            INC(i)
        END;

        WriteLn;
    END;

    ReadChar;
END AlmostPrime.
