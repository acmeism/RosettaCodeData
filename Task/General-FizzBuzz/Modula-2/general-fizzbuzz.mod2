MODULE GeneralFizzBuzz;
FROM Conversions IMPORT StrToInt;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;

TYPE
    Word = ARRAY[0..63] OF CHAR;

PROCEDURE WriteInt(i : INTEGER);
VAR buf : Word;
BEGIN
    FormatString("%i", buf, i);
    WriteString(buf);
END WriteInt;

PROCEDURE ReadInt() : INTEGER;
VAR
    buf : ARRAY[0..9] OF CHAR;
    c : CHAR;
    i : INTEGER;
BEGIN
    i := 0;
    LOOP
        c := ReadChar();
        IF (c=0C) OR (i>9) THEN
            BREAK
        ELSIF (c=012C) OR (c=015C) THEN
            WriteLn;
            buf[i] := 0C;
            BREAK
        ELSIF (c<'0') OR (c>'9') THEN
            Write(c);
            buf[i] := 0C;
            BREAK
        ELSE
            Write(c);
            buf[i] := c;
            INC(i)
        END
    END;
    StrToInt(buf, i);
    RETURN i
END ReadInt;

PROCEDURE ReadLine() : Word;
VAR
    buf : Word;
    i : INTEGER;
    c : CHAR;
BEGIN
    i := 0;
    WHILE i<HIGH(buf) DO
        c := ReadChar();
        IF (c=0C) OR (c=012C) OR (c=015C) THEN
            WriteLn;
            buf[i] := 0C;
            BREAK
        ELSE
            Write(c);
            buf[i] := c;
            INC(i)
        END
    END;
    RETURN buf;
END ReadLine;

VAR
    i,max : INTEGER;
    fa,fb,fc : INTEGER;
    wa,wb,wc : Word;
    done : BOOLEAN;
BEGIN
    max := ReadInt();

    fa := ReadInt();
    wa := ReadLine();
    fb := ReadInt();
    wb := ReadLine();
    fc := ReadInt();
    wc := ReadLine();

    FOR i:=1 TO max DO
        done := FALSE;
        IF i MOD fa = 0 THEN
            done := TRUE;
            WriteString(wa);
        END;
        IF i MOD fb = 0 THEN
            done := TRUE;
            WriteString(wb);
        END;
        IF i MOD fc = 0 THEN
            done := TRUE;
            WriteString(wc);
        END;
        IF NOT done THEN
            WriteInt(i)
        END;
        WriteLn;
    END;

    ReadChar
END GeneralFizzBuzz.
