MODULE AGM;
FROM EXCEPTIONS IMPORT AllocateSource,ExceptionSource,GetMessage,RAISE;
FROM LongConv IMPORT ValueReal;
FROM LongMath IMPORT sqrt;
FROM LongStr IMPORT RealToStr;
FROM Terminal IMPORT ReadChar,Write,WriteString,WriteLn;

VAR
    TextWinExSrc : ExceptionSource;

PROCEDURE ReadReal() : LONGREAL;
VAR
    buffer : ARRAY[0..63] OF CHAR;
    i : CARDINAL;
    c : CHAR;
BEGIN
    i := 0;

    LOOP
        c := ReadChar();
        IF ((c >= '0') AND (c <= '9')) OR (c = '.') THEN
            buffer[i] := c;
            Write(c);
            INC(i)
        ELSE
            WriteLn;
            EXIT
        END
    END;

    buffer[i] := 0C;
    RETURN ValueReal(buffer)
END ReadReal;

PROCEDURE WriteReal(r : LONGREAL);
VAR
    buffer : ARRAY[0..63] OF CHAR;
BEGIN
    RealToStr(r, buffer);
    WriteString(buffer)
END WriteReal;

PROCEDURE AGM(a,g : LONGREAL) : LONGREAL;
CONST iota = 1.0E-16;
VAR a1, g1 : LONGREAL;
BEGIN
    IF a * g < 0.0 THEN
        RAISE(TextWinExSrc, 0, "arithmetic-geometric mean undefined when x*y<0")
    END;

    WHILE ABS(a - g) > iota DO
        a1 := (a + g) / 2.0;
        g1 := sqrt(a * g);

        a := a1;
        g := g1
    END;

    RETURN a
END AGM;

VAR
    x, y, z: LONGREAL;
BEGIN
    WriteString("Enter two numbers: ");
    x := ReadReal();
    y := ReadReal();
    WriteReal(AGM(x, y));
    WriteLn
END AGM.
