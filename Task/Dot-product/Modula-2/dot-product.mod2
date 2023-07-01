MODULE DotProduct;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE Vector =
    RECORD
        x,y,z : REAL
    END;

PROCEDURE DotProduct(u,v : Vector) : REAL;
BEGIN
    RETURN u.x*v.x + u.y*v.y + u.z*v.z
END DotProduct;

VAR
    buf : ARRAY[0..63] OF CHAR;
    dp : REAL;
BEGIN
    dp := DotProduct(Vector{1.0,3.0,-5.0},Vector{4.0,-2.0,-1.0});
    RealToStr(dp, buf);
    WriteString(buf);
    WriteLn;

    ReadChar
END DotProduct.
