MODULE ImaginaryBase;
FROM FormatString IMPORT FormatString;
FROM RealMath IMPORT round;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

(* Helper *)
TYPE
    String = ARRAY[0..10] OF CHAR;
    StringBuilder = RECORD
        buf : String;
        ptr : CARDINAL;
    END;

PROCEDURE ToChar(n : INTEGER) : CHAR;
BEGIN
    CASE n OF
        0 : RETURN '0' |
        1 : RETURN '1' |
        2 : RETURN '2' |
        3 : RETURN '3' |
        4 : RETURN '4' |
        5 : RETURN '5' |
        6 : RETURN '6' |
        7 : RETURN '7' |
        8 : RETURN '8' |
        9 : RETURN '9'
    ELSE
        RETURN '-'
    END
END ToChar;

PROCEDURE AppendChar(VAR sb : StringBuilder; c : CHAR);
BEGIN
    sb.buf[sb.ptr] := c;
    INC(sb.ptr);
    sb.buf[sb.ptr] := 0C
END AppendChar;

PROCEDURE AppendInt(VAR sb : StringBuilder; n : INTEGER);
BEGIN
    sb.buf[sb.ptr] := ToChar(n);
    INC(sb.ptr);
    sb.buf[sb.ptr] := 0C
END AppendInt;

PROCEDURE Ceil(r : REAL) : REAL;
VAR t : REAL;
BEGIN
    t := FLOAT(INT(r));
    IF r - t > 0.0 THEN
        t := t + 1.0
    END;
    RETURN t
END Ceil;

PROCEDURE Modulus(q,d : INTEGER) : INTEGER;
VAR t : INTEGER;
BEGIN
    t := q / d;
    RETURN q - d * t
END Modulus;

PROCEDURE PrependInt(VAR sb : StringBuilder; n : INTEGER);
VAR i : CARDINAL;
BEGIN
    i := sb.ptr;
    INC(sb.ptr);
    sb.buf[sb.ptr] := 0C;
    WHILE i > 0 DO
        sb.buf[i] := sb.buf[i-1];
        DEC(i)
    END;
    sb.buf[0] := ToChar(n)
END PrependInt;

PROCEDURE Reverse(VAR str : String);
VAR
    i,j : CARDINAL;
    c : CHAR;
BEGIN
    IF str[0] = 0C THEN RETURN END;
    i := 0;
    WHILE str[i] # 0C DO INC(i) END;
    DEC(i);
    j := 0;
    WHILE i > j DO
        c := str[i];
        str[i] := str[j];
        str[j] := c;

        DEC(i);
        INC(j)
    END
END Reverse;

PROCEDURE TrimStart(VAR str : String; c : CHAR);
VAR i : CARDINAL;
BEGIN
    WHILE str[0] = c DO
        i := 0;
        WHILE str[i] # 0C DO
            str[i] := str[i+1];
            INC(i)
        END
    END
END TrimStart;

