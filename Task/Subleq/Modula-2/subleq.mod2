MODULE Subleq;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;

TYPE MEMORY = ARRAY[0..31] OF INTEGER;
VAR
    mem : MEMORY;
    ip,a,b : INTEGER;
    ch : CHAR;
BEGIN
    mem := MEMORY{
         15,  17,  -1,  17,  -1,  -1,  16,   1,
         -1,  16,   3,  -1,  15,  15,   0,   0,
         -1,  72, 101, 108, 108, 111,  44,  32,
        119, 111, 114, 108, 100,  33,  10,   0
    };

    ip := 0;
    REPEAT
        a := mem[ip];
        b := mem[ip+1];

        IF a = -1 THEN
            ch := ReadChar();
            mem[b] := ORD(ch);
        ELSIF b = -1 THEN
            Write(CHR(mem[a]));
        ELSE
            DEC(mem[b],mem[a]);
            IF mem[b] < 1 THEN
                ip := mem[ip+2];
                CONTINUE
            END
        END;

        INC(ip,3)
    UNTIL ip < 0;
    WriteLn;

    ReadChar
END Subleq.
