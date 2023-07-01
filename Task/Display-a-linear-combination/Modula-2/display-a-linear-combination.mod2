MODULE Linear;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE WriteLinear(c : ARRAY OF INTEGER);
VAR
    buf : ARRAY[0..15] OF CHAR;
    i,j : CARDINAL;
    b : BOOLEAN;
BEGIN
    b := TRUE;
    j := 0;

    FOR i:=0 TO HIGH(c) DO
        IF c[i]=0 THEN CONTINUE END;

        IF c[i]<0 THEN
            IF b THEN WriteString("-")
            ELSE      WriteString(" - ") END;
        ELSIF c[i]>0 THEN
            IF NOT b THEN WriteString(" + ") END;
        END;

        IF c[i] > 1 THEN
            WriteInt(c[i]);
            WriteString("*")
        ELSIF c[i] < -1 THEN
            WriteInt(-c[i]);
            WriteString("*")
        END;

        FormatString("e(%i)", buf, i+1);
        WriteString(buf);

        b := FALSE;
        INC(j)
    END;

    IF j=0 THEN WriteString("0") END;
    WriteLn
END WriteLinear;

TYPE
    Array1 = ARRAY[0..0] OF INTEGER;
    Array3 = ARRAY[0..2] OF INTEGER;
    Array4 = ARRAY[0..3] OF INTEGER;
BEGIN
    WriteLinear(Array3{1,2,3});
    WriteLinear(Array4{0,1,2,3});
    WriteLinear(Array4{1,0,3,4});
    WriteLinear(Array3{1,2,0});
    WriteLinear(Array3{0,0,0});
    WriteLinear(Array1{0});
    WriteLinear(Array3{1,1,1});
    WriteLinear(Array3{-1,-1,-1});
    WriteLinear(Array4{-1,-2,0,-3});
    WriteLinear(Array1{-1});

    ReadChar
END Linear.
