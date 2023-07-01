MODULE Sequence;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE vc(n,base : INTEGER; VAR num,denom : INTEGER);
VAR p,q : INTEGER;
BEGIN
    p := 0;
    q := 1;

    WHILE n#0 DO
        p := p * base + (n MOD base);
        q := q * base;
        n := n DIV base
    END;

    num := p;
    denom := q;

    WHILE p#0 DO
        n := p;
        p := q MOD p;
        q := n
    END;

    num := num DIV q;
    denom := denom DIV q
END vc;

VAR
    buf : ARRAY[0..31] OF CHAR;
    d,n,i,b : INTEGER;
BEGIN
    FOR b:=2 TO 5 DO
        FormatString("base %i:", buf, b);
        WriteString(buf);
        FOR i:=0 TO 9 DO
            vc(i,b,n,d);
            IF n#0 THEN
                FormatString("  %i/%i", buf, n, d);
                WriteString(buf)
            ELSE
                WriteString("  0")
            END
        END;
        WriteLn
    END;

    ReadChar
END Sequence.
