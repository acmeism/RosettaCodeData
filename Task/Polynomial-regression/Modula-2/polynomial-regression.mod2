MODULE PolynomialRegression;
FROM FormatString IMPORT FormatString;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Eval(a,b,c,x : REAL) : REAL;
BEGIN
    RETURN a + b*x + c*x*x;
END Eval;

PROCEDURE Regression(x,y : ARRAY OF INTEGER);
VAR
    n,i : INTEGER;
    xm,x2m,x3m,x4m : REAL;
    ym : REAL;
    xym,x2ym : REAL;
    sxx,sxy,sxx2,sx2x2,sx2y : REAL;
    a,b,c : REAL;
    buf : ARRAY[0..63] OF CHAR;
BEGIN
    n := SIZE(x)/SIZE(INTEGER);

    xm := 0.0;
    ym := 0.0;
    x2m := 0.0;
    x3m := 0.0;
    x4m := 0.0;
    xym := 0.0;
    x2ym := 0.0;
    FOR i:=0 TO n-1 DO
        xm := xm + FLOAT(x[i]);
        ym := ym + FLOAT(y[i]);
        x2m := x2m + FLOAT(x[i]) * FLOAT(x[i]);
        x3m := x3m + FLOAT(x[i]) * FLOAT(x[i]) * FLOAT(x[i]);
        x4m := x4m + FLOAT(x[i]) * FLOAT(x[i]) * FLOAT(x[i]) * FLOAT(x[i]);
        xym := xym + FLOAT(x[i]) * FLOAT(y[i]);
        x2ym := x2ym + FLOAT(x[i]) * FLOAT(x[i]) * FLOAT(y[i]);
    END;
    xm := xm / FLOAT(n);
    ym := ym / FLOAT(n);
    x2m := x2m / FLOAT(n);
    x3m := x3m / FLOAT(n);
    x4m := x4m / FLOAT(n);
    xym := xym / FLOAT(n);
    x2ym := x2ym / FLOAT(n);

    sxx := x2m - xm * xm;
    sxy := xym - xm * ym;
    sxx2 := x3m - xm * x2m;
    sx2x2 := x4m - x2m * x2m;
    sx2y := x2ym - x2m * ym;

    b := (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    c := (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    a := ym - b * xm - c * x2m;

    WriteString("y = ");
    RealToStr(a, buf);
    WriteString(buf);
    WriteString(" + ");
    RealToStr(b, buf);
    WriteString(buf);
    WriteString("x + ");
    RealToStr(c, buf);
    WriteString(buf);
    WriteString("x^2");
    WriteLn;

    FOR i:=0 TO n-1 DO
        FormatString("%2i %3i  ", buf, x[i], y[i]);
        WriteString(buf);
        RealToStr(Eval(a,b,c,FLOAT(x[i])), buf);
        WriteString(buf);
        WriteLn;
    END;
END Regression;

TYPE R = ARRAY[0..10] OF INTEGER;
VAR
    x,y : R;
BEGIN
    x := R{0,1,2,3,4,5,6,7,8,9,10};
    y := R{1,6,17,34,57,86,121,162,209,262,321};
    Regression(x,y);

    ReadChar;
END PolynomialRegression.
