MODULE ResistorMesh;
FROM RConversions IMPORT RealToStringFixed;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

CONST S = 10;

TYPE Node = RECORD
    v : LONGREAL;
    fixed : INTEGER;
END;

PROCEDURE SetBoundary(VAR m : ARRAY OF ARRAY OF Node);
BEGIN
    m[1][1].v := 1.0;
    m[1][1].fixed := 1;

    m[6][7].v := -1.0;
    m[6][7].fixed := -1;
END SetBoundary;

PROCEDURE CalcDiff(VAR m,d : ARRAY OF ARRAY OF Node) : LONGREAL;
VAR
    total,v : LONGREAL;
    i,j,n : INTEGER;
BEGIN
    total := 0.0;
    FOR i:=0 TO S DO
        FOR j:=0 TO S DO
            v := 0.0;
            n := 0;
            IF i>0 THEN
                v := v + m[i-1][j].v;
                INC(n);
            END;
            IF j>0 THEN
                v := v + m[i][j-1].v;
                INC(n);
            END;
            IF i+1<S THEN
                v := v + m[i+1][j].v;
                INC(n);
            END;
            IF j+1<S THEN
                v := v + m[i][j+1].v;
                INC(n);
            END;
            v := m[i][j].v - v / LFLOAT(n);
            d[i][j].v := v;
            IF m[i][j].fixed=0 THEN
                total := total + v*v;
            END;
        END;
    END;
    RETURN total;
END CalcDiff;

PROCEDURE Iter(m : ARRAY OF ARRAY OF Node) : LONGREAL;
VAR
    d : ARRAY[0..S] OF ARRAY[0..S] OF Node;
    i,j,k : INTEGER;
    cur : ARRAY[0..2] OF LONGREAL;
    diff : LONGREAL;
BEGIN
    FOR i:=0 TO S DO
        FOR j:=0 TO S DO
            d[i][j] := Node{0.0,0};
        END;
    END;

    diff := 1.0E10;
    WHILE diff>1.0E-24 DO
        SetBoundary(m);
        diff := CalcDiff(m,d);
        FOR i:=0 TO S DO
            FOR j:=0 TO S DO
                m[i][j].v := m[i][j].v - d[i][j].v;
            END;
        END;
    END;

    FOR i:=0 TO S DO
        FOR j:=0 TO S DO
            k:=0;
            IF i#0 THEN INC(k) END;
            IF j#0 THEN INC(k) END;
            IF i<S-1 THEN INC(k) END;
            IF j<S-1 THEN INC(k) END;
            cur[m[i][j].fixed+1] := cur[m[i][j].fixed+1] + d[i][j].v*LFLOAT(k);
        END;
    END;

    RETURN (cur[2]-cur[0]) / 2.0;
END Iter;

VAR
    mesh : ARRAY[0..S] OF ARRAY[0..S] OF Node;
    buf : ARRAY[0..32] OF CHAR;
    r : LONGREAL;
    pos : CARDINAL;
    ok : BOOLEAN;
BEGIN
    pos := 0;
    r := 2.0 / Iter(mesh);
    WriteString("R = ");
    RealToStringFixed(r, 15,0, buf, pos, ok);
    WriteString(buf);
    WriteString(" ohms");
    WriteLn;

    ReadChar;
END ResistorMesh.
