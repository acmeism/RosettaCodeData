MODULE Faulhaber;
FROM EXCEPTIONS IMPORT AllocateSource,ExceptionSource,GetMessage,RAISE;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

VAR TextWinExSrc : ExceptionSource;

(* Helper Functions *)
PROCEDURE Abs(n : INTEGER) : INTEGER;
BEGIN
    IF n < 0 THEN
        RETURN -n
    END;
    RETURN n
END Abs;

PROCEDURE Binomial(n,k : INTEGER) : INTEGER;
VAR i,num,denom : INTEGER;
BEGIN
    IF (n < 0) OR (k < 0) OR (n < k) THEN
        RAISE(TextWinExSrc, 0, "Argument Exception.")
    END;
    IF (n = 0) OR (k = 0) THEN
        RETURN 1
    END;
    num := 1;
    FOR i:=k+1 TO n DO
        num := num * i
    END;
    denom := 1;
    FOR i:=2 TO n - k DO
        denom := denom * i
    END;
    RETURN num / denom
END Binomial;

PROCEDURE GCD(a,b : INTEGER) : INTEGER;
BEGIN
    IF b = 0 THEN
        RETURN a
    END;
    RETURN GCD(b, a MOD b)
END GCD;

PROCEDURE WriteInteger(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInteger;

(* Fraction Handling *)
TYPE Frac = RECORD
    num,denom : INTEGER;
END;

PROCEDURE InitFrac(n,d : INTEGER) : Frac;
VAR nn,dd,g : INTEGER;
BEGIN
    IF d = 0 THEN
        RAISE(TextWinExSrc, 0, "The denominator must not be zero.")
    END;
    IF n = 0 THEN
        d := 1
    ELSIF d < 0 THEN
        n := -n;
        d := -d
    END;
    g := Abs(GCD(n, d));
    IF g > 1 THEN
        n := n / g;
        d := d / g
    END;
    RETURN Frac{n, d}
END InitFrac;

PROCEDURE EqualFrac(a,b : Frac) : BOOLEAN;
BEGIN
    RETURN (a.num = b.num) AND (a.denom = b.denom)
END EqualFrac;

PROCEDURE LessFrac(a,b : Frac) : BOOLEAN;
BEGIN
    RETURN a.num * b.denom < b.num * a.denom
END LessFrac;

PROCEDURE NegateFrac(f : Frac) : Frac;
BEGIN
    RETURN Frac{-f.num, f.denom}
END NegateFrac;

PROCEDURE SubFrac(lhs,rhs : Frac) : Frac;
BEGIN
    RETURN InitFrac(lhs.num * rhs.denom - lhs.denom * rhs.num, rhs.denom * lhs.denom)
END SubFrac;

PROCEDURE MultFrac(lhs,rhs : Frac) : Frac;
BEGIN
    RETURN InitFrac(lhs.num * rhs.num, lhs.denom * rhs.denom)
END MultFrac;

PROCEDURE Bernoulli(n : INTEGER) : Frac;
VAR
    a : ARRAY[0..15] OF Frac;
    i,j,m : INTEGER;
BEGIN
    IF n < 0 THEN
        RAISE(TextWinExSrc, 0, "n may not be negative or zero.")
    END;
    FOR m:=0 TO n DO
        a[m] := Frac{1, m + 1};
        FOR j:=m TO 1 BY -1 DO
            a[j-1] := MultFrac(SubFrac(a[j-1], a[j]), Frac{j, 1})
        END
    END;
    IF n # 1 THEN RETURN a[0] END;
    RETURN NegateFrac(a[0])
END Bernoulli;

PROCEDURE WriteFrac(f : Frac);
BEGIN
    WriteInteger(f.num);
    IF f.denom # 1 THEN
        WriteString("/");
        WriteInteger(f.denom)
    END
END WriteFrac;

(* Target *)
PROCEDURE Faulhaber(p : INTEGER);
VAR
    j,pwr,sign : INTEGER;
    q,coeff : Frac;
BEGIN
    WriteInteger(p);
    WriteString(" : ");
    q := InitFrac(1, p + 1);
    sign := -1;
    FOR j:=0 TO p DO
        sign := -1 * sign;
        coeff := MultFrac(MultFrac(MultFrac(q, Frac{sign, 1}), Frac{Binomial(p + 1, j), 1}), Bernoulli(j));
        IF EqualFrac(coeff, Frac{0, 1}) THEN CONTINUE END;
        IF j = 0 THEN
            IF NOT EqualFrac(coeff, Frac{1, 1}) THEN
                IF EqualFrac(coeff, Frac{-1, 1}) THEN
                    WriteString("-")
                ELSE
                    WriteFrac(coeff)
                END
            END
        ELSE
            IF EqualFrac(coeff, Frac{1, 1}) THEN
                WriteString(" + ")
            ELSIF EqualFrac(coeff, Frac{-1, 1}) THEN
                WriteString(" - ")
            ELSIF LessFrac(Frac{0, 1}, coeff) THEN
                WriteString(" + ");
                WriteFrac(coeff)
            ELSE
                WriteString(" - ");
                WriteFrac(NegateFrac(coeff))
            END
        END;
        pwr := p + 1 - j;
        IF pwr > 1 THEN
            WriteString("n^");
            WriteInteger(pwr)
        ELSE
            WriteString("n")
        END
    END;
    WriteLn
END Faulhaber;

(* Main *)
VAR i : INTEGER;
BEGIN
    FOR i:=0 TO 9 DO
        Faulhaber(i)
    END;
    ReadChar
END Faulhaber.
