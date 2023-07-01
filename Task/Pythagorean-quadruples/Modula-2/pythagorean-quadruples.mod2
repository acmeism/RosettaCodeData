MODULE PythagoreanQuadruples;
FROM FormatString IMPORT FormatString;
FROM RealMath IMPORT sqrt;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInteger(i : INTEGER);
VAR buffer : ARRAY[0..16] OF CHAR;
BEGIN
    FormatString("%i", buffer, i);
    WriteString(buffer)
END WriteInteger;

(* Main *)
CONST N = 2200;
VAR
    r : ARRAY[0..N] OF BOOLEAN;
    a,b,c,d : INTEGER;
    aabb,aabbcc : INTEGER;
BEGIN
    (* Initialize *)
    FOR a:=0 TO HIGH(r) DO
        r[a] := FALSE
    END;

    (* Process *)
    FOR a:=1 TO N DO
        FOR b:=a TO N DO
            IF (a MOD 2 = 1) AND (b MOD 2 = 1) THEN
                (* For positive odd a and b, no solution *)
                CONTINUE
            END;
            aabb := a*a + b*b;
            FOR c:=b TO N DO
                aabbcc := aabb + c*c;
                d := INT(sqrt(FLOAT(aabbcc)));
                IF (aabbcc = d*d) AND (d <= N) THEN
                    (* solution *)
                    r[d] := TRUE
                END
            END
        END
    END;

    FOR a:=1 TO N DO
        IF NOT r[a] THEN
            (* pritn non-solution *)
            WriteInteger(a);
            WriteString(" ")
        END
    END;
    WriteLn;

    ReadChar
END PythagoreanQuadruples.
