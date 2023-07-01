MODULE Fivenum;
FROM FormatString IMPORT FormatString;
FROM LongStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteLongReal(v : LONGREAL);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    RealToStr(v, buf);
    WriteString(buf)
END WriteLongReal;

PROCEDURE WriteArray(arr : ARRAY OF LONGREAL);
VAR i : CARDINAL;
BEGIN
    WriteString("[");
    FOR i:=0 TO HIGH(arr) DO
        WriteLongReal(arr[i]);
        WriteString(", ")
    END;
    WriteString("]")
END WriteArray;

(* Assumes that the input is sorted *)
PROCEDURE Median(x : ARRAY OF LONGREAL; beg,end : CARDINAL) : LONGREAL;
VAR m,cnt : CARDINAL;
BEGIN
    cnt := end - beg + 1;
    m := cnt / 2;
    IF cnt MOD 2 = 1 THEN
        RETURN x[beg + m]
    END;
    RETURN (x[beg + m - 1] + x[beg + m]) / 2.0
END Median;

TYPE Summary = ARRAY[0..4] OF LONGREAL;
PROCEDURE Fivenum(input : ARRAY OF LONGREAL) : Summary;
    PROCEDURE Sort();
    VAR
        i,j : CARDINAL;
        t : LONGREAL;
    BEGIN
        FOR i:=0 TO HIGH(input) DO
            FOR j:=0 TO HIGH(input) DO
                IF (i#j) AND (input[i] < input[j]) THEN
                    t := input[i];
                    input[i] := input[j];
                    input[j] := t
                END
            END
        END
    END Sort;
VAR
    result : Summary;
    size,m,low : CARDINAL;
BEGIN
    size := HIGH(input);
    Sort();

    result[0] := input[0];
    result[2] := Median(input,0,size);
    result[4] := input[size];

    m := size / 2;
    IF (size MOD 2 = 1) THEN
        low := m
    ELSE
        low := m - 1
    END;
    result[1] := Median(input, 0, m);
    result[3] := Median(input, m+1, size);

    RETURN result;
END Fivenum;

TYPE
    A6 = ARRAY[0..5] OF LONGREAL;
    A11 = ARRAY[0..10] OF LONGREAL;
    A20 = ARRAY[0..19] OF LONGREAL;
VAR
    a6 : A6;
    a11 : A11;
    a20 : A20;
BEGIN
    a11 := A11{15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0};
    WriteArray(Fivenum(a11));
    WriteLn;
    WriteLn;

    a6 := A6{36.0, 40.0, 7.0, 39.0, 41.0, 15.0};
    WriteArray(Fivenum(a6));
    WriteLn;
    WriteLn;

    a20 := A20{
        0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
        -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
        -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
        0.75775634,  0.32566578
    };
    WriteArray(Fivenum(a20));
    WriteLn;

    ReadChar
END Fivenum.
