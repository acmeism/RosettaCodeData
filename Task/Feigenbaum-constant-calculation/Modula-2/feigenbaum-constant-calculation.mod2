MODULE Feigenbaum;
FROM FormatString IMPORT FormatString;
FROM LongStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i,j,k,max_it,max_it_j : INTEGER;
    a,x,y,d,a1,a2,d1 : LONGREAL;
BEGIN
    max_it := 13;
    max_it_j := 10;

    a1 := 1.0;
    a2 := 0.0;
    d1 := 3.2;

    WriteString(" i       d");
    WriteLn;
    FOR i:=2 TO max_it DO
        a := a1 + (a1 - a2) / d1;
        FOR j:=1 TO max_it_j DO
            x := 0.0;
            y := 0.0;
            FOR k:=1 TO INT(1 SHL i) DO
                y := 1.0 - 2.0 * y * x;
                x := a - x * x
            END;
            a := a - x / y
        END;
        d := (a1 - a2) / (a - a1);
        FormatString("%2i    ", buf, i);
        WriteString(buf);
        RealToStr(d, buf);
        WriteString(buf);
        WriteLn;
        d1 := d;
        a2 := a1;
        a1 := a
    END;

    ReadChar
END Feigenbaum.
