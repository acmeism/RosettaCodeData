MODULE Vector;
FROM FormatString IMPORT FormatString;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE Vector =
    RECORD
        x,y : REAL;
    END;

PROCEDURE Add(a,b : Vector) : Vector;
BEGIN
    RETURN Vector{a.x+b.x, a.y+b.y}
END Add;

PROCEDURE Sub(a,b : Vector) : Vector;
BEGIN
    RETURN Vector{a.x-b.x, a.y-b.y}
END Sub;

PROCEDURE Mul(v : Vector; r : REAL) : Vector;
BEGIN
    RETURN Vector{a.x*r, a.y*r}
END Mul;

PROCEDURE Div(v : Vector; r : REAL) : Vector;
BEGIN
    RETURN Vector{a.x/r, a.y/r}
END Div;

PROCEDURE Print(v : Vector);
VAR buf : ARRAY[0..64] OF CHAR;
BEGIN
    WriteString("<");

    RealToStr(v.x, buf);
    WriteString(buf);
    WriteString(", ");

    RealToStr(v.y, buf);
    WriteString(buf);
    WriteString(">")
END Print;

VAR a,b : Vector;
BEGIN
    a := Vector{5.0, 7.0};
    b := Vector{2.0, 3.0};

    Print(Add(a, b));
    WriteLn;
    Print(Sub(a, b));
    WriteLn;
    Print(Mul(a, 11.0));
    WriteLn;
    Print(Div(a, 2.0));
    WriteLn;

    ReadChar
END Vector.
