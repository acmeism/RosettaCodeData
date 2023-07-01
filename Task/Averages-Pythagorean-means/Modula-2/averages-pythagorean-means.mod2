MODULE PythagoreanMeans;
FROM FormatString IMPORT FormatString;
FROM LongMath IMPORT power;
FROM LongStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE ArithmeticMean(numbers : ARRAY OF LONGREAL) : LONGREAL;
VAR
    i,cnt : CARDINAL;
    mean : LONGREAL;
BEGIN
    mean := 0.0;
    cnt := 0;
    FOR i:=0 TO HIGH(numbers) DO
        mean := mean + numbers[i];
        INC(cnt);
    END;
    RETURN mean / LFLOAT(cnt)
END ArithmeticMean;

PROCEDURE GeometricMean(numbers : ARRAY OF LONGREAL) : LONGREAL;
VAR
    i,cnt : CARDINAL;
    mean : LONGREAL;
BEGIN
    mean := 1.0;
    cnt := 0;
    FOR i:=0 TO HIGH(numbers) DO
        mean := mean * numbers[i];
        INC(cnt);
    END;
    RETURN power(mean, 1.0 / LFLOAT(cnt))
END GeometricMean;

PROCEDURE HarmonicMean(numbers : ARRAY OF LONGREAL) : LONGREAL;
VAR
    i,cnt : CARDINAL;
    mean : LONGREAL;
BEGIN
    mean := 0.0;
    cnt := 0;
    FOR i:=0 TO HIGH(numbers) DO
        mean := mean + ( 1.0 / numbers[i]);
        INC(cnt);
    END;
    RETURN LFLOAT(cnt) / mean
END HarmonicMean;


CONST Size = 10;
TYPE DA = ARRAY[1..Size] OF LONGREAL;

VAR
    buf : ARRAY[0..63] OF CHAR;
    array : DA;
    arithmetic,geometric,harmonic : LONGREAL;
BEGIN
    array := DA{1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0};

    arithmetic := ArithmeticMean(array);
    geometric := GeometricMean(array);
    harmonic := HarmonicMean(array);

    WriteString("A = ");
    RealToStr(arithmetic, buf);
    WriteString(buf);
    WriteString(" G = ");
    RealToStr(geometric, buf);
    WriteString(buf);
    WriteString(" H = ");
    RealToStr(harmonic, buf);
    WriteString(buf);
    WriteLn;

    FormatString("A >= G is %b, G >= H is %b\n", buf, arithmetic >= geometric, geometric >= harmonic);
    WriteString(buf);

    ReadChar
END PythagoreanMeans.
