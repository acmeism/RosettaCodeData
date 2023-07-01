MODULE Horner;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Horner(coeff : ARRAY OF REAL; x : REAL) : REAL;
VAR
    ans : REAL;
    i : CARDINAL;
BEGIN
    ans := 0.0;
    FOR i:=HIGH(coeff) TO 0 BY -1 DO
        ans := (ans * x) + coeff[i];
    END;
    RETURN ans
END Horner;

TYPE A = ARRAY[0..3] OF REAL;
VAR
    buf : ARRAY[0..63] OF CHAR;
    coeff : A;
    ans : REAL;
BEGIN
    coeff := A{-19.0, 7.0, -4.0, 6.0};
    ans := Horner(coeff, 3.0);
    RealToStr(ans, buf);
    WriteString(buf);
    WriteLn;
    ReadChar
END Horner.
