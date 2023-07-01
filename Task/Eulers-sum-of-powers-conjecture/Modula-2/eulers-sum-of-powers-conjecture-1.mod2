MODULE EulerConjecture;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Pow5(a : LONGINT) : LONGINT;
BEGIN
    RETURN a * a * a * a * a
END Pow5;

VAR
    buf : ARRAY[0..63] OF CHAR;
    a,b,c,d,e,sum,curr : LONGINT;
BEGIN
    FOR a:=0 TO 250 DO
        FOR b:=a TO 250 DO
            IF b=a THEN CONTINUE END;
            FOR c:=b TO 250 DO
                IF (c=a) OR (c=b) THEN CONTINUE END;
                FOR d:=c TO 250 DO
                    IF (d=a) OR (d=b) OR (d=c) THEN CONTINUE END;
                    sum := Pow5(a) + Pow5(b) + Pow5(c) + Pow5(d);
                    FOR e:=d TO 250 DO
                        IF (e=a) OR (e=b) OR (e=c) OR (e=d) THEN CONTINUE END;
                        curr := Pow5(e);
                        IF (sum#0) AND (sum=curr) THEN
                            FormatString("%l^5 + %l^5 + %l^5 + %l^5 = %l^5\n", buf, a, b, c, d, e);
                            WriteString(buf)
                        ELSIF curr > sum THEN
                            BREAK
                        END
                    END;
                END;
            END;
        END;
    END;

    WriteString("Done");
    WriteLn;
    ReadChar
END EulerConjecture.
