MODULE PBF;
FROM FormatString IMPORT FormatString;
FROM SHA256 IMPORT SHA256,Create,Destroy,HashBytes,Finalize,GetHash;
FROM SYSTEM IMPORT ADR,ADDRESS,BYTE;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;
FROM Threads IMPORT Thread,CreateThread,WaitForThreadTermination;

PROCEDURE PrintHexBytes(str : ARRAY OF BYTE; limit : INTEGER);
VAR
    buf : ARRAY[0..7] OF CHAR;
    i,v : INTEGER;
BEGIN
    i := 0;
    WHILE i<limit DO
        v := ORD(str[i]);
        IF v < 16 THEN
            WriteString("0")
        END;
        FormatString("%h", buf, v);
        WriteString(buf);
        INC(i);
    END
END PrintHexBytes;

PROCEDURE Check(str : ARRAY OF CHAR);
TYPE
    HA = ARRAY[0..31] OF BYTE;
CONST
    h1 = HA{3aH, 7bH, 0d3H, 0e2H, 36H, 0aH, 3dH, 29H, 0eeH, 0a4H, 36H, 0fcH, 0fbH, 7eH, 44H, 0c7H, 35H, 0d1H, 17H, 0c4H, 2dH, 1cH, 18H, 35H, 42H, 0bH, 6bH, 99H, 42H, 0ddH, 4fH, 1bH};
    h2 = HA{74H, 0e1H, 0bbH, 62H, 0f8H, 0daH, 0bbH, 81H, 25H, 0a5H, 88H, 52H, 0b6H, 3bH, 0dfH, 6eH, 0aeH, 0f6H, 67H, 0cbH, 56H, 0acH, 7fH, 7cH, 0dbH, 0a6H, 0d7H, 30H, 5cH, 50H, 0a2H, 2fH};
    h3 = HA{11H, 15H, 0ddH, 80H, 0fH, 0eaH, 0acH, 0efH, 0dfH, 48H, 1fH, 1fH, 90H, 70H, 37H, 4aH, 2aH, 81H, 0e2H, 78H, 80H, 0f1H, 87H, 39H, 6dH, 0b6H, 79H, 58H, 0b2H, 07H, 0cbH, 0adH};
VAR
    hash : SHA256;
    out : ARRAY[0..31] OF BYTE;
    i : CARDINAL;
    match : BOOLEAN;
BEGIN
    hash := Create();

    HashBytes(hash, ADR(str), HIGH(str)+1);
    Finalize(hash);

    GetHash(hash, out);
    Destroy(hash);

    match := TRUE;
    FOR i:=0 TO HIGH(out) DO
        IF out[i] # h1[i] THEN
            match := FALSE;
            BREAK
        END
    END;
    IF match THEN
        WriteString(str);
        WriteString(" ");
        PrintHexBytes(out, 32);
        WriteLn;
        RETURN
    END;

    match := TRUE;
    FOR i:=0 TO HIGH(out) DO
        IF out[i] # h2[i] THEN
            match := FALSE;
            BREAK
        END
    END;
    IF match THEN
        WriteString(str);
        WriteString(" ");
        PrintHexBytes(out, 32);
        WriteLn;
        RETURN
    END;

    match := TRUE;
    FOR i:=0 TO HIGH(out) DO
        IF out[i] # h3[i] THEN
            match := FALSE;
            BREAK
        END
    END;
    IF match THEN
        WriteString(str);
        WriteString(" ");
        PrintHexBytes(out, 32);
        WriteLn
    END
END Check;

PROCEDURE CheckWords(a : CHAR);
VAR
    word : ARRAY[0..4] OF CHAR;
    b,c,d,e : CHAR;
BEGIN
    word[0] := a;
    FOR b:='a' TO 'z' DO
        word[1] := b;
        FOR c:='a' TO 'z' DO
            word[2] := c;
            FOR d:='a' TO 'z' DO
                word[3] := d;
                FOR e:='a' TO 'z' DO
                    word[4] := e;
                    Check(word)
                END
            END
        END
    END
END CheckWords;

PROCEDURE CheckAF(ptr : ADDRESS) : CARDINAL;
VAR a : CHAR;
BEGIN
    FOR a:='a' TO 'f' DO
        CheckWords(a)
    END;
    RETURN 0
END CheckAF;

PROCEDURE CheckGM(ptr : ADDRESS) : CARDINAL;
VAR a : CHAR;
BEGIN
    FOR a:='g' TO 'm' DO
        CheckWords(a)
    END;
    RETURN 0
END CheckGM;

PROCEDURE CheckNS(ptr : ADDRESS) : CARDINAL;
VAR a : CHAR;
BEGIN
    FOR a:='n' TO 's' DO
        CheckWords(a)
    END;
    RETURN 0
END CheckNS;

PROCEDURE CheckTZ(ptr : ADDRESS) : CARDINAL;
VAR a : CHAR;
BEGIN
    FOR a:='t' TO 'z' DO
        CheckWords(a)
    END;
    RETURN 0
END CheckTZ;

VAR
    t1,t2,t3,t4 : Thread;
    s1,s2,s3,s4 : CARDINAL;
BEGIN
    CreateThread(t1,CheckAF,NIL,0,TRUE);
    CreateThread(t2,CheckGM,NIL,0,TRUE);
    CreateThread(t3,CheckNS,NIL,0,TRUE);
    CreateThread(t4,CheckTZ,NIL,0,TRUE);

    WaitForThreadTermination(t1,-1,s1);
    WaitForThreadTermination(t2,-1,s2);
    WaitForThreadTermination(t3,-1,s3);
    WaitForThreadTermination(t4,-1,s4);

    WriteString("Done");
    WriteLn;
    ReadChar
END PBF.
