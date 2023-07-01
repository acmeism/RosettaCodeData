MODULE Trig;
FROM RealMath IMPORT pi,sin,cos,tan,arctan,arccos,arcsin;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteReal(v : REAL);
VAR buf : ARRAY[0..31] OF CHAR;
BEGIN
    RealToStr(v, buf);
    WriteString(buf)
END WriteReal;

VAR theta : REAL;
BEGIN
    theta := pi / 4.0;

    WriteString("theta: ");
    WriteReal(theta);
    WriteLn;

    WriteString("sin: ");
    WriteReal(sin(theta));
    WriteLn;

    WriteString("cos: ");
    WriteReal(cos(theta));
    WriteLn;

    WriteString("tan: ");
    WriteReal(tan(theta));
    WriteLn;

    WriteString("arcsin: ");
    WriteReal(arcsin(sin(theta)));
    WriteLn;

    WriteString("arccos: ");
    WriteReal(arccos(cos(theta)));
    WriteLn;

    WriteString("arctan: ");
    WriteReal(arctan(tan(theta)));
    WriteLn;

    ReadChar
END Trig.
