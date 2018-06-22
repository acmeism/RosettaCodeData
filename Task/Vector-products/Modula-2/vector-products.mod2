MODULE VectorProducts;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteReal(r : REAL);
VAR buf : ARRAY[0..31] OF CHAR;
BEGIN
    RealToStr(r, buf);
    WriteString(buf)
END WriteReal;

TYPE Vector = RECORD
    a,b,c : REAL;
END;

PROCEDURE Dot(u,v : Vector) : REAL;
BEGIN
    RETURN u.a * v.a
         + u.b * v.b
         + u.c * v.c
END Dot;

PROCEDURE Cross(u,v : Vector) : Vector;
BEGIN
    RETURN Vector{
        u.b*v.c - u.c*v.b,
        u.c*v.a - u.a*v.c,
        u.a*v.b - u.b*v.a
    }
END Cross;

PROCEDURE ScalarTriple(u,v,w : Vector) : REAL;
BEGIN
    RETURN Dot(u, Cross(v, w))
END ScalarTriple;

PROCEDURE VectorTriple(u,v,w : Vector) : Vector;
BEGIN
    RETURN Cross(u, Cross(v, w))
END VectorTriple;

PROCEDURE WriteVector(v : Vector);
BEGIN
    WriteString("<");
    WriteReal(v.a);
    WriteString(", ");
    WriteReal(v.b);
    WriteString(", ");
    WriteReal(v.c);
    WriteString(">")
END WriteVector;

VAR a,b,c : Vector;
BEGIN
    a := Vector{3.0, 4.0, 5.0};
    b := Vector{4.0, 3.0, 5.0};
    c := Vector{-5.0, -12.0, -13.0};

    WriteVector(a);
    WriteString(" dot ");
    WriteVector(b);
    WriteString(" = ");
    WriteReal(Dot(a,b));
    WriteLn;

    WriteVector(a);
    WriteString(" cross ");
    WriteVector(b);
    WriteString(" = ");
    WriteVector(Cross(a,b));
    WriteLn;

    WriteVector(a);
    WriteString(" cross (");
    WriteVector(b);
    WriteString(" cross ");
    WriteVector(c);
    WriteString(") = ");
    WriteVector(VectorTriple(a,b,c));
    WriteLn;

    ReadChar
END VectorProducts.
