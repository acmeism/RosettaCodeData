MODULE Coconuts;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

CONST MAX_SAILORS = 9;

PROCEDURE Scenario(coconuts,ns : INTEGER);
VAR
    buf : ARRAY[0..63] OF CHAR;
    hidden : ARRAY[0..MAX_SAILORS-1] OF INTEGER;
    nc,s,t : INTEGER;
BEGIN
    IF ns>MAX_SAILORS THEN RETURN END;

    coconuts := (coconuts DIV ns) * ns + 1;
    LOOP
        nc := coconuts;
        FOR s:=1 TO ns DO
            IF nc MOD ns = 1 THEN
                hidden[s-1] := nc DIV ns;
                nc := nc - hidden[s-1] - 1;
                IF (s=ns) AND (nc MOD ns = 0) THEN
                    FormatString("%i sailors require a minimum of %i coconuts\n", buf, ns, coconuts);
                    WriteString(buf);

                    FOR t:=1 TO ns DO
                        FormatString("\tSailor %i hides %i\n", buf, t, hidden[t-1]);
                        WriteString(buf)
                    END;

                    FormatString("\tThe monkey gets %i\n", buf, ns);
                    WriteString(buf);
                    FormatString("\tFinally, each sailor takes %i\n", buf, nc DIV ns);
                    WriteString(buf);
                    RETURN
                END
            ELSE
                BREAK
            END
        END;
        INC(coconuts,ns)
    END
END Scenario;

VAR
    ns : INTEGER;
BEGIN
    FOR ns:=2 TO MAX_SAILORS DO
        Scenario(11,ns);
    END;

    ReadChar
END Coconuts.