PROCEDURE WriteInteger(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInteger;

(* Imaginary *)
TYPE
    Complex = RECORD
        real,imag : REAL;
    END;
    QuaterImaginary = RECORD
        b2i : String;
    END;

PROCEDURE ComplexMul(lhs,rhs : Complex) : Complex;
BEGIN
    RETURN Complex{
        rhs.real * lhs.real - rhs.imag * lhs.imag,
        rhs.real * lhs.imag + rhs.imag * lhs.real
    }
END ComplexMul;

PROCEDURE ComplexMulR(lhs : Complex; rhs : REAL) : Complex;
BEGIN
    RETURN Complex{lhs.real * rhs, lhs.imag * rhs}
END ComplexMulR;

PROCEDURE ComplexInv(c : Complex) : Complex;
VAR denom : REAL;
BEGIN
    denom := c.real * c.real + c.imag * c.imag;
    RETURN Complex{c.real / denom, -c.imag / denom}
END ComplexInv;

PROCEDURE ComplexDiv(lhs,rhs : Complex) : Complex;
BEGIN
    RETURN ComplexMul(lhs, ComplexInv(rhs))
END ComplexDiv;

PROCEDURE ComplexNeg(c : Complex) : Complex;
BEGIN
    RETURN Complex{-c.real, -c.imag}
END ComplexNeg;

PROCEDURE ComplexSum(lhs,rhs : Complex) : Complex;
BEGIN
    RETURN Complex{lhs.real + rhs.real, lhs.imag + rhs.imag}
END ComplexSum;

PROCEDURE WriteComplex(c : Complex);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    IF c.imag = 0.0 THEN
        WriteInteger(INT(c.real))
    ELSIF c.real = 0.0 THEN
        WriteInteger(INT(c.imag));
        WriteString("i")
    ELSIF c.imag > 0.0 THEN
        WriteInteger(INT(c.real));
        WriteString(" + ");
        WriteInteger(INT(c.imag));
        WriteString("i")
    ELSE
        WriteInteger(INT(c.real));
        WriteString(" - ");
        WriteInteger(INT(-c.imag));
        WriteString("i")
    END
END WriteComplex;

PROCEDURE ToQuaterImaginary(c : Complex) : QuaterImaginary;
VAR
    re,im,fi,rem,index : INTEGER;
    f : REAL;
    t : Complex;
    sb : StringBuilder;
BEGIN
    IF (c.real = 0.0) AND (c.imag = 0.0) THEN RETURN QuaterImaginary{"0"} END;
    re := INT(c.real);
    im := INT(c.imag);
    fi := -1;
    sb := StringBuilder{"", 0};
    WHILE re # 0 DO
        rem := Modulus(re, -4);
        re := re / (-4);
        IF rem < 0 THEN
            rem := 4 + rem;
            INC(re)
        END;
        AppendInt(sb, rem);
        AppendInt(sb, 0)
    END;
    IF im # 0 THEN
        t := ComplexDiv(Complex{0.0, c.imag}, Complex{0.0, 2.0});
        f := t.real;
        im := INT(Ceil(f));
        f := -4.0 * (f - FLOAT(im));
        index := 1;
        WHILE im # 0 DO
            rem := Modulus(im, -4);
            im := im / (-4);
            IF rem < 0 THEN
                rem := 4 + rem;
                INC(im)
            END;
            IF index < INT(sb.ptr) THEN
                sb.buf[index] := ToChar(rem)
            ELSE
                AppendInt(sb, 0);
                AppendInt(sb, rem)
            END;
            index := index + 2;
        END;
        fi := INT(f)
    END;
    Reverse(sb.buf);
    IF fi # -1 THEN
        AppendChar(sb, '.');
        AppendInt(sb, fi)
    END;
    TrimStart(sb.buf, '0');
    IF sb.buf[0] = '.' THEN
        PrependInt(sb, 0)
    END;

    RETURN QuaterImaginary{sb.buf}
END ToQuaterImaginary;

PROCEDURE ToComplex(qi : QuaterImaginary) : Complex;
VAR
    j,pointPos,posLen,b2iLen : INTEGER;
    k : REAL;
    sum,prod : Complex;
BEGIN
    pointPos := 0;
    WHILE (qi.b2i[pointPos] # 0C) AND (qi.b2i[pointPos] # '.') DO
        INC(pointPos)
    END;
    IF qi.b2i[pointPos] # '.' THEN
        pointPos := -1;
        posLen := 0;
        WHILE qi.b2i[posLen] # 0C DO
            INC(posLen)
        END
    ELSE
        posLen := pointPos
    END;

    sum := Complex{0.0, 0.0};
    prod := Complex{1.0, 0.0};

    FOR j:=0 TO posLen - 1 DO
        k := FLOAT(ORD(qi.b2i[posLen - 1 - j]) - ORD('0'));
        IF k > 0.0 THEN
            sum := ComplexSum(sum, ComplexMulR(prod, k))
        END;
        prod := ComplexMul(prod, Complex{0.0, 2.0})
    END;

    IF pointPos # -1 THEN
        prod := ComplexInv(Complex{0.0, 2.0});
        b2iLen := 0;
        WHILE qi.b2i[b2iLen] # 0C DO INC(b2iLen) END;
        FOR j:=posLen + 1 TO b2iLen - 1 DO
            k := FLOAT(ORD(qi.b2i[j]) - ORD('0'));
            IF k > 0.0 THEN
                sum := ComplexSum(sum, ComplexMulR(prod, k))
            END;
            prod := ComplexMul(prod, ComplexInv(Complex{0.0, 2.0}))
        END
    END;

    RETURN sum
END ToComplex;

(* Main *)
VAR
    c1,c2 : Complex;
    qi : QuaterImaginary;
    i : INTEGER;
BEGIN
    FOR i:=1 TO 16 DO
        c1 := Complex{FLOAT(i), 0.0};
        WriteComplex(c1);
        WriteString(" -> ");
        qi := ToQuaterImaginary(c1);
        WriteString(qi.b2i);
        WriteString(" -> ");
        c2 := ToComplex(qi);
        WriteComplex(c2);
        WriteString("   ");

        c1 := ComplexNeg(c1);
        WriteComplex(c1);
        WriteString(" -> ");
        qi := ToQuaterImaginary(c1);
        WriteString(qi.b2i);
        WriteString(" -> ");
        c2 := ToComplex(qi);
        WriteComplex(c2);
        WriteLn
    END;
    WriteLn;

    FOR i:=1 TO 16 DO
        c1 := Complex{0.0, FLOAT(i)};
        WriteComplex(c1);
        WriteString(" -> ");
        qi := ToQuaterImaginary(c1);
        WriteString(qi.b2i);
        WriteString(" -> ");
        c2 := ToComplex(qi);
        WriteComplex(c2);
        WriteString("   ");

        c1 := ComplexNeg(c1);
        WriteComplex(c1);
        WriteString(" -> ");
        qi := ToQuaterImaginary(c1);
        WriteString(qi.b2i);
        WriteString(" -> ");
        c2 := ToComplex(qi);
        WriteComplex(c2);
        WriteLn
    END;

    ReadChar
END ImaginaryBase.
